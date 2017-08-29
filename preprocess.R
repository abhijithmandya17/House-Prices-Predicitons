# Kaggle Housing prices competition

library(tidyverse)

# Preprocess --------------------------------------------------------------

# Run the preprocessing script based on a given directory
preprocess <- function(){
  
  # Read in the train and test data
  train <- read_csv("train.csv")
  test <- read_csv("test.csv")
  
  # Convert all character to factors
  for(i in colnames(train)){
    text <- sprintf("train$\'%s\'", i)
    res <- eval(parse(text = text))
    if(is.character(res)){
      text2 <- sprintf("train$\'%s\' <- as.factor(train$\'%s\')", i, i)
      eval(parse(text = text2))
    }
  }
  
  for(i in colnames(test)){
    text <- sprintf("test$\'%s\'", i)
    res <- eval(parse(text = text))
    if(is.character(res)){
      text2 <- sprintf("test$\'%s\' <- as.factor(test$\'%s\')", i, i)
      eval(parse(text = text2))
    }
  }
  
  
  # Return the final processed train and test set
  ret <- list()
  ret$train <- train
  ret$test <- test
  return(ret)
}
