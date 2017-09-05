# Kaggle Housing Competition
# K Nearest Neighbor approach to Non-parametric modelling
# Ben Greenawald, Abhijith Mandya, Gregory Wert

#load in libraries
library(tidyverse)
library(class)
library('FNN')
source("preprocess.R")

#set seed
set.seed(66)

#load in train and test sets
res <- preprocess()
train <- as.data.frame(res$train)
test <- as.data.frame(res$test)

#create backup of data in case we need the original
train_bkup = train
test_bkup = test

#drop the response variable from the train set
train$SalePrice = NULL

#drop Ids from train and test case
train$Id = NULL
test$Id = NULL

#filter out the non numeric variables in the train and test sets
num_vars_train = sapply(train, is.numeric)
train = train[num_vars_train==TRUE]
num_vars_test = sapply(test, is.numeric)
test = test[num_vars_test==TRUE]

#normalize the numeric variables in the train and test sets
train = as.data.frame(lapply(train, scale))
test = as.data.frame(lapply(test, scale))

#run the KNN prediction
pred_knn_base = knn(train, test, train_bkup$SalePrice, k=38)

#run a KNN regression prediction
pred_knn = knn.reg(train, test, train_bkup$SalePrice, k=38)

#organize it into a a dataframe
results = data.frame(as.integer(test_bkup$Id), pred_knn$pred)
colnames(results) <- c("Id", "SalePrice")

#write out results to a CSV file
write_csv(results, "submission_knn.csv")

