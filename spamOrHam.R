# Global Environment Setup ------------------------------------------------

rm(list=ls())
library(kernlab)

data("spam")

#perform the susb sampling
set.seed(3435)
trainIndicator <- rbinom(4601, size = 1, prob = 0.5)

table(trainIndicator)
# trainIndicator
#    0    1 
# 2314 2287 

trainSpam <- spam[trainIndicator == 1,]
testSpam <- spam[trainIndicator == 0,]


# Exploratory Analysis ----------------------------------------------------

names(trainSpam)
head(trainSpam)
table(trainSpam$type)

plot(trainSpam$capitalAve ~ trainSpam$type)

#plot log of the data for better visualization
#+1 to get rid of zeros (and posibilitate evaluation of log10)
plot(log10(trainSpam$capitalAve+1) ~ trainSpam$type)

#relationship between predictors
plot(log10(trainSpam[,1:4] +1))

#clustering

hCluster <- hclust(dist(t(log10(trainSpam[,1:55]+1))))
plot(hCluster)


# Statistical Prediction / Modeling ---------------------------------------

trainSpam$numType <- as.numeric(trainSpam$type) - 1
costFunction <- function(x,y) sum(x != (y>0.5))
cvError <- rep(NA, 55)
library(boot)
for(i in 1:55){
  lmFormula <- reformulate(names(trainSpam)[i], response = "numType")
  glmFit <- glm(lmFormula, family = "binomial", data = trainSpam)
  cvError[i] <- cv.glm(trainSpam, glmFit, costFunction, 2)$delta[2]
}

## which predictor has minimum cross validated error?
names(trainSpam)[which.min(cvError)]
# [1] "charDollar"


# Get a measure of uncertainty --------------------------------------------

## Use the best model for the group
predictionModel <- glm(numType ~ charDollar, family="binomial",
                       data = trainSpam)

##Get predictions on the test set
predictionTest <- predict(predictionModel,testSpam)
predictedSpam <- rep("nospam",dim(testSpam)[1])

## Classify as "spam" for those with probabilities > 0.5
predictedSpam[predictionModel$fitted > 0.5] <- "spam"

## Classification table
table(predictedSpam, testSpam$type)
# predictedSpam nonspam spam
# nospam           1346  458
# spam               61  449

##Error rate
(61 + 458)/(1346 + 458 + 61 + 449)
# [1] 0.2242869