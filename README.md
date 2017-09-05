# sys6018-competition-house-prices

## Objective:
The [House Prices](https://www.kaggle.com/c/house-prices-advanced-regression-techniques) competition on Kaggle is a test of advanced regression techniques. With 79 explanatory variables describing (almost) every aspect of residential homes in Ames, Iowa, this competition challenges you to predict the final price of each home.

# Team

All team members participated in all parts of the assignment as to ensure even distribution of work, but the primary responsibilities of each team member was as follows:

* Ben Greenawald - Github coordinator and primary author of the preprocessing script and random forest implementation.

* Abhijith Mandya - Primary author of the linear model and gradient boost model.

* Gregory Wert - Primary author of the KNN model.

  ​

## Methodology

### Preprocessing
Both the train and test data were run through a preprocessing script
to ensure that the algorithms had clean data. The preprocessing pipeline was as follows.
* Read in raw data
* Rename the columns whose names started with numbers as these caused problems with
  some of the function used
* Create a level for "NA" categorical variables. Note that per the data description
  file, for most of the predictors, "NA" did not mean missing data, but instead meant 
  something in the context of the data. For columns that has this property, the "NA" 
  were replaced with "None" to allow this to be a level in the factor.
* Convert all character columns to factors.
* Replace any "NA" values in numeric columns with the mean of the column.
* Replace any "NA" values in categorical variables with the most common factor level
  for that column.
* Optionally, scale the numeric data in accordance with ISL 6.6.

### Parametric approach
After preprocessing, a linear model was setup using all variables. Then, 
this model was passed into the step function which did bidirectional variable
selection to arrive at the best model using AIC as a metric. Using the output
of the step function, the "vif" function was used to see if there was any
multicollinearity in the new model. Some columns were found to have a high
value of multicollinearity and were dropped as appropriate (while this brought up
the R^2, the test MSE dropped). Independently, model were being tested using a 10-fold
cross validation, and the model from the step function without multicolinear predictors
also had the lowest average MSE from the cross validation, thus this model was clearly
the superior choice.

### Non-parametric approach

#### KNN Test
We ran a KNN Test upon the train data. To accomplish this we had to manipulate the data further. We excluded the non-numeric factors in the train and the test data. Doing this allowed us to chart out the points so as to begin the KNN test. From there, we normalized the numeric data in both sets to even out the distance distributions. This then led to us running a regular KNN test on the data. We chose to set the k at 38 due to its value as the square of observations. We also ran a regression KNN regression since our numeric data was often continuous. The regression KNN yielded superior results
over the generic KNN. The KNN was unable to outperform the linear model in the end, this is likely because so much data was lost when factor predictors were dropped.

#### Random Forest
The KNN did not yield the results that we were hoping for. Because we can only use numeric inputs, a great deal of data was lost. We wanted a non-parametric method to accommodate factor predictors, and random forest was selected as we had previous experience with it. First, a random forest was created with all predictors except Id. Some tinkering was done with number of trees and 3000 seemed to give the lowest test MSE. The random forest algorithm already outperformed the KNN. Then, a 5-fold cross validation was performed to determine the optimal number of predictors. It was found that 20 predictors seemed to be optimal. The 20 most important predictors were found using the "importance" function and a new model was created on these. Using these new variables, a new random forest was created. The number of trees was again tinkered with, but it seemed clear that the new forest with only 20 variables was not outperforming the full model on the true test data, thus the full model was kept.

#### Gradient Boost

The random forest was an improvement on the random forest model, but still was not giving us the results that we wanted. 

## Findings

As predicted, on a complicated data set like this one, non-parametric methods outperformed the parametric methods. Further, the KNN seemed to underperform the rest of the non-parametric methods, and even the parametric ones, likely because so much data was lost since factor variables could not be used. The clear overall best model was the gradient boosted random forest.

## Conclusion and Kaggle Score

The final submission was a for the gradient boosted random forest as it had by far the highest performance on the public Kaggle score. Below are the best result for each type of model created. Note that set.seed was not used so results are not necessarily reproducible, these are merely the  highest Kaggle scores for submission using each algorithm.

* Multiple Linear Regression Model: 0.16147
* KNN Regression: 0.18731
* Random Forest: 0.15169
* Random Forest with Gradient Boost: 0.12534