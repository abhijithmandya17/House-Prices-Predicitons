# Kaggle Housing Competition

library(tidyverse)

source("preprocess.R")

# This file houses the code for the non-parametric approach

# Get the data in
res <- preprocess()
train <- res$train
test <- res$test