## 00. Getting started

# The following steps were contained in the "Pre-Course Instructions" document. 
# If you have already completed these steps, there is no need to do so again.
# If you have not, please do so now.


# Install the `tidyverse` suite of packages and the `devtools` package:
install.packages("tidyverse")
install.packages("devtools")


# Follow the instructions at
# https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started to install the
# `rstan` package. You will need build tools for R installed; if you do not, you
# will be prompted to install these as follows:
#  * If you use Windows and RStudio (recommended), a pop-up will appear asking
#    if you want to install Rtools. Click Yes and wait until the installation is
#    finished.
#  * If you use Windows but not RStudio, a message will appear in the R console
#    telling you to install Rtools.
#  * If you use a Mac, a link will appear but do not click on it. Instead go
#    to https://github.com/stan-dev/rstan/wiki/Installing-RStan-from-source-on-a-Mac#prerequisite--c-toolchain-and-configuration
#  * If you use Linux (including Windows Subsystem for Linux), then go to
#    https://github.com/stan-dev/rstan/wiki/Installing-RStan-on-Linux

install.packages("rstan")
pkgbuild::has_build_tools(debug = TRUE)

                                                                                 
# Now install the `multinma` package from GitHub. This may take 15 minutes or so.
devtools::install_github("dmphillippo/multinma") 
