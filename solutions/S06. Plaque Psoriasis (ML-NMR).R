## Solution 06. Plaque Psoriasis (ML-NMR)

library(multinma)
library(dplyr)

# Set Stan chains to run in parallel
options(mc.cores = parallel::detectCores())

# Simulated Psoriasis IPD is available in multinma package
pso_ipd <- psoriasis_ipd
head(pso_ipd)

# Along with AgD
pso_agd <- psoriasis_agd
pso_agd


# A very small proportion of individuals have missing covariate values.
cc <- complete.cases(pso_ipd)
sum(!cc)   # number of individuals with missing values
mean(!cc)  # proportion of individuals with missing values

# Take the complete cases only
pso_ipd <- pso_ipd[cc, ]


# Re-scale the continuous covariates 
#  - improves sampling efficiency if closer to unit scale
#  - easier interpretation

pso_ipd <- pso_ipd %>% 
  mutate(
    durnpso = durnpso / 10,
    bsa = bsa / 100,
    weight = weight / 10,
    # Set prevsys and psa to be factors
    # prevsys = factor(prevsys),
    # psa = factor(psa)
  )

pso_agd <- pso_agd %>% 
  mutate(
    durnpso_mean = durnpso_mean / 10,
    durnpso_sd = durnpso_sd / 10,
    bsa_mean = bsa_mean / 100,
    bsa_sd = bsa_sd / 100,
    weight_mean = weight_mean / 10,
    weight_sd = weight_sd / 10,
    # Convert AgD prevsys and psa to proportions
    prevsys = prevsys / 100,
    psa = psa / 100
  )


# Add a treatment class variable
pso_ipd <- pso_ipd %>% 
  mutate(tclass = recode_factor(trtn,
                                "1" = 1,   # Placebo
                                "2" = 2, "3" = 2, "5" = 2, "6" = 2,  # IL-* blockers
                                "4" = 3)   # TNFa blocker
  )

pso_agd <- pso_agd %>% 
  mutate(
    tclass = recode_factor(trtn,
                           "1" = 1,   # Placebo
                           "2" = 2, "3" = 2, "5" = 2, "6" = 2,  # IL-* blockers
                           "4" = 3)   # TNFa blocker
  )


# Define the network
pso_a_net <- set_agd_arm(pso_agd, 
                         study = studyc, trt = trtc,
                         r = pasi75_r, n = pasi75_n)

pso_i_net <- set_ipd(pso_ipd, 
                     study = studyc, trt = trtc,
                     r = pasi75)

pso_net <- combine_network(pso_a_net,
                           pso_i_net,
                           trt_ref = "PBO")

pso_net


# Exercise 6a -------------------------------------------------------------
# Complete the following code to add numerical integration points for
# bsa (as logit Normal), weight (as Gamma), and psa (as Bernoulli).

# Set up numerical integration
pso_net <- add_integration(pso_net,
                           durnpso = distr(qgamma, mean = durnpso_mean, sd = durnpso_sd),
                           prevsys = distr(qbern, prevsys),
                           bsa = distr(qlogitnorm, mean = bsa_mean, sd = bsa_sd),
                           weight = distr(qgamma, mean = weight_mean, sd = weight_sd),
                           psa = distr(qbern, psa),
                           n_int = 500)


# Exercise 6b -------------------------------------------------------------
# Complete the following code to fit a FE ML-NMR model
#   a.
# Adjust for the five covariates prevsys, durnpso, bsa, weight, and psa.
# Include both prognostic terms and *shared* effect modifier interactions by
# tclass.
#   b.
# Use a Normal(0, 10^2) prior for treatment effects, intercepts, and regresion
# terms
#   c.
# Do any covariates appear to be strong effect modifiers?

pso_mlnmr_fe <- nma(pso_net, 
                    trt_effects = "fixed",
                    regression = ~ prevsys + durnpso + bsa + weight + psa +
                      (prevsys + durnpso + bsa + weight + psa):tclass,
                    center = TRUE,
                    agd_sample_size = sample_size_w0,
                    QR = TRUE,
                    prior_trt = normal(scale = 10),
                    prior_intercept = normal(scale = 10),
                    prior_reg = normal(scale = 10))

pso_mlnmr_fe



# Exercise 6c -------------------------------------------------------------
# Check the model fit for the FE ML-NMR model.
# The model fit for the RE ML-NMR model is below, along with the estimated
# heterogeneity SD.
# Interpret.

dic(pso_mlnmr_fe)

# Fit a RE ML-NMR, to investigate residual heterogeneity
# This takes a while to run, so the results are summarised below
# pso_mlnmr_re <- nma(pso_net, 
#                     trt_effects = "random",
#                     regression = ~ prevsys + durnpso + bsa + weight + psa +
#                       (prevsys + durnpso + bsa + weight + psa):tclass,
#                     center = TRUE,
#                     agd_sample_size = sample_size_w0,
#                     QR = TRUE,
#                     prior_trt = normal(scale = 10),
#                     prior_intercept = normal(scale = 10),
#                     prior_reg = normal(scale = 10),
#                     prior_het = half_normal(scale = 2.5))
# 
# pso_mlnmr_re

# dic(pso_mlnmr_re) 
## Residual deviance: 2863.4 (on 3858 data points)
##                pD: 27.9
##               DIC: 2891.2

# print(pso_mlnmr_re, pars = "tau")
##     mean se_mean   sd 2.5%  25%  50%  75% 97.5% n_eff Rhat
## tau 0.49    0.01 0.31 0.06 0.28 0.43 0.63  1.28   583    1
