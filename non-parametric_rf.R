# Ben Greenawald, Abhijith Mandya ,	Gregory Wert

# Kaggle Housing Competition

library(randomForest)
library(tidyverse)
library("party")
source("preprocess.R")

# This file houses the code for the non-parametric approach

# Get the data in
res <- preprocess()
train <- as.data.frame(res$train)
test <- as.data.frame(res$test)

# Make sure all factors are the same level
for(i in 1:(ncol(train) - 1)){
  if(is.factor(unlist(train[, i]))){
    levels(test[, i]) <- levels(train[, i])
  }
}

# Setseed for reproducibility
set.seed(123)

# All predictors
rand <- randomForest(SalePrice ~ . - Id, train, ntree = 3000)
preds <- predict(rand, test)

# Perform cross validation to find the optimal number of predictors
trainx <- train[, 1:ncol(train) - 1]
trainy <- train[, ncol(train)]
res <- rfcv(trainx, trainy)
# Plot the error vs. the number of variables
with(res, plot(n.var, error.cv, log="x", type="o", lwd=2))

# Use the random forest model to ge the 20 most important predictors
importance(rand)
varImpPlot(rand, n.var = 20)

# Remake the model using the 20 most important predictors
rand2 <- randomForest(SalePrice ~ OverallQual + Neighborhood + GrLivArea +
                        ExterQual + GarageCars + TotalBsmtSF + FirstFloorSF + 
                        GarageArea + KitchenQual + SecondFloorSF + YearBuilt + 
                        BsmtFinSF1 + BsmtQual + LotArea + FullBath + TotRmsAbvGrd + 
                        FireplaceQu + Exterior2nd + YearRemodAdd + Exterior1st, 
                        data = train, ntree = 3000)
preds2 <- predict(rand2, test)
# This method did not outperform the full method

results <- data.frame(as.integer(test$Id), preds)
colnames(results) <- c("Id", "SalePrice")
write_csv(results, "submission_rf.csv")
