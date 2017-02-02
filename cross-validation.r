# linear model-head count
crossval.linear.hc <- function(number){
  set.seed(100)
  folds <- createFolds(phone_data_gt[,c("gt")], k = number,
                       list = TRUE, returnTrain = FALSE)
  fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
  
  errors <- c()
  predictions <- c()
  real <- c()
  for (i in 1:number) {
    model <- train(gt~., data=phone_data_gt[-folds[[i]],],
                   method="leapSeq", tuneGrid = data.frame(nvmax=4),
                   trControl=fit_control)
    
    print(model)
    print(i)
    
    prediction <- predict(model, phone_data_gt[folds[[i]],])
    # error <- sqrt(mean((phone_data_gt[folds[[i]],]$gt - predictions)^2))
    error <- mean(abs(phone_data_gt[folds[[i]],]$gt - prediction))
    
    errors = append(error, errors)
    predictions = append(prediction, predictions)
    real = append(phone_data_gt[folds[[i]],]$gt, real)
  }
  
  return_value <- list("errors" = errors, "predictions" = predictions, "real" = real)
  return(return_value)
}

linear.hc <- crossval.linear.hc(10)
linear_df <- data.frame(linear.hc$real, linear.hc$predictions)
names(linear_df) <- c("real", "predictions")
# sort the data frame
linear_df <- linear_df[order(linear_df$real),]

y_min <- min(linear_df$real, linear_df$predictions)
y_max <- max(linear_df$real, linear_df$predictions)
plot(linear_df$predictions, col="red", type = "l", ylim=range(c(y_min,y_max)),
     ylab = "head count", xlab="index")
par(new=TRUE)
plot(linear_df$real, col="green", type="l", ylim=range(c(y_min,y_max)), 
     axes = FALSE, xlab = "", ylab = "")
legend("topleft", inset=.05, c("observed","predicted"), fill=c("green", "red"), horiz=TRUE)





# linear model-device count
crossval.linear.dc <- function(number){
  set.seed(100)
  folds <- createFolds(phone_data_pr[,c("pr")], k = number,
                       list = TRUE, returnTrain = FALSE)
  fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
  
  errors <- c()
  predictions <- c()
  real <- c()
  for (i in 1:number) {
    model <- train(pr~., data=phone_data_pr[-folds[[i]],],
                   method="leapSeq", tuneGrid = data.frame(nvmax=4),
                   trControl=fit_control)
    
    print(model)
    print(i)
    
    prediction <- predict(model, phone_data_pr[folds[[i]],])
    # error <- sqrt(mean((phone_data_pr[folds[[i]],]$pr - predictions)^2))
    error <- mean(abs(phone_data_pr[folds[[i]],]$pr - prediction))
    
    errors = append(error, errors)
    predictions = append(prediction, predictions)
    real = append(phone_data_pr[folds[[i]],]$pr, real)
  }
  
  return_value <- list("errors" = errors, "predictions" = predictions, "real" = real)
  return(return_value)
}

linear.dc <- crossval.linear.dc(10)
linear_df <- data.frame(linear.dc$real, linear.dc$predictions)
names(linear_df) <- c("real", "predictions")
# sort the data frame
linear_df <- linear_df[order(linear_df$real),]

y_min <- min(linear_df$real, linear_df$predictions)
y_max <- max(linear_df$real, linear_df$predictions)
plot(linear_df$predictions, col="red", type = "l", ylim=range(c(y_min,y_max)),
     ylab = "device count", xlab="index")
par(new=TRUE)
plot(linear_df$real, col="green", type="l", ylim=range(c(y_min,y_max)), 
     axes = FALSE, xlab = "", ylab = "")
legend("topleft", inset=.05, c("observed","predicted"), fill=c("green", "red"), horiz=TRUE)








# knn - head count
crossval.knn.gt <- function(number){
  set.seed(100)
  folds <- createFolds(phone_data_gt[,c("gt")], k = number,
                       list = TRUE, returnTrain = FALSE)
  fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
  
  errors <- c()
  predictions <- c()
  real <- c()
  for (i in 1:number) {
    model <- train(gt~., data=phone_data_gt[-folds[[i]],], method="knn",
                   trControl=fit_control, tuneGrid = data.frame(k=7))
    
    print(model)
    print(i)
    
    prediction <- predict(model, phone_data_gt[folds[[i]],])
    # error <- sqrt(mean((phone_data_gt[folds[[i]],]$gt - predictions)^2))
    error <- mean(abs(phone_data_gt[folds[[i]],]$gt - prediction))
    
    errors = append(error, errors)
    predictions = append(prediction, predictions)
    real = append(phone_data_gt[folds[[i]],]$gt, real)
  }
  
  return_value <- list("errors" = errors, "predictions" = predictions, "real" = real)
  return(return_value)
}


knn.hc <- crossval.knn.gt(10)
knn.df <- data.frame(knn.hc$real, knn.hc$predictions)
names(knn.df) <- c("real", "predictions")
# sort the data frame
knn.df <- knn.df[order(knn.df$real),]

y_min <- min(knn.df$real, knn.df$predictions)
y_max <- max(knn.df$real, knn.df$predictions)
plot(knn.df$predictions, col="red", type = "l", ylim=range(c(y_min,y_max)),
     ylab = "head count", xlab="index")
par(new=TRUE)
plot(knn.df$real, col="green", type="l", ylim=range(c(y_min,y_max)), 
     axes = FALSE, xlab = "", ylab = "")
