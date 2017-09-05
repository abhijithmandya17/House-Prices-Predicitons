# Ben Greenawald, Abhijith Mandya ,	Gregory Wert

# Kaggle Housing Competition

library(tidyverse)
library(class)
library(caret)

source("preprocess.R")

# This file houses the code for the non-parametric approach

# Get the data in
res <- preprocess()
train <- as.data.frame(res$train)
test <- as.data.frame(res$test)

#create backup of data in case we need the original
train_bkup <-  train
test_bkup <-  test

#drop the response variable from testing
train$SalePrice = NULL

#normalize the numeric variables in the train and test sets
num_vars_train <-  sapply(train, is.numeric)
train <-train[, num_vars_train==TRUE]
train <- as.data.frame(lapply(train, scale))

num_vars_test <- sapply(test, is.numeric)
test <- test[num_vars_test==TRUE]
test <- as.data.frame(lapply(test, scale))

#run the KNN prediction
pred_knn <- knn.cv(train, as.vector(train_bkup$SalePrice), k=37)

# Try using knn regression
pred_knn2 <- knnreg(train, as.vector(train_bkup$SalePrice), k = 37)
preds <- predict(pred_knn2, test)

#organize it into a a dataframe
results <- data.frame(as.integer(test_bkup$Id), preds)
colnames(results) <- c("Id", "SalePrice")
write_csv(results, "submission_knn.csv")




