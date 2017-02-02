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

<<<<<<< HEAD

=======
##############################################################################
# For Head Count (Ground truth)
##############################################################################
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
# Linear forward selection
library(caret)
tuning_params <- expand.grid(nvmax=seq(1,4,1))
set.seed(100)
linear.gt.forward <- train(gt~., data=phone_data_gt, method="leapForward",
                   trControl=fit_control, tuneGrid = tuning_params)
plotWithBars(linear.gt.forward)

tuning_params <- expand.grid(nvmax=seq(1,4,1))
set.seed(100)
linear.pr.forward <- train(pr~., data=phone_data_pr, method="leapForward",
                   trControl=fit_control, tuneGrid = tuning_params)
plotWithBars(linear.pr.forward)

# linear backward selection
library(caret)
tuning_params <- expand.grid(nvmax=seq(1,4,1))
set.seed(100)
linear.gt.backward <- train(gt~., data=phone_data_gt, method="leapBackward",
                   trControl=fit_control, tuneGrid = tuning_params)
plotWithBars(linear.gt.backward)

tuning_params <- expand.grid(nvmax=seq(1,4,1))
set.seed(100)
linear.pr.backward <- train(pr~., data=phone_data_pr, method="leapBackward",
                   trControl=fit_control, tuneGrid = tuning_params)
plotWithBars(linear.pr.forward)

# linear stepwise selection
library(caret)
tuning_params <- expand.grid(nvmax=seq(1,4,1))
set.seed(100)
linear.gt.stepwise <- train(gt~., data=phone_data_gt, method="leapSeq",
                   trControl=fit_control, tuneGrid = tuning_params)
plotWithBars(linear.gt.stepwise)
<<<<<<< HEAD
lm(gt~., data = phone_data_gt)
=======
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237

tuning_params <- expand.grid(nvmax=seq(1,4,1))
set.seed(100)
linear.pr.stepwise <- train(pr~., data=phone_data_pr, method="leapSeq",
                   trControl=fit_control, tuneGrid = tuning_params)
<<<<<<< HEAD
plotWithBars(linear.pr.stepwise)
lm(pr~., data = phone_data_pr)

=======
plotWithBars(linear.pr.forward)
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237

#kNN
library(caret)
fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
tuning_params <- expand.grid(k=seq(1,30,1))
set.seed(100)
knn.gt <- train(gt~., data=phone_data_gt, method="knn",
                trControl=fit_control, tuneGrid = tuning_params)
plotWithBars(knn.gt)

fit_control <- trainControl(method = "repeatedcv", number = 10, repeats = 10)
tuning_params <- expand.grid(k=seq(1,30,1))
set.seed(100)
knn.pr <- train(pr~., data=phone_data_pr, method="knn",
                trControl=fit_control, tuneGrid = tuning_params)
plotWithBars(knn.pr)

# k-fold cross validation function
crossval.svm <- function(k = 10, epsilon = 0.1, cost = 1, coef0 = 0, nu=0, kernel="radial",
                         type="eps-regression", data="gt"){
  library(caret)
  library(e1071)
  
  if (data=="gt") {
    df <- phone_data_gt
    set.seed(100)
    folds <- createFolds(phone_data_gt[,c("gt")], k = k,
                         list = TRUE, returnTrain = FALSE)
    formula <- gt~.
  } else {
    df <- phone_data_pr
    set.seed(100)
    folds <- createFolds(phone_data_pr[,c("pr")], k = k,
                         list = TRUE, returnTrain = FALSE)
    formula <- pr~.
  }
  
  svm.accuracies <- c()
  for (i in 1:10) {
    if (type=="eps-regression") {
      model <- svm(formula, df[-folds[[i]],],
                   epsilon=epsilon,
                   cost=cost,
                   coef0=coef0,
                   type=type,
                   kernel=kernel
      )
    } else {
      model <- svm(formula, df[-folds[[i]],],
                   nu=nu,
                   cost=cost,
                   coef0=coef0,
                   type=type,
                   kernel=kernel
      )
    }
    
    if (data=="gt") {
      predictions <- predict(model, phone_data_gt[-folds[[i]],])
      
      rmse <- sqrt(mean((phone_data_gt[-folds[[i]],]$gt - predictions)^2))
      svm.accuracies = append(rmse, svm.accuracies)
    } else {
      predictions <- predict(model, phone_data_pr[-folds[[i]],])
      
      rmse <- sqrt(mean((phone_data_pr[-folds[[i]],]$pr - predictions)^2))
      svm.accuracies = append(rmse, svm.accuracies)
    }
  }
  
  return(svm.accuracies)
}

# plot the result with error bars
plotWithBars <- function(model){
  library(ggplot2)
  
  foo <- model$results
  title <- paste("The Performance of", model$modelInfo$label, sep=" ")
  colnames(foo)[1] <- "params"
  
  ggplot(foo, aes(x=params, y=RMSE)) + 
    geom_errorbar(aes(ymin=RMSE-RMSESD, ymax=RMSE+RMSESD), width=.1) +
<<<<<<< HEAD
    geom_line() + geom_point() +
    # expand_limits(y = 0)+
    theme_bw()+
=======
    geom_line() + geom_point()+ expand_limits(y = 0)+ theme_bw()+
>>>>>>> deb4eee798046ff3050e2fdc49aff179daa28237
    xlab(model$modelInfo$parameters$label) +
    ylab("RMSE (Repeated Cross-Validation)") +
    ggtitle(title)
}
plotWithBars(knn.gt)






