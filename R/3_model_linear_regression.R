library(caret)

train <- fread('input/train.tsv')
test <- fread('input/test.tsv')

dtrain <- read_csv('output/train.csv')
dtest <- read_csv('output/test.csv')

linear <- lm(price ~ ., data = dtrain)
summary(linear)

# submit

predicted <- expm1(predict(linear, dtest))
output <- data.frame(test$test_id, predicted)
colnames(output) <- cbind("id_test", "price")
output %>% write_csv('submission/linear.csv')
