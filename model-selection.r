# load data
all_global_data <- read.table("global-dump.txt",
                              header = TRUE,
                              sep="\t", 
                              col.names=c("ap", "pr","au", "gt",
                                          "rms", "pklv", "rssi", "snr", "loc"), 
                              fill=FALSE, 
                              strip.white=TRUE)

phone_data_gt <- all_global_data[c("gt", "ap", "rms", "pklv", "rssi")]
phone_data_pr <- all_global_data[c("pr", "ap", "rms", "pklv", "rssi")]

# for evaluation
library(caret)
fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
# k-fold cross validation function
crossval.svm.gt <- function(number, epsilon, cost){
  library(caret)
  library(e1071)
  folds <- createFolds(phone_data_gt[,c("gt")], k = number, list = TRUE, returnTrain = FALSE)
  
  svm.accuracies <- c()
  for (i in 1:number) {
    model <- svm(gt~., phone_data_gt[-folds[[i]],], epsilon=epsilon, cost=cost)
<<<<<<< HEAD
    predictions <- predict(model, phone_data_gt[folds[[i]],])
    
    # rmse <- sqrt(mean((phone_data_gt[-folds[[i]],]$gt - predictions)^2))
    error <- mean(abs(phone_data_gt[folds[[i]],]$gt - predictions))
    svm.accuracies = append(error, svm.accuracies)
=======
    predictions <- predict(model, phone_data_gt[-folds[[i]],])
    
    rmse <- sqrt(mean((phone_data_gt[-folds[[i]],]$gt - predictions)^2))
    svm.accuracies = append(rmse, svm.accuracies)
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
  }
  
  return(svm.accuracies)
}
<<<<<<< HEAD

=======
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
crossval.svm.pr <- function(number, epsilon, cost){
  library(caret)
  library(e1071)
  folds <- createFolds(phone_data_pr[,c("pr")], k = number, list = TRUE, returnTrain = FALSE)
  
  svm.accuracies <- c()
  for (i in 1:number) {
    model <- svm(pr~., phone_data_pr[-folds[[i]],], epsilon=epsilon, cost=cost)
<<<<<<< HEAD
    # print(model)
    predictions <- predict(model, phone_data_pr[-folds[[i]],])
    
    # rmse <- sqrt(mean((phone_data_pr[-folds[[i]],]$pr - predictions)^2))
    error <- mean(abs(phone_data_pr[-folds[[i]],]$pr - predictions))
    svm.accuracies = append(error, svm.accuracies)
=======
    print(model)
    predictions <- predict(model, phone_data_pr[-folds[[i]],])
    
    rmse <- sqrt(mean((phone_data_pr[-folds[[i]],]$pr - predictions)^2))
    svm.accuracies = append(rmse, svm.accuracies)
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
  }
  
  return(svm.accuracies)
}

crossval <- function(number){
  set.seed(100)
  folds <- createFolds(phone_data_gt[,c("gt")], k = number,
                       list = TRUE, returnTrain = FALSE)
  fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
  
  svm.accuracies <- c()
  for (i in 1:number) {
    # model <- train(gt~., data=phone_data_gt[-folds[[i]],],
    #                method="leapForward", tuneGrid = data.frame(nvmax=4),
    #                trControl=fit_control)
    # model <- train(gt~., data=phone_data_gt[-folds[[i]],], method="knn",
    #                trControl=fit_control, tuneGrid = data.frame(k=8))
    model <- svm(gt~., phone_data_gt[-folds[[i]],], eps=0, cost=1,
                 type="eps-regression")
    
    print(model)
    print(i)
    predictions <- predict(model, phone_data_gt[folds[[i]],])
    
    error <- sqrt(mean((phone_data_gt[folds[[i]],]$gt - predictions)^2))
    # error <- mean(abs(phone_data_gt[folds[[i]],]$gt - predictions))
    svm.accuracies = append(error, svm.accuracies)
  }
  print(phone_data_gt[folds[[10]],]$gt)
  print(predictions)
  
  return(svm.accuracies)
}

total <- crossval(10)
mean(total)
sd(total)

crossval.pr <- function(number){
  set.seed(100)
  folds <- createFolds(phone_data_pr[,c("pr")], k = number,
                       list = TRUE, returnTrain = FALSE)
  fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
  
  svm.accuracies <- c()
  for (i in 1:number) {
    # model <- train(pr~., data=phone_data_pr[-folds[[i]],],
    #                method="leapForward", tuneGrid = data.frame(nvmax=4),
    #                trControl=fit_control)
    model <- train(pr~., data=phone_data_pr[-folds[[i]],], method="knn",
                   trControl=fit_control, tuneGrid = data.frame(k=8))
    # model <- svm(pr~., phone_data_pr[-folds[[i]],], eps=0, cost=4,
    #             type="eps-regression")
    
    print(model)
    print(i)
    predictions <- predict(model, phone_data_pr[folds[[i]],])
    
    # error <- sqrt(mean((phone_data_pr[folds[[i]],]$pr - predictions)^2))
    error <- mean(abs(phone_data_pr[folds[[i]],]$pr - predictions))
    svm.accuracies = append(error, svm.accuracies)
  }
  
  return(svm.accuracies)
}

