# Kaggle Housing prices competition

library(tidyverse)

# Preprocess --------------------------------------------------------------

# Run the preprocessing script based on a given directory
# @param Guess indicates whether missing factor values should be guess or 
# if NA should be it's own level
# @cutoff What the threshold is for removing a column due to too many NA values
preprocess <- function(cutoff = 0.1){
  
  # Read in the train and test data
  train <- read_csv("train.csv")
  test <- read_csv("test.csv")
  
  # Rename 
  rename_train <- rename_cols(train)
  rename_test <- rename_cols(test)
  
  # Convert all character to factors
  factor_train <- to_factor(rename_train)
  factor_test <- to_factor(rename_test)
  
  # Remove columns with high NA density
  problem_columns <- drop_cols(train, cutoff)
  filtered_train <- factor_train[ , !(names(factor_train) %in% problem_columns)]
  filtered_test <- factor_test[ , !(names(factor_test) %in% problem_columns)]
  
  # Fill in the missing numeric with mean
  numeric_complete_train <- fill_na_num(filtered_train)
  numeric_complete_test <- fill_na_num(filtered_test)
  
  # Fill in the missing factor with the most common category
  complete_train <- fill_na_fac(numeric_complete_train)
  complete_test <- fill_na_fac(numeric_complete_test)
  
  
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
        text2 <- sprintf("df$\'%s\'[is.na(df$\'%s\')] <- \"None\"", i, i)
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

