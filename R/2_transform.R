library(readr)
library(dplyr)
library(data.table)
library(caret)
library(VIM)
library(mice)
library(quanteda)

train <- fread('input/train.tsv')
test <- fread('input/test.tsv')

do_impute <- FALSE

all <- rbind(train %>% select(-price, -train_id) %>% mutate(is_train = 1), test %>% select(-test_id) %>% mutate(is_train = 0))

all <- all %>%
  cbind(trimmed_names_dfm %>% as.data.frame()) %>%
  select(
    -name,
    -item_description
  )

# Create dummy variables

dmy <- dummyVars(" ~ .", data = all)
all <- data.frame(predict(dmy, newdata = all))

# Training set

dtrain <- all %>%
  filter(is_train == 1) %>%
  select(
    -is_train
  ) %>%
  cbind(
    price = log1p(train$price)
  )

# Test set

dtest <- all %>%
  filter(is_train == 0) %>%
  select(
    -is_train
  )

dtrain %>% write_csv(sprintf('output/train%s.csv', ifelse(do_impute, '_imputed', '')), na = '')
dtest %>% write_csv(sprintf('output/test%s.csv', ifelse(do_impute, '_imputed', '')), na = '')
