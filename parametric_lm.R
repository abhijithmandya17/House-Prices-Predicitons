# Ben Greenawald, Abhijith Mandya ,	Gregory Wert

# Kaggle Housing Competition
library(tidyverse)
library(DAAG)
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
lm.1 <- lm(SalePrice ~ MSSubClass + MSZoning + LotArea + Street + 
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

#Check for multicolinearity, remove those with a compound value of 5 or higher
vif(lm.1)


lm.2 <- lm(SalePrice ~ OverallQual+ Neighborhood + GrLivArea+ 
           TotalBsmtSF+ BsmtFinSF1+ GarageCars+ FirstFloorSF+ 
           LotArea+ GarageArea+ KitchenQual+ SecondFloorSF+
           BsmtQual+ TotRmsAbvGrd+ ExterQual+ FullBath+ MasVnrArea, train)

#Check summary: Although R squared was lower, it was less complex and had more room to manuvure in the actual test.
#This model compared to lm.1 brought down the score from .20 to 16. Thus we chose to stick with this model
summary(lm.2)

#Cross validate the data with 10 folds to find averaged MSE of 1.2e+09, sqrt(1.2e+09) = 34641
#This was the best average MSE from all the models tested
cv.lm(train, lm.2, m=10, dots = FALSE, seed=21, plotit=TRUE, printit=TRUE)

# Now let's make a prediction
Prediction <- predict(lm.2, newdata = test)

#write a submission file
Prediction <- data.frame(Prediction)
submission <- cbind(test$Id,Prediction)
colnames(submission) <- c("Id", "SalePrice")
write.csv(submission, file = "submission_lm.csv", row.names = FALSE)