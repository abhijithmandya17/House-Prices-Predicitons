# Kaggle Housing Competition

library(tidyverse)
library(class)

source("preprocess.R")

# This file houses the code for the non-parametric approach

# Get the data in
res <- preprocess(0.1)
train <- as.data.frame(res$train)
test <- as.data.frame(res$test)

#create backup of data in case we need the original
train_bkup = train
test_bkup = test

#drop the response variable from testing
train$SalePrice = NULL

#drop non numeric variables in the train and test data
train$Id = NULL
train$YearBuilt = NULL
train$YearRemodAdd = NULL
train$YrSold = NULL
train$GarageYrBlt = NULL

test$Id = NULL
test$YearBuilt = NULL
test$YearRemodAdd = NULL
test$YrSold = NULL
test$GarageYrBlt = NULL

#normalize the numeric variables in the train and test sets
num_vars_train = sapply(train, is.numeric)
train = train[num_vars_train==TRUE]
train = as.data.frame(lapply(train, scale))

num_vars_test = sapply(test, is.numeric)
test = test[num_vars_test==TRUE]
test = as.data.frame(lapply(test, scale))

#run the KNN prediction
pred_knn = knn(train, test, train_bkup$SalePrice, k=38)

#organize it into a a dataframe
results = data.frame(as.integer(test_bkup$Id), pred_knn)
colnames(results) <- c("Id", "SalePrice")
write_csv(results, "submission_knn.csv")




