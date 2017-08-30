# Kaggle Housing Competition

library(tidyverse)

source("preprocess.R")

# This file houses the code for the non-parametric approach

# Get the data in
res <- preprocess(T, 0.1)
train <- res$train
test <- res$test


n <- sample(1:nrow(train), size = nrow(train) * 0.8)
train1 <- train[n, -c(1)]
# response <- train[n, ncol(train)]
test1 <- train[-n, -c(1, ncol(train))]
true <- train[-n, ncol(train)]

for(i in 1:ncol(train1)-1){
  if(is.factor(unlist(train1[, i]))){
    levels(train1[, i]) <- unique(union(levels(train1[, i]), levels(test1[, i])))
    levels(test1[, i]) <- unique(union(levels(train1[, i]), levels(test1[, i])))
  }
}

rand <- randomForest(SalePrice ~ ., train1)
spreds <- predict(rand, test1)