legend("topleft", inset=.05, c("observed","predicted"), fill=c("green", "red"), horiz=TRUE)





# knn - device count
crossval.knn.pr <- function(number){
  set.seed(100)
  folds <- createFolds(phone_data_pr[,c("pr")], k = number,
                       list = TRUE, returnTrain = FALSE)
  fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
  
  errors <- c()
  predictions <- c()
  real <- c()
  for (i in 1:number) {
    model <- train(pr~., data=phone_data_pr[-folds[[i]],], method="knn",
                   trControl=fit_control, tuneGrid = data.frame(k=8))
    
    print(model)
    print(i)
    
    prediction <- predict(model, phone_data_pr[folds[[i]],])
    # error <- sqrt(mean((phone_data_pr[folds[[i]],]$pr - predictions)^2))
    error <- mean(abs(phone_data_pr[folds[[i]],]$pr - prediction))
    
    errors = append(error, errors)
    predictions = append(prediction, predictions)
    real = append(phone_data_pr[folds[[i]],]$pr, real)
  }
  
  return_value <- list("errors" = errors, "predictions" = predictions, "real" = real)
  return(return_value)
}


knn.dc <- crossval.knn.pr(10)
knn.df <- data.frame(knn.dc$real, knn.dc$predictions)
names(knn.df) <- c("real", "predictions")
# sort the data frame
knn.df <- knn.df[order(knn.df$real),]

y_min <- min(knn.df$real, knn.df$predictions)
y_max <- max(knn.df$real, knn.df$predictions)
plot(knn.df$predictions, col="red", type = "l", ylim=range(c(y_min,y_max)),
     ylab = "device count", xlab="index")
par(new=TRUE)
plot(knn.df$real, col="green", type="l", ylim=range(c(y_min,y_max)), 
     axes = FALSE, xlab = "", ylab = "")
legend("topleft", inset=.05, c("observed","predicted"), fill=c("green", "red"), horiz=TRUE)















# svm - device count
library(e1071)
crossval.svm.pr <- function(number){
  library(caret)
  library(e1071)
  folds <- createFolds(phone_data_pr[,c("pr")], k = number, list = TRUE,
                       returnTrain = FALSE)
  
  errors <- c()
  predictions <- c()
  real <- c()
  for (i in 1:number) {
    model <- svm(pr~., phone_data_pr[-folds[[i]],], epsilon=0, cost=1)
    # print(model)
    prediction <- predict(model, phone_data_pr[folds[[i]],])
    # error <- sqrt(mean((phone_data_pr[folds[[i]],]$pr - predictions)^2))
    error <- mean(abs(phone_data_pr[folds[[i]],]$pr - prediction))
    
    errors = append(error, errors)
    predictions = append(prediction, predictions)
    real = append(phone_data_pr[folds[[i]],]$pr, real)
  }
  
  return_value <- list("errors" = errors, "predictions" = predictions, "real" = real)
  return(return_value)
}

svm.dc <- crossval.svm.pr(10)
svm.df <- data.frame(svm.dc$real, svm.dc$predictions)
names(svm.df) <- c("real", "predictions")
# sort the data frame
svm.df <- svm.df[order(svm.df$real),]

y_min <- min(svm.df$real, svm.df$predictions)
y_max <- max(svm.df$real, svm.df$predictions)
plot(svm.df$predictions, col="red", type = "l", ylim=range(c(y_min,y_max)),
     ylab = "device count", xlab="index")
par(new=TRUE)
plot(svm.df$real, col="green", type="l", ylim=range(c(y_min,y_max)), 
     axes = FALSE, xlab = "", ylab = "")
legend("topleft", inset=.05, c("observed","predicted"), fill=c("green", "red"), horiz=TRUE)



# svm - head count
library(e1071)
crossval.svm.gt <- function(number){
  set.seed(100)
  folds <- createFolds(phone_data_gt[,c("gt")], k = number,
                       list = TRUE, returnTrain = FALSE)
  fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
  
  errors <- c()
  predictions <- c()
  real <- c()
  for (i in 1:number) {
    model <- svm(gt~., phone_data_gt[-folds[[i]],], nu=0.5, cost=3,
                 type="nu-regression")
    
    # print(model)
    # print(i)
    
    prediction <- predict(model, phone_data_gt[folds[[i]],])
    # error <- sqrt(mean((phone_data_gt[folds[[i]],]$gt - predictions)^2))
    error <- mean(abs(phone_data_gt[folds[[i]],]$gt - prediction))
    
    errors = append(error, errors)
    predictions = append(prediction, predictions)
    real = append(phone_data_gt[folds[[i]],]$gt, real)
  }
  
  return_value <- list("errors" = errors, "predictions" = predictions, "real" = real)
  return(return_value)
}


svm.hc <- crossval.svm.gt(10)
svm.df <- data.frame(svm.hc$real, svm.hc$predictions)
names(svm.df) <- c("real", "predictions")
# sort the data frame
svm.df <- svm.df[order(svm.df$real),]

y_min <- min(svm.df$real, svm.df$predictions)
y_max <- max(svm.df$real, svm.df$predictions)
plot(svm.df$predictions, col="red", type = "l", ylim=range(c(y_min,y_max)),
     ylab = "head count", xlab="index")
par(new=TRUE)
plot(svm.df$real, col="green", type="l", ylim=range(c(y_min,y_max)), 
     axes = FALSE, xlab = "", ylab = "")
legend("topleft", inset=.05, c("observed","predicted"), fill=c("green", "red"), horiz=TRUE)
