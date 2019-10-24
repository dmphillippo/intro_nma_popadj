## Solution 03. Plaque Psoriasis (arm data)

library(multinma)
library(readr)

# Set Stan chains to run in parallel
options(mc.cores = parallel::detectCores())

# Read in psoriasis data
pso_arm <- read_csv("./data/psoriasis_arm.csv")

pso_arm

# Q1: Fill in the blanks in the following code. Run the FE and RE NMAs.

# Define the network
pso_arm_net <- set_agd_arm(pso_arm,
                           study = studyc,
                           trt = trtc,
                           r = pasi75_r,
                           n = pasi75_n,
                           trt_ref = "PBO")

pso_arm_net

# Run a Fixed Effects NMA
pso_arm_fe <- nma(pso_arm_net, 
                  trt_effects = "fixed",
                  prior_trt = normal(scale = 10),
                  prior_intercept = normal(scale = 10))

pso_arm_fe

# Run a Random Effects NMA
pso_arm_re <- nma(pso_arm_net, 
                  trt_effects = "random",
                  prior_trt = normal(scale = 10),
                  prior_intercept = normal(scale = 10),
                  prior_het = half_normal(scale = 2))

print(pso_arm_re, pars = c("d", "tau"))

# Q2: Compare the model fits

dic(pso_arm_fe)

dic(pso_arm_re)

