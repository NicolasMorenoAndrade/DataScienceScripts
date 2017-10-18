library(ggplot2)
library(caret)

data(iris)
names(iris)

table(iris$Species)

inTrain <- createDataPartition(y=iris$Species, p=0.7, list = FALSE)
training <- iris[inTrain,]
testing <- iris[-inTrain,]

dim(training); dim(testing)

## Exploratory
qplot(x = Petal.Width, y = Sepal.Width, color = Species, data = training,)

## Train and plot the tree model -----------------------------------------------------------------

#train the tree model with method recursive partition "rpart"
modFit <- train(Species ~ ., method = "rpart", data = training)

print(modFit$finalModel)

## plot the tree (dendogram), it is also possible to plot with rpart.plot
## or/and (?) rattle
plot(modFit$finalModel, uniform=TRUE, main="Classification Tree")
text(modFit$finalModel, use.n = TRUE, all = TRUE, cex = .8)

## library(rattle)
## library(rpart.plot)
## fancyRpartPlot(modFit$finalModel)

## Predict with tree -----------------------------------------------------------------
predict(modFit, newdata = testing)
