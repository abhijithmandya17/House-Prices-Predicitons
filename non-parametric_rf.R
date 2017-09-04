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

# n <- sample(1:nrow(train), size = nrow(train) * 0.8)
# train1 <- train[n, -c(1)]
# # response <- train[n, ncol(train)]
# test1 <- train[-n, -c(1, ncol(train))]
# true <- train[-n, ncol(train)]

rand <- randomForest(SalePrice ~ . - Id, train, ntree = 3000, importance = T)
preds <- predict(rand, test)


results <- data.frame(as.integer(test$Id), preds)
colnames(results) <- c("Id", "SalePrice")
write_csv(results, "submission_rf.csv")
