library(caret)

train <- fread('input/train.tsv', nrows = 1000)
test <- fread('input/test.tsv', nrows = 1000)

dtrain <- read_csv('output/train.csv')
dtest <- read_csv('output/test.csv')

CARET.TRAIN.CTRL <- trainControl(method = "repeatedcv", number = 10, repeats = 4)
fit.glmnet <- train(
  price ~ .,
  dtrain,
  trControl = CARET.TRAIN.CTRL,
  method = "glmnet",
  metric = "RMSE",
  maximize = FALSE,
  tuneGrid = expand.grid(.alpha = seq(0, 1, by = 0.05), .lambda = seq(0, 1, by = 0.01)))

fit.glmnet$bestTune

# submit

predicted <- expm1(predict(fit.glmnet, dtest))
output <- data.frame(test$test_id, predicted)
colnames(output) <- cbind("id_test", "price")
output %>% write_csv('submission/glmnet.csv')
