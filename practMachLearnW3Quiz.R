library(AppliedPredictiveModeling)
library(caret)
library(rattle)
library(rpart)


data(segmentationOriginal)
names(segmentationOriginal)

training <- segmentationOriginal[segmentationOriginal$Case=="Train",]
testing <- segmentationOriginal[segmentationOriginal$Case=="Test",]

set.seed(125)

modFit <- train(Class ~ ., method = "rpart", data = training)

modFit$finalModel

fancyRpartPlot(modFit$finalModel)
