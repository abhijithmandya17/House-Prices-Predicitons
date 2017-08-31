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

step(parametic.lm)

summary(lm.1)

# Let's subset to cross validate
sub <- sample(1:1460,size=730)
s1.train <- train[sub,]     # Select subset for cross-validation
s1.valid <- train[-sub,]

lm.1 <- lm(formula = SalePrice ~ MSSubClass + MSZoning + LotArea + Street + 
             LandContour + Utilities + LotConfig + LandSlope + Neighborhood + 
             Condition1 + Condition2 + BldgType + OverallQual + OverallCond + 
             YearBuilt + YearRemodAdd + RoofStyle + RoofMatl + Exterior1st + 
             MasVnrType + MasVnrArea + ExterQual + BsmtQual + BsmtCond + 
             BsmtExposure + BsmtFinType1 + BsmtFinSF1 + BsmtFinSF2 + BsmtUnfSF + 
             `1stFlrSF` + `2ndFlrSF` + FullBath + BedroomAbvGr + KitchenAbvGr + 
             KitchenQual + TotRmsAbvGrd + Functional + Fireplaces + GarageFinish + 
             GarageCars + GarageArea + GarageQual + GarageCond + WoodDeckSF + 
             ScreenPorch + PoolArea + MoSold + SaleCondition, data = s1.train)

# Let's try the full model on the validation set
probs<-as.vector(predict(s1.lg,newdata=s1.valid, type="response"))

