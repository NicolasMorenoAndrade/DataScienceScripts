library(caret)
library(ggplot2)

data(iris)
names(iris)

table(iris$Species)

## create training and testing sets
inTrain <- createDataPartition(y=iris$Species, p=0.7, list=FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training); dim(testing)

## Build Predictions
modlda <- train(Species ~., data = training, method = "lda") #linear discriminant analysis
modnb <- train(Species ~., data = training, method = "nb") #naive Bayes
plda <- predict(modlda, testing)
pnb <- predict(modnb, testing)

## Compare the two predictions
table(plda, pnb)
