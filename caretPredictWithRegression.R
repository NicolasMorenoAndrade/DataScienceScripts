library(caret)

data(faithful)
## This data set contains data on eruptions of Old Faithful Geyser
## A data frame with 272 observations on 2 variables.

##        [,1]  eruptions  numeric  Eruption time in mins
##        [,2]  waiting    numeric  Waiting time to next
##                                  eruption (in mins)


set.seed(333) #for reproducibility

inTrain <- createDataPartition(y = faithful$waiting, p = 0.5, list = FALSE)
trainFaith <- faithful[inTrain, ]
testFaith <- faithful[-inTrain,]

head(trainFaith)
##   eruptions waiting
## 2     1.800      54
## 3     3.333      74
## 4     2.283      62
## 5     4.533      85
## 6     2.883      55
## 7     4.700      88

plot(trainFaith$waiting, trainFaith$eruptions, pch=19, col = "blue", xlab = "Waiting", ylab = "Duration")
## The plot shows the plausibility of a linear model


# Fit an predict manually -------------------------------------------------


## Fit the model
lm1 <- lm(eruptions ~ waiting, data = trainFaith)
summary(lm1)

## Plot predictions: training and test set

par(mfrow = c(1,2))
##training
plot(trainFaith$waiting, trainFaith$eruptions, pch=19, col = "blue", xlab = "Waiting", ylab = "Duration")
lines(trainFaith$waiting, lm1$fitted.values, lwd = 3)

## testing
plot(testFaith$waiting, testFaith$eruptions, pch=19, col = "blue", xlab = "Waiting", ylab = "Duration")
lines(testFaith$waiting, predict(lm1, newdata = testFaith), lwd = 3)

## Get training/test set errors

## Calculate RMSE on training
sqrt(sum((lm1$fitted-trainFaith$eruptions)^2))

## Calculate RMSE on testing set
sqrt(sum((predict(lm1, newdata = testFaith)-testFaith$eruptions)^2))

## Prediction Intervals
pred1 <- predict(lm1, newdata = testFaith, interval = "prediction")
ord <- order(testFaith$waiting)
plot(testFaith$waiting, testFaith$eruptions, pch = 19, col = "blue")
matlines(testFaith$waiting[ord], pred1[ord, ], type = "l", col = c(1,2,2), lty = c(1,1,1), lwd = 3)


# Fit and predict with caret ----------------------------------------------


modFit <- train(eruptions ~ waiting, data = trainFaith, method = "lm")
summary(modFit$finalModel)

manualpred <- predict(lm1, newdata = testFaith)
caretpred <- predict(modFit, newdata = testFaith)

all.equal(manualpred, caretpred)
## [1] TRUE


# Regression with multiple covariates -------------------------------------


library(ISLR)
library(ggplot2)

data(Wage)

Wage <- subset(Wage, select=-c(logwage))
summary(Wage)

## Get training/test sets
inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list=FALSE)
training <- Wage[inTrain, ]
testing <- Wage[-inTrain, ]
dim(training); dim(testing)

## FeaturePlot to see how the variables are related to each other
featurePlot(x=training[,c("age", "education", "jobclass")],
            y = training$wage,
            plot = "pairs")

## Plot age vs wage
qplot(x = age, y = wage, data = training)

## Get more info about the relation by plotting age vs wage, color by jobclass
qplot(x = age, y = wage, color = jobclass, data = training)

## same with education
qplot(x = age, y = wage, color = education, data = training)

## so some combination between age and education explains the "top band" in the first plot

## Fit the multivariate model
modFit <- train(wage ~ age + jobclass + education, method="lm", data = training)
finMod <- modFit$finalModel
print(modFit)

## Diagnostics
par(mfrow = c(1,2))
plot(finMod, pch = 19, cex = 0.5, col = "#00000010")

## Color by variables not used in the model
qplot(finMod$fitted, finMod$residuals, color = race, data = training)

## Plot residuals by index. (by row number). If there is a trend it is highly probable that you are
## missing a variable from your model (time or some other continous variable)
plot(finMod$residuals, pch = 19)

## Predicted values vs truth in TEST set
pred <- predict(modFit, testing)
qplot(wage, pred, color = year, data = testing)
