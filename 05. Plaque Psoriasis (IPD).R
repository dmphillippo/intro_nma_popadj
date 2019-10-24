## Solution 05. Plaque Psoriasis (IPD)

library(multinma)

# Set Stan chains to run in parallel
options(mc.cores = parallel::detectCores())

# Simulated Psoriasis IPD is available in multinma package
pso_ipd <- psoriasis_ipd
head(pso_ipd)

# Q1: Fit a Fixed Effect NMA to the psoriasis IPD
#   - Adjust for the covariates prevsys, durnpso, bsa, weight, and psa,
#     including both prognostic terms and EM interactions
#   - Use a N(0, 10^2) prior for the the intercepts, treatment effects, and the
#     regression terms

# Re-scale the continuous covariates 
#  - improves sampling efficiency if closer to unit scale
#  - easier interpretation

pso_ipd$durnpso <- pso_ipd$durnpso / 10
pso_ipd$bsa <- pso_ipd$bsa / 100
pso_ipd$weight <- pso_ipd$weight / 10

# Set prevsys and psa to be factors
pso_ipd$prevsys <- factor(pso_ipd$prevsys)
pso_ipd$psa <- factor(pso_ipd$psa)

# Define the network
pso_ipd_net <- set_ipd(???,
                       trt_ref = "PBO")

pso_ipd_net

# Fit a FE NMA to the IPD, adjusting for the covariates
# Set QR = TRUE to use a more efficient parameterisation
pso_ipd_fe <- nma(???)

pso_ipd_fe

# Q2: Interpret the meaning of:
#  - d[IXE_Q2W]
#  - beta[durnpso]
#  - beta[IXE_Q2W:durnpso]

# d[IXE_Q2W] is the log OR vs. placebo for an individual:
#   without previous systemic treatment or psoriatic arthritis,
#   at 18.5 years duration of psoriasis,
#   with 27% body surface area covered,
#   with a weight of 91.4 kg.

# beta[durnpso] is the change in log odds of PASI 75 per 10 years duration of psoriasis

# beta[IXE_Q2W:durnpso] is the change in the log OR for IXE Q2W vs. placebo per
# 10 years duration of psoriasis
