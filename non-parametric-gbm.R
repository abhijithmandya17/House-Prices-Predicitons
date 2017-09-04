#Call library for gradient boost
library("gbm")

#Call preprocessing script
source("preprocess.R")

# This file houses the code for the non-parametric approach

# Get the data in
res <- preprocess(0.1)
train <- as.data.frame(res$train)
test <- as.data.frame(res$test)

#Create model using required parameters
#distribution is gaussian as we are regressing the outcome variable
#number of tress is set to a high number and can be pruned later on based on best fit
#interaction.depth tells the model to inspect colinearlity and interactivity within the predictor variables
#Since we have many subsets of variables, a higher number ensures better resolution of relationships
#n.minobsinnode controls node division protecting against overfitting
#shirnkage is the learning rate, an optimum rate must be divised based on cross validation
mod <- gbm.fit(x = train[,-81], y = train$SalePrice, distribution = "gaussian", 
               n.tree = 3000, interaction.depth = 10, shrinkage = 0.01,
               n.minobsinnode = 10, verbose = T)


#Model summary provides a ranking order of importance for each variable.
summary(mod)

#Provides a boundry tree number beyond which the learning stops 
gbm.perf(mod, method = "OOB")


#Predict test data with 200 trees 
predict <- predict(mod, test, n.trees = 2000, type = "response")

#Create result set for submission
results <- data.frame(as.integer(test$Id), predict)
colnames(results) <- c("Id", "SalePrice")
write.csv(results, "submission_gbm.csv", row.names = F)
