library(ggplot2)
library(caret)

## Classifying iris data -----------------------------------------------------------------

data(iris)

inTrain <- createDataPartition(y=iris$Species, p = 0.7, list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]

## Training a Random Forest
modFit <- train(Species ~ ., data = training, method = "rf", prox = TRUE)
modFit

## Getting a single tree
getTree(modFit$finalModel, k = 2)

## Class Centers
irisP <- classCenter(training[,c(3,4)], training$Species, modFit$finalModel$proximity)
irisP <- as.data.frame(irisP)
irisP$Species <- rownames(irisP)
p <- qplot(Petal.Width, Petal.Length, col = Species, data = training)
p + geom_point(aes(x=Petal.Width, y=Petal.Length, col = Species), size = 5, shape = 4, data = irisP)

## Predicting New Values
pred <- predict(modFit, newdata = testing)
testing$predRight <- pred == testing$Species
table(pred, testing$Species)

## pred         setosa versicolor virginica
##   setosa         15          0         0
##   versicolor      0         15         3
##   virginica       0          0        12

qplot(Petal.Width, Petal.Length, colour = predRight, data = testing, main = "newdata Predictions")

## Classifying spam data -----------------------------------------------------------------
library(kernlab)
data(spam)

inTrain <- createDataPartition(y=spam$type, p = 0.7, list = FALSE)
training <- spam[inTrain,]
testing <- spam[-inTrain,]

## Training a Random Forest HOW LONG DOES IT TAKE?? (paralell???)
modFit <- train(type ~ ., data = training, method = "rf", prox = TRUE)
modFit
