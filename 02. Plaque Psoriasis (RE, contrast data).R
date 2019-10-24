## 02. Plaque Psoriasis (RE, contrast data)

library(multinma)
library(readr)

# Set Stan chains to run in parallel
options(mc.cores = parallel::detectCores())

# Read in psoriasis data
pso_contr <- read_csv("./data/psoriasis_contrast.csv")

pso_contr

# Define the network
pso_contr_net <- set_agd_contrast(pso_contr, 
                                  study = studyc,
                                  trt = trtc,
                                  y = logOR,
                                  se = se,
                                  trt_ref = "PBO")

pso_contr_net

# Q1: Modify the following code to fit a Random Effects model
# Q2: Specify a half-N(0, 2^2) prior on the between-study heterogeneity tau

# Run a Random Effects NMA
pso_contr_re <- nma(pso_contr_net, 
                    trt_effects = "fixed",
                    prior_trt = normal(scale = 10),
                    iter = 2000)

print(pso_contr_re, pars = c("d", "tau"))

# Q3: The FE model has the following model fit statistics:
#
#   Residual deviance: 27 (on 11 data points)
#                  pD: 0.9
#                 DIC: 27.8
#
# Use the function dic() on the fitted RE model. Which model do you prefer?

