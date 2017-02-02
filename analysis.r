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

# all models
# 1. Linear
model1.gt <- lm(gt~., phone_data_gt)
summary(model1.gt)
predictions <- predict(model1.gt, phone_data_gt)
rmse <- sqrt(mean((phone_data_gt$gt - predictions)^2))
print(rmse)

model1.pr <- lm(pr~., phone_data_pr)
summary(model1.pr)
predictions <- predict(model1.pr, phone_data_pr)
rmse <- sqrt(mean((phone_data_pr$pr - predictions)^2))
print(rmse)

# 2. Multivariate Adaptive Regression Splines
library(earth)
model2.gt <- earth(gt~., phone_data_gt)
summary(model2.gt)
evimp(model2.gt)
predictions <- predict(model2.gt, phone_data_gt)
rmse <- sqrt(mean((phone_data_gt$gt - predictions)^2))
print(rmse)

model2.pr <- earth(pr~., phone_data_pr)
summary(model2.pr)
evimp(model2.pr)
predictions <- predict(model2.pr, phone_data_pr)
rmse <- sqrt(mean((phone_data_pr$pr - predictions)^2))
print(rmse)

# 3. SVM
library(kernlab)
model3.gt <- ksvm(gt~., phone_data_gt)
summary(model3.gt)
model3.gt
predictions <- predict(model3.gt, phone_data_gt)
rmse <- sqrt(mean((phone_data_gt$gt - predictions)^2))
print(rmse)

model3.pr <- ksvm(pr~., phone_data_pr)
summary(model3.pr)
model3.pr
predictions <- predict(model3.pr, phone_data_pr)
rmse <- sqrt(mean((phone_data_pr$pr - predictions)^2))
print(rmse)

# 4. kNN
library(caret)
model4.gt <- knnreg(phone_data_gt[,2:5], phone_data_gt[,1], k=3)
summary(model4.gt)
model4.gt
predictions <- predict(model4.gt, phone_data_gt[,2:5])
rmse <- sqrt(mean((phone_data_gt$gt - predictions)^2))
print(rmse)

model4.pr <- knnreg(phone_data_pr[,2:5], phone_data_pr[,1], k=1)
summary(model4.pr)
model4.pr
predictions <- predict(model4.pr, phone_data_pr[,2:5])
rmse <- sqrt(mean((phone_data_pr$pr - predictions)^2))
print(rmse)

# 5. Neural Network
library(nnet)
x <- phone_data_gt[,2:5]
y <- phone_data_gt[,1]
model5.gt <- nnet(gt~., phone_data_gt, size=50, maxit=1000, linout=T, decay=0.1)
summary(model5.gt)
predictions <- predict(model5.gt, x, type="raw")
rmse <- sqrt(mean((y - predictions)^2))
print(rmse)

x <- phone_data_pr[,2:5]
y <- phone_data_pr[,1]
model5.pr <- nnet(pr~., phone_data_pr, size=50, maxit=1000, linout=T, decay=0.1)
summary(model5.pr)
predictions <- predict(model5.pr, x, type="raw")
rmse <- sqrt(mean((y - predictions)^2))
print(rmse)
