## Solution 04. Smoking Cessation (inconsistency)

library(multinma)
library(readr)

# Set Stan chains to run in parallel
options(mc.cores = parallel::detectCores())

# Smoking cessation data is available in the multinma package
head(smoking)

# Q1: Modify the following code to fit an unrelated mean effects model.

# Define the network
smk_net <- set_agd_arm(smoking,
                       study = studyn,
                       trt = trtc,
                       r = r,
                       n = n,
                       trt_ref = "No intervention")

smk_net

# Run a Random Effects UME model (inconsistency)
smk_ume <- nma(smk_net, 
               trt_effects = "random",
               consistency = "ume",
               prior_trt = normal(scale = 10),
               prior_intercept = normal(scale = 10),
               prior_het = half_normal(scale = 2))

smk_ume

# Run a Random Effects NMA (consistency)
smk_re <- nma(smk_net, 
              trt_effects = "random",
              prior_trt = normal(scale = 10),
              prior_intercept = normal(scale = 10),
              prior_het = half_normal(scale = 2))

smk_re


# Q2: Examine the model fit statistics, heterogeneity SD, and the dev-dev plot

# Model fit statistics
dic(smk_ume)
dic(smk_re)

# Heterogeneity SD
print(smk_ume, pars = "tau")
print(smk_re, pars = "tau")

# Dev-dev plot
library(ggplot2)

resdev_dat <- data.frame(
  Consistency = dic(smk_re)$pointwise$agd_arm$resdev,
  Inconsistency = dic(smk_ume)$pointwise$agd_arm$resdev
)

ggplot(resdev_dat, aes(x = Consistency, y = Inconsistency)) +
  geom_abline(slope = 1) +
  geom_point() +
  coord_equal()


# Q3: What do you conclude about the presence of inconsistency?
# No difference in model fit, no reduction in heterogeneity, no points fit
# better under UME model (points on line of equality). No evidence of
# inconsistency.
