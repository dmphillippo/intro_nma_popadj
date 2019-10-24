## Construct different data formats for the Plaque Psoriasis examples

library(multinma)
library(dplyr)
library(readr)


# Contrast data (AgD) -----------------------------------------------------
psoriasis_contr <- 
  # Aggregate IPD
  psoriasis_ipd %>% 
  group_by(studyc, studyn, trtc, trtn) %>% 
  summarise(pasi75_r = sum(pasi75), pasi75_n = n()) %>% 
  # Add in AgD
  bind_rows(psoriasis_agd) %>% 
  group_by(studyn) %>% 
  mutate(arm = 1:n(),
         # Apply continuity correction
         cc = any(pasi75_r == 0),
         pasi75_n = if_else(cc, pasi75_n + 0.5, pasi75_n),
         pasi75_r = if_else(cc, pasi75_r + 0.5, pasi75_r),
         # For baseline arm, set logOR = NA
         logOR = if_else(arm == 1, 
                         NA_real_,
                         log(pasi75_r * first(pasi75_n - pasi75_r) / ((pasi75_n - pasi75_r) * first(pasi75_r)))),
         # For baseline arm, set SE equal to SE of log odds on baseline arm
         se = sqrt(if_else(arm == 1,
                           1 / pasi75_r + 1 / (pasi75_n - pasi75_r),
                           1 / pasi75_r + 1 / (pasi75_n - pasi75_r) + 
                             1 / first(pasi75_r) + 1 / first(pasi75_n - pasi75_r)))) %>% 
  select(studyc, studyn, trtc, trtn, logOR, se)

write_csv(psoriasis_contr, "./data/psoriasis_contrast.csv")


# Arm data (AgD) ----------------------------------------------------------
psoriasis_arm <- 
  # Aggregate IPD
  psoriasis_ipd %>% 
  group_by(studyc, studyn, trtc, trtn) %>% 
  summarise(pasi75_r = sum(pasi75), pasi75_n = n()) %>% 
  # Add in AgD
  bind_rows(psoriasis_agd) %>% 
  select(studyc, studyn, trtc, trtn, pasi75_r, pasi75_n)

write_csv(psoriasis_arm, "./data/psoriasis_arm.csv")
