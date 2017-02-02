all_global_data <- read.table("global-dump.txt",
                              header = TRUE,
                              sep="\t", 
                              col.names=c("ap", "pr","au", "gt",
                                          "rms", "pklv", "rssi", "snr", "loc"), 
                              fill=FALSE, 
                              strip.white=TRUE)

global_data <- all_global_data[c("ap", "pr", "gt", "rms", "pklv", "rssi")]
phone_data_gt <- all_global_data[c("gt", "ap", "rms", "pklv", "rssi")]
phone_data_pr <- all_global_data[c("pr", "ap", "rms", "pklv", "rssi")]

# 1. Linear Model
model1.gt <- lm(gt~., phone_data_gt)
summary(model1.gt)

# cross validation
library(DAAG)
coba <- cv.lm(data=phone_data_gt, model1.gt, m=459)
cv.lm(data=phone_data_gt, model1.gt, m=10)

# standard mean suare error
predictions <- predict(model1.gt, phone_data_gt)
mean((phone_data_gt$gt - predictions)^2)

library(caret)
fitControl <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 10)
gbmGrid <-  expand.grid(cost=seq(0,10,1))

lasso.gt <- train(gt~., data=phone_data_gt, method="lasso",
                  trControl=fitControl, tuneGrid = gbmGrid)
ridge.gt <- train(gt~., data=phone_data_gt, method="ridge", metric="residual",
                  trControl=fitControl, tuneGrid = gbmGrid)
gcvEarth.gt <- train(gt~., data=phone_data_gt, method="gcvEarth")
svm.gt <- train(gt~., data=phone_data_gt, method="svmLinear2",metric="residual",
                trControl=fitControl, tuneGrid = gbmGrid)
linear.gt <- train(gt~., data=phone_data_gt, method="leapForward")
nnet.gt <- train(gt~., data=phone_data_gt, method="nnet")
knn.gt <- train(gt~., data=phone_data_gt, method="knn")
