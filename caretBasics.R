library(caret)
library(kernlab) 

# Splitting spam data into train test sets
data(spam)
inTrain <- createDataPartition(y=spam$type, p=0.75, list=FALSE)

training <- spam[inTrain,]
testing <- spam[-inTrain,]

dim(training)

# fit a model
set.seed(32343)
modelFit <- train(type ~ ., data=training, method="glm")
modelFit

#see the coeffiecients of the model
modelFit$finalModel

#make predictions on the testing set
predictions <- predict(modelFit, newdata=testing)
predictions

#confusion Matrix
confusionMatrix(predictions, testing$type)


# Data Slicing ------------------------------------------------------------

#for cross validation K-folds
set.seed(32323)
folds <- createFolds(y=spam$type, k=10, list=TRUE, returnTrain = TRUE)

sapply(folds, length)

#returnTrain=TRUE returns the folds for the training

#returnTrain=False returns the test set

folds <- createFolds(y=spam$type, k=10, list=TRUE, returnTrain = FALSE)

sapply(folds, length)

# Resampling with replacement
set.seed(32323)
folds <-createResample(y=spam$type, times=10, list=TRUE)
sapply(folds, length)
