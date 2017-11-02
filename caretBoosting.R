library(ISLR)
library(caret)
library(ggplot2)

data(Wage)

Wage <- subset(Wage, select = -c(logwage))
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <-  Wage[inTrain, ]
testing <- Wage[-inTrain, ]

## Fit the model
## gbm := Stochastic Gradient Boosting
modFit <- train(wage ~ ., method = "gbm", data = training, verbose = FALSE)
print(modFit)

## plot the results
qplot(predict(modFit, newdata = testing), wage, data = testing)
