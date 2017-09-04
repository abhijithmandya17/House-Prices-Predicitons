# Kaggle Housing prices competition

library(tidyverse)

# Preprocess --------------------------------------------------------------

# Run the preprocessing script based on a given directory
# @param Guess indicates whether missing factor values should be guess or 
# if NA should be it's own level
# @cutoff What the threshold is for removing a column due to too many NA values
preprocess <- function(scale = F){
  
  # Read in the train and test data
  train <- read_csv("train.csv")
  test <- read_csv("test.csv")
  
  complete_train <- train %>% 
    rename_cols() %>% 
    add_None() %>% 
    to_factor()  %>% 
    fill_na_num() %>% 
    fill_na_fac() 
  
  if(scale){
    complete_train <- scale_numeric(complete_train)
  }
  
  complete_test <- test %>% 
    rename_cols() %>% 
    add_None() %>% 
    to_factor()  %>% 
    fill_na_num() %>% 
    fill_na_fac()
  
  if(scale){
    complete_test <- scale_numeric(complete_test)
  }
  
  # Return the final processed train and test set
  ret <- list()
  ret$train <- complete_train
  ret$test <- complete_test
  return(ret)
}


# Function to drop problem columns based on density of NA values
drop_cols <- function(df, threshold){
  problem_columns <- c()
  for(i in 1:ncol(df)){
    if(sum(is.na(df[, i]))/nrow(df) > threshold){
      print(paste("Dropping: ", names(df[, i])))
      problem_columns <- c(problem_columns, names(df[, i]))
    }
  }
  
  return(problem_columns)
}

# Converts all characters columsn to factors
to_factor <- function(df){
  for(i in colnames(df)){
    text <- sprintf("df$\'%s\'", i)
    res <- eval(parse(text = text))
    if(is.character(res)){
      text2 <- sprintf("df$\'%s\' <- as.factor(df$\'%s\')", i, i)
      eval(parse(text = text2))
    }
  }
  
  return(df)
}

# Function to fill in numeric NA with the mean
fill_na_num <- function(df){
  for(i in colnames(df)){
    text <- sprintf("df$\'%s\'", i)
    res <- eval(parse(text = text))
    if(is.numeric(res)){
      text2 <- sprintf("df$\'%s\'[is.na(df$\'%s\')] <- mean(df$\'%s\', na.rm = T)", i, i, i)
      eval(parse(text = text2))
    }
  }
  
  return(df)
}

# Fill in the missing categorical data with the most common category
fill_na_fac <- function(df){
    for(i in colnames(df)){
      text <- sprintf("df$\'%s\'", i)
      res <- eval(parse(text = text))
      if(is.factor(res)){
        text2 <- sprintf("df$\'%s\'[is.na(df$\'%s\')] <- names(which.max(table(df$\'%s\')))", i, i, i)
        eval(parse(text = text2))
      }
    }
    return(df)
}

# Rename the problematic columns
rename_cols <- function(df){
  colnames(df)[names(df) == '1stFlrSF'] <- 'FirstFloorSF'
  colnames(df)[names(df) == '2ndFlrSF'] <- 'SecondFloorSF'
  colnames(df)[names(df) == '3SsnPorch'] <- 'ThirdSsnPorch'
  return(df)
}

# Add none's
add_None <- function(df){
  var_names <- c("BsmtQual",
                 "BsmtCond",
                 "BsmtExposure",
                 "BsmtFinType1",
                 "BsmtFinType2",
                 "FireplaceQu",
                 "GarageType",
                 "GarageFinish",
                 "GarageQual",
                 "GarageCond",
                 "PoolQC",
                 "MiscFeature",
                 "Fence")
  for(i in var_names){
    text <- sprintf("df$\'%s\'", i)
    res <- eval(parse(text = text))
    if(is.character(res)){
      text2 <- sprintf("df$\'%s\'[is.na(df$\'%s\')] <- \"None\"", i, i)
      eval(parse(text = text2))
    }
  }
  
  return(df)
}

# Scale the numeric columns
scale_numeric <- function(df){
  for(i in colnames(df)){
    text <- sprintf("df$\'%s\'", i)
    res <- eval(parse(text = text))
    if(is.numeric(res) && i != "Id"){
      text2 <- sprintf("df$\'%s\' <- df$\'%s\'/sqrt(length(df$\'%s\')*sum((df$\'%s\' - mean(df$\'%s\'))^2))", i, i, i, i, i)
      eval(parse(text = text2))
    }
  }
  
  return(df)
}
