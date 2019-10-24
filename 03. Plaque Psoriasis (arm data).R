## 03. Plaque Psoriasis (arm data)

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
                           study = ,
                           trt = ,
                           r = ,
                           n = ,
                           trt_ref = "PBO")

pso_arm_net

# Run a Fixed Effects NMA
# Use a N(0, 10^2) prior for the treatment effects and study intercepts
pso_arm_fe <- nma()

# Print the results


# Run a Random Effects NMA
# Use a N(0, 10^2) prior for the treatment effects and study intercepts, and a
# half-N(0, 2^2) prior for the heterogeneity sd
pso_arm_re <- nma()

# Print the results


# Q2: Compare the model fits


# Q3: Compare the results to those from the contrast (log OR) data
# We previously saved these results as pso_contr_fe and pso_contr_re
