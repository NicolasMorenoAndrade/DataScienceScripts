library(ISLR)
library(caret)

data(Wage)
inTrain <- createDataPartition(y=Wage$wage, p=0.7, list=FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

head(training$jobclass)
table(training$jobclass)

## Create Dummy variables

dummies <- dummyVars(wage ~ jobclass, data = training)
head(predict(dummies, newdata = training))

## Removing Zero Covariates

## region variable has no variability because it is only one
## category: Middle Atlantic. It shouldn't be used in
## prediction algorithms

nsv <- nearZeroVar(training, saveMetrics = TRUE)
nsv

## Spline Basis
library(splines)
## bs function with parameter df = 3 creates a third degree polynomial
## from the variable passed. Returns a matrix where each column is a power (1,2,3) of the variable.
bsBasis <- bs(training$age, df = 3)
bsBasis

## Fitting Curves with Splines

lm1 <- lm(wage ~ bsBasis, data = training)
plot(training$age, training$wage, pch = 19, cex = 0.5)
points(training$age, predict(lm1, newdata = training),
       col = "red", pch = 19, cex = 0.5)

## Splines on the test set

predict(bsBasis, age=testing$age)
