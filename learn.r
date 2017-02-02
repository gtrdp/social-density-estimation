attach(mtcars)

plot(wt, mpg, main="Scatterplot Example 1",
     xlab="Car Weight ", ylab="Miles Per Gallon ", pch=19)

plot(wt, mpg, main="Scatterplot Example 2",
     xlab="Car Weight ", ylab="Miles Per Gallon ", pch=19)

abline(lm(mpg~wt), col="red") # regression line (y~x) 
lines(lowess(wt,mpg), col="blue") # lowess line (x,y)

pairs(~mpg+disp+drat+wt,data=mtcars, 
      main="Simple Scatterplot Matrix")


plot(global_data)
summary(lm(gt~pr))
summary(lowess(gt~pr))

data(iris)
## tune  svm  for classification with RBF-kernel (default in svm),
## using one split for training/validation set
obj <- tune(svm, gt~., data = phone_data_gt,
            ranges = list(gamma = 2^(-1:1), cost = 2^(2:4)),
            tunecontrol = tune.control(sampling = "fix")
)
## alternatively:
## obj <- tune.svm(Species~., data = iris, gamma = 2^(-1:1), cost = 2^(2:4))
summary(obj)
plot(obj)


# tune  knn  using a convenience function; this time with the
## conventional interface and bootstrap sampling:
x <- iris[,-5]
y <- iris[,5]
obj2 <- tune.knn(x, y, k = 1:10, tunecontrol = tune.control(sampling = "boot"))
summary(obj2)
plot(obj2)

library(caret)
model4.gt <- knnreg(phone_data_gt[,2:5], phone_data_gt[,1], k=1)
summary(model4.gt)
model4.gt
predictions <- predict(model4.gt, phone_data_gt[,2:5])
rmse <- sqrt(mean((phone_data_gt$gt - predictions)^2))
print(rmse)

x <- phone_data_gt[,2:5]
y <- phone_data_gt[,1]
obj2 <- tune.knn(x, y, k = 1:10, tunecontrol = tune.control(sampling = "boot"))
summary(obj2)
plot(obj2)

## tune  rpart  for regression, using 10-fold cross validation (default)
data(mtcars)
obj3 <- tune.rpart(mpg~., data = mtcars, minsplit = c(5,10,15))
summary(obj3)
plot(obj3)

## simple error estimation for lm using 10-fold cross validation
tune(lm, mpg~., data = mtcars)


# subset selection example
d <- data.frame(
  state = rep(c('NY', 'CA'), 10),
  year = rep(1:10, 2),
  response= rnorm(20)
)

library(plyr)
# Break up d by state, then fit the specified model to each piece and
# return a list
models <- dlply(d, "state", function(df) 
  lm(response ~ year, data = df))

# Apply coef to each model and return a data frame
ldply(models, coef)

# Print the summary of each model
l_ply(models, summary, .print = TRUE)



# All Subsets Regression
library(leaps)
attach(mydata)
leaps<-regsubsets(gt~.,data=phone_data_gt,nbest=10)
# view results 
summary(leaps)
plot(leaps)
# plot a table of models showing variables in each model.
# models are ordered by the selection statistic.
plot(leaps,scale="r2")
# plot statistic by subset size 
library(car)
subsets(leaps, statistic="rsq")




library(mlbench)
data(Sonar)
str(Sonar[, 1:10])
library(caret)
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
                        n.trees = (1:30)*50, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)
gbmGrid2 <-  expand.grid(interaction.depth = c(1, 5, 9))

nrow(gbmGrid)

set.seed(825)
gbmFit2 <- train(Class ~ ., data = training, 
                 method = "gbm", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 ## Now specify the exact models 
                 ## to evaluate:
                 tuneGrid = gbmGrid2)
gbmFit2

trellis.par.set(caretTheme())
plot(gbmFit2)

plot(lasso.gt$results$fraction, lasso.gt$results$RMSE,
     ylim=range(c(lasso.gt$results$RMSE-lasso.gt$results$RMSESD, lasso.gt$results$RMSE+lasso.gt$results$RMSESD)),
     pch=19, xlab="Measurements", ylab="Mean +/- SD",
     main="Scatter plot with std.dev error bars"
)
arrows(lasso.gt$results$fraction, avg-sdev, x, avg+sdev, length=0.05, angle=90, code=3)
plot(lasso.gt)
ggplot(lasso.gt)

plotWithBars <- function(model){
  library(ggplot2)
  
  foo <- model$results
  colnames(foo)[1] <- "params"
  ggplot(foo, aes(x=params, y=RMSE), main="Regression of MPG on Weight", 
         xlab="Weight", ylab="Miles per Gallon") + 
    geom_errorbar(aes(ymin=RMSE-RMSESD, ymax=RMSE+RMSESD), width=.1) +
    geom_line() +
    geom_point()+ expand_limits(y = 0)+ theme_bw()
}
plotWithBars(knn.gt)

plot(lasso.gt$results$RMSE, avg,
     ylim=range(c(avg-sdev, avg+sdev)),
     pch=19, xlab="Measurements", ylab="Mean +/- SD",
     main="Scatter plot with std.dev error bars"
)

testing <- svm(gt~., phone_data_gt, type="nu-regression")
