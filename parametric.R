# Kaggle Housing Competition
install.packages("DAAG")
library(DAAG)
library(tidyverse)

source("preprocess.R")

# This file houses the code for the parametric approach
# Get the data in
res <- preprocess()
train <- res$train
test <- res$test

parametic.lm <- lm(SalePrice ~ . -Id, data = train)

summary(parametic.lm)

step(parametic.lm,direction = "both")

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

summary(lm.1)

# Now let's make a prediction
Prediction <- predict(lm.1, newdata = test)

#write a submission file
Prediction <- data.frame(Prediction)
submission <- cbind(test$Id,Prediction)
colnames(submission) <- c("Id", "SalePrice")
write.csv(submission, file = "linear_model.csv", row.names = FALSE)