##############################################################################
# SVM
##############################################################################

# headcount ###########
library(e1071)
tune_control <- tune.control(sampling = "cross", cross=10)

# ap-only as predictor
set.seed(100)
tuneResult <- tune(svm, gt~ap,  data=phone_data_gt,
                   ranges = list(epsilon = seq(0,0.5,0.01), cost = (1:10)),
                   tunecontrol=tune_control)

std <- function(x) sd(x)/sqrt(length(x))
se <- function(x) sqrt(var(x)/length(x))
std(c(1,2,3,4))
sd(c(1,2,3,4))
var(c(1,2,3,4))
se(c(1,2,3,4))


# eps-regression
set.seed(100)
tuneResult.eps.linear.gt <- tune(svm, gt~.,  data=phone_data_gt,
                              ranges = list(epsilon = seq(0,1,0.1), cost = (1:10),
                                            kernel="linear", type="eps-regression"),
                              tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             epsilon = 0,
                             cost = 4,
                             kernel = "linear",
                             type = "eps-regression",
                             data="pr")
mean(svm.accuracy)

set.seed(100)
tuneResult.eps.rad.gt <- tune(svm, gt~.,  data=phone_data_gt,
                            ranges = list(epsilon = seq(0,1,0.1), cost = (1:10),
                                          kernel="radial", type="eps-regression"),
                            tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             epsilon = tuneResult.eps.rad.gt$best.parameters$epsilon,
                             cost = tuneResult.eps.rad.gt$best.parameters$cost,
                             kernel = "radial",
                             type = "eps-regression")
mean(svm.accuracy)

set.seed(100)
tuneResult.eps.sig.gt <- tune(svm, gt~.,  data=phone_data_gt,
                            ranges = list(epsilon = seq(0,1,0.1), cost = (1:10),
                                          kernel="sig", coef0=(1:5),
                                          type="eps-regression"),
                            tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             epsilon = tuneResult.eps.sig.gt$best.parameters$epsilon,
                             cost = tuneResult.eps.sig.gt$best.parameters$cost,
                             kernel = "sigmoid",
                             coef0=tuneResult.eps.sig.gt$best.parameters$coef0,
                             type = "eps-regression")
mean(svm.accuracy)

# nu-regression
set.seed(100)
tuneResult.nu.linear.gt <- tune(svm, gt~.,  data=phone_data_gt,
                            ranges = list(nu = seq(0.1,1,0.1), cost = (1:10),
                                          kernel="linear", type="nu-regression"),
                            tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             nu = tuneResult.nu.sig.gt$best.parameters$nu,
                             cost = tuneResult.nu.sig.gt$best.parameters$cost,
                             kernel = "linear",
                             type = "nu-regression")
mean(svm.accuracy)

set.seed(100)
tuneResult.nu.rad.gt <- tune(svm, gt~.,  data=phone_data_gt,
                           ranges = list(nu = seq(0.1,1,0.1), cost = (1:10),
                                         kernel="radial", type="nu-regression"),
                           tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             nu = tuneResult.nu.rad.gt$best.parameters$nu,
                             cost = tuneResult.nu.rad.gt$best.parameters$cost,
                             kernel = "radial",
                             type = "nu-regression")
mean(svm.accuracy)

set.seed(100)
tuneResult.nu.sig.gt <- tune(svm, gt~.,  data=phone_data_gt,
                           ranges = list(nu = seq(0.1,1,0.1), cost = (1:10),
                                         kernel="sig", coef0=(1:5),
                                         type="nu-regression"),
                           tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             nu = tuneResult.nu.sig.gt$best.parameters$nu,
                             cost = tuneResult.nu.sig.gt$best.parameters$cost,
                             kernel = "sigmoid",
                             coef0=tuneResult.nu.sig.gt$best.parameters$coef0,
                             type = "nu-regression")
mean(svm.accuracy)

# unique device ###########
# eps-regression
set.seed(100)
tuneResult.eps.linear.pr <- tune(svm, pr~.,  data=phone_data_pr,
                                 ranges = list(epsilon = seq(0,1,0.1), cost = (1:10),
                                               kernel="linear", type="eps-regression"),
                                 tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             epsilon = tuneResult.eps.linear.pr$best.parameters$epsilon,
                             cost = tuneResult.eps.linear.pr$best.parameters$cost,
                             kernel = "linear",
                             type = "eps-regression",
                             data = "pr")
mean(svm.accuracy)

