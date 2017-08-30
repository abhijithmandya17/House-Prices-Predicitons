# Kaggle Housing Competition

library(tidyverse)

source("preprocess.R")

# This file houses the code for the parametric approach

# Get the data in
res <- preprocess(F, 0.1)
train <- res$train
test <- res$test
