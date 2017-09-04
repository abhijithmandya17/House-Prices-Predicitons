# Kaggle Housing Competition

library(randomForest)
library(tidyverse)
library("party")
source("preprocess.R")

# This file houses the code for the non-parametric approach

# Get the data in
res <- preprocess(0.1)
train <- as.data.frame(res$train)
test <- as.data.frame(res$test)

# Make sure all factors are the same level
for(i in 1:(ncol(train) - 1)){
  if(is.factor(unlist(train[, i]))){
    levels(test[, i]) <- levels(train[, i])
  }
}

# All predictors
rand <- randomForest(SalePrice ~ . - Id, train, ntree = 3000)
preds <- predict(rand, test)

preds2 <- predict(rand2, test)

results <- data.frame(as.integer(test$Id), preds2)
colnames(results) <- c("Id", "SalePrice")
write_csv(results, "submission_rf.csv")
