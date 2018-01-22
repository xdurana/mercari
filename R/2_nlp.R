library(readr)
library(dplyr)
library(data.table)
library(caret)
library(VIM)
library(mice)
library(quanteda)

train <- fread('input/train.tsv', nrows = 100000)
test <- fread('input/test.tsv', nrows = 100000)

all <- rbind(train %>% select(-price, -train_id) %>% mutate(is_train = 1), test %>% select(-test_id) %>% mutate(is_train = 0))

# Text mining

names <- corpus(char_tolower(train$name))

names_tokens <- tokens(
  tokens_remove(
    tokens(
      names,    
      remove_numbers = TRUE, 
      remove_punct = TRUE,
      remove_symbols = TRUE, 
      remove_separators = TRUE),
    stopwords("english")
  ),
  ngrams = 2
)

names_dtm <- dfm(
  names_tokens
)

trimmed_names_dfm <- dfm_trim(names_dtm, min_count = 100)

sparse_matrix <- sparse.model.matrix(
  ~item_condition_id +
    category_name +
    brand_name +
    shipping,
  data = all
)

class(trimmed_names_dfm) <- class(sparse_matrix)
data = cbind(sparse_matrix, trimmed_names_dfm)
