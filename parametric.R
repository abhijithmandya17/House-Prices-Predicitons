# Kaggle Housing Competition
library(tidyverse)

source("preprocess.R")

# This file houses the code for the parametric approach
# Get the data in
res <- preprocess()
train <- res$train
test <- res$test

#Test complete model with all variables
parametic.lm <- lm(SalePrice ~ . -Id, data = train)

#Find R squared
summary(parametic.lm)

#Run a step function to find the most optimal factors
step(parametic.lm,direction = "both")

#Based on step results re-train model
lm.1 <- lm(formula = SalePrice ~ MSSubClass + MSZoning + LotArea + Street + 
     LandContour + Utilities + LotConfig + LandSlope + Neighborhood + 
     Condition1 + Condition2 + BldgType + OverallQual + OverallCond + 
     YearBuilt + YearRemodAdd + RoofStyle + RoofMatl + Exterior1st + 
     MasVnrType + MasVnrArea + ExterQual + BsmtQual + BsmtCond + 
     BsmtExposure + BsmtFinSF1 + BsmtFinSF2 + BsmtUnfSF + FirstFloorSF + 
     SecondFloorSF + BsmtFullBath + FullBath + BedroomAbvGr + 
     KitchenAbvGr + KitchenQual + TotRmsAbvGrd + Functional + 
     Fireplaces + GarageCars + GarageArea + GarageQual + GarageCond + 
     WoodDeckSF + ScreenPorch + PoolArea + PoolQC + Fence + MoSold + 
     SaleCondition, data = train)

#Check for an imporved R squared
summary(lm.1)

# Now let's make a prediction
Prediction <- predict(lm.1, newdata = test)


#write a submission file
Prediction <- data.frame(Prediction)
submission <- cbind(test$Id,Prediction)
colnames(submission) <- c("Id", "SalePrice")
write.csv(submission, file = "linear_model.csv", row.names = FALSE)