total <- crossval.pr(10)
mean(total)
sd(total)

##############################################################################
# For Head Count (Ground truth)
##############################################################################
# Linear
library(caret)
tuning_params <- expand.grid(nvmax=c(1,2))
set.seed(100)
linear.gt <- train(gt~., data=phone_data_gt, method="leapForward", tuneGrid = data.frame(nvmax=4))

linear.gt <- train(gt~., data=phone_data_gt, method="leapForward", nvmax=4)

# Ridge detection
library(caret)
tuning_params <- expand.grid(lambda=seq(0,0.05,0.001))
ridge.gt <- train(gt~., data=phone_data_gt, method="ridge",
                  trControl=fit_control, tuneGrid = tuning_params)

# Lasso
library(caret)
tuning_params <- expand.grid(fraction=seq(0,1,0.05))
lasso.gt <- train(gt~., data=phone_data_gt, method="lasso",
                  trControl=fit_control, tuneGrid = tuning_params)

# mars
library(caret)
tuning_params <- expand.grid(degree=seq(0,10,1))
mars.gt <- train(gt~., data=phone_data_gt, method="gcvEarth",
                 trControl=fit_control, tuneGrid = tuning_params)

# knn
library(caret)
tuning_params <- expand.grid(k=seq(1,20,1))
knn.gt <- train(gt~., data=phone_data_gt, method="knn",
                trControl=fit_control, tuneGrid = tuning_params)

# SVM
library(e1071)
set.seed(100)
<<<<<<< HEAD
# tuneResult <- tune(svm, gt~.,  data=phone_data_gt,
#                    ranges = list(epsilon = seq(0,0.4,0.01), cost = 2^(0:9)))
tuneResult <- tune(svm, gt~.,  data=phone_data_gt,
                   ranges = list(epsilon = seq(0,1,0.1), cost = (1:10)))
# svm.gt <- svm(gt~., phone_data_gt, epsilon=0.08, cost=2)
tuneResult$best.parameters$epsilon
tuneResult$best.parameters$cost
svm.accuracy <- crossval.svm.gt(10, tuneResult$best.parameters$epsilon,
                                tuneResult$best.parameters$cost)
=======
tuneResult <- tune(svm, gt~.,  data=phone_data_gt,
                   ranges = list(epsilon = seq(0,0.4,0.01), cost = 2^(0:9)))
svm.gt <- svm(gt~., phone_data_gt, epsilon=0.08, cost=2)
svm.accuracy <- crossval.svm.gt(10, 0.08, 2)
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
mean(svm.accuracy)

##############################################################################
# For Unique device (Probe request)
##############################################################################
# Linear
library(caret)
tuning_params <- expand.grid(nvmax=seq(1,4,1))
linear.pr <- train(pr~., data=phone_data_pr, method="leapForward",
                   trControl=fit_control, tuneGrid = tuning_params)

# Ridge detection
library(caret)
tuning_params <- expand.grid(lambda=seq(0,0.05,0.001))
ridge.pr <- train(pr~., data=phone_data_pr, method="ridge",
                  trControl=fit_control, tuneGrid = tuning_params)

# Lasso
library(caret)
tuning_params <- expand.grid(fraction=seq(0,1,0.05))
lasso.pr <- train(pr~., data=phone_data_pr, method="lasso",
                  trControl=fit_control, tuneGrid = tuning_params)

# mars
library(caret)
tuning_params <- expand.grid(degree=seq(0,20,1))
mars.pr <- train(pr~., data=phone_data_pr, method="gcvEarth",
                 trControl=fit_control, tuneGrid = tuning_params)

# knn
library(caret)
set.seed(100)
tuning_params <- expand.grid(k=seq(1,20,1))
knn.pr <- train(pr~., data=phone_data_pr, method="knn",
                trControl=fit_control, tuneGrid = tuning_params)

# SVM
library(e1071)
set.seed(100)
tuneResult <- tune(svm, pr~.,  data=phone_data_pr,
                   ranges = list(epsilon = seq(0,1,0.1), cost = (1:10)))
<<<<<<< HEAD
# svm.pr <- svm(pr~., phone_data_pr, epsilon=0, cost=4)
tuneResult$best.parameters$epsilon
tuneResult$best.parameters$cost
svm.accuracy <- crossval.svm.pr(10, tuneResult$best.parameters$epsilon,
                                tuneResult$best.parameters$cost)
mean(svm.accuracy)
=======
svm.pr <- svm(pr~., phone_data_pr, epsilon=0, cost=4)
svm.accuracy <- crossval.svm.pr(10, 0, 4)
mean(svm.accuracy)
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
