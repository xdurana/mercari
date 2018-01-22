library(readr)
library(dplyr)
library(data.table)

train <- fread('input/train.tsv', nrows = 1000)