set.seed(100)
tuneResult.eps.rad.pr <- tune(svm, pr~.,  data=phone_data_pr,
                              ranges = list(epsilon = seq(0,1,0.1), cost = (1:10),
                                            kernel="radial", type="eps-regression"),
                              tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             epsilon = tuneResult.eps.rad.pr$best.parameters$epsilon,
                             cost = tuneResult.eps.rad.pr$best.parameters$cost,
                             kernel = "radial",
                             type = "eps-regression",
                             data = "pr")
mean(svm.accuracy)

set.seed(100)
tuneResult.eps.sig.pr <- tune(svm, pr~.,  data=phone_data_pr,
                              ranges = list(epsilon = seq(0,1,0.1), cost = (1:10),
                                            kernel="sig", coef0=(1:5),
                                            type="eps-regression"),
                              tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             epsilon = tuneResult.eps.sig.pr$best.parameters$epsilon,
                             cost = tuneResult.eps.sig.pr$best.parameters$cost,
                             kernel = "sigmoid",
                             type = "eps-regression",
                             data = "pr",
                             coef0 = tuneResult.eps.sig.pr$best.parameters$coef0)
mean(svm.accuracy)

# nu-regression
set.seed(100)
tuneResult.nu.linear.pr <- tune(svm, pr~.,  data=phone_data_pr,
                                ranges = list(nu = seq(0.1,1,0.1), cost = (1:10),
                                              kernel="linear", type="nu-regression"),
                                tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             nu = tuneResult.nu.linear.pr$best.parameters$nu,
                             cost = tuneResult.nu.linear.pr$best.parameters$cost,
                             kernel = "linear",
                             type = "nu-regression",
                             data = "pr")
mean(svm.accuracy)

set.seed(100)
tuneResult.nu.rad.pr <- tune(svm, pr~.,  data=phone_data_pr,
                             ranges = list(nu = seq(0.1,1,0.1), cost = (1:10),
                                           kernel="radial", type="nu-regression"),
                             tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             nu = tuneResult.nu.rad.pr$best.parameters$nu,
                             cost = 100000,
                             kernel = "radial",
                             type = "nu-regression",
                             data = "pr")
mean(svm.accuracy)

set.seed(100)
tuneResult.nu.sig.pr <- tune(svm, pr~.,  data=phone_data_pr,
                             ranges = list(nu = seq(0.1,1,0.1), cost = (1:10),
                                           kernel="sig", coef0=(1:5),
                                           type="nu-regression"),
                             tunecontrol=tune_control)
svm.accuracy <- crossval.svm(k = 10,
                             nu = tuneResult.nu.sig.pr$best.parameters$nu,
                             cost = tuneResult.nu.sig.pr$best.parameters$cost,
                             kernel = "sigmoid",
                             type = "nu-regression",
                             data = "pr",
                             coef0 = tuneResult.nu.sig.pr$best.parameters$coef0)
mean(svm.accuracy)


# high C value
highC <- c(100000,10000,3000,2000,1000)
highCmean <- c()
highCsd <- c()
svm.accuracy <- crossval.svm(k = 10,
                             epsilon = tuneResult.eps.rad.gt$best.parameters$epsilon,
                             cost = 100000,
                             kernel = "radial",
                             type = "eps-regression")
mean(svm.accuracy)
sd(svm.accuracy)
highCmean <- append(mean(svm.accuracy), highCmean)
highCsd <- append(sd(svm.accuracy), highCsd)
df <- data.frame(highC, highCmean, highCsd)

# plot the result
ggplot(df, aes(x=highC, y=highCmean)) +
geom_errorbar(aes(ymin=highCmean-highCsd, ymax=highCmean+highCsd), width=.1) +
geom_line() + geom_point()+ expand_limits(y = 0)+ theme_bw()+
xlab("Cost") +
ylab("RMSE (Cross-Validation)")
+
ggtitle()

# the code below was not used
# polynomial kernels
# these took so long time to execute
# warning maximum number of loop is also received
set.seed(100)
tuneResult.nu.poly.gt <- tune(svm, gt~.,  data=phone_data_gt,
                              ranges = list(nu = seq(0.1,1,0.1),
                                            kernel="poly", coef0=(1:5), degree=(1:5),
                                            type="nu-regression"),
                              tunecontrol=tune_control)
set.seed(100)
tuneResult.eps.poly.gt <- tune(svm, gt~.,  data=phone_data_gt,
                               ranges = list(epsilon = seq(0,1,0.1),
                                             kernel="poly", coef0=(1:5), degree=(1:5),
                                             type="eps-regression"),
                               tunecontrol=tune_control)

set.seed(100)
tuneResult.nu.poly.pr <- tune(svm, pr~.,  data=phone_data_pr,
                              ranges = list(nu = seq(0.1,1,0.1),
                                            kernel="poly", coef0=(1:5), degree=(1:5),
                                            type="nu-regression"),
                              tunecontrol=tune_control)

set.seed(100)
tuneResult.eps.poly.pr <- tune(svm, pr~.,  data=phone_data_pr,
                               ranges = list(epsilon = seq(0,1,0.1),
                                             kernel="poly", coef0=(1:5), degree=(1:5),
                                             type="eps-regression"),
                               tunecontrol=tune_control)