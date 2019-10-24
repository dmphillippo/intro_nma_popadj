## 01. Plaque Psoriasis (FE, contrast data)

# Q1: Run the following code. Check that you understand what is going on at each step.

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

# Run a FE NMA
pso_contr_fe <- nma(pso_contr_net, 
                    trt_effects = "fixed",
                    prior_trt = normal(scale = 10),
                    iter = 2000)

# Q2: Print the results
pso_contr_fe

# Q3: What is the estimated log OR and 95% CrI for IXE Q2W vs. Placebo?

# Extra Q: What is the estimate of IXE Q2W vs. SEC 300?

