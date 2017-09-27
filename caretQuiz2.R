library(caret)
library(AppliedPredictiveModeling)
set.seed(3433)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)
inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training = adData[ inTrain,]
testing = adData[-inTrain,]

## Question 4 -----------------------------------------------------------------

## Find all the predictor variables in the training set that begin with IL. Perform principal components on these variables with the preProcess() function from the caret package. Calculate the number of principal components needed to capture 80% of the variance. How many are there?

colsinteres <- names(training)[grep("^IL", names(training))]

ILvarsPCA <- preProcess(x=training[,colsinteres], method = c("center", "scale", "pca"), thresh = 0.8)
ILvarsPCA

## Created from 251 samples and 12 variables

## Pre-processing:
##   - centered (12)
##   - ignored (0)
##   - principal component signal extraction (12)
##   - scaled (12)

## PCA needed 7 components to capture 80 percent of the variance

## Question 5 -----------------------------------------------------------------

## Create a training data set consisting of only the predictors with variable names beginning with IL and the diagnosis. Build two predictive models, one using the predictors as they are and one using PCA with principal components explaining 80% of the variance in the predictors. Use method="glm" in the train function.

## What is the accuracy of each method in the test set? Which is more accurate?

colsinteres <- c(colsinteres, "diagnosis")

minitrain <- training[,colsinteres]
minitest <- testing[,colsinteres]

names(minitrain)
## [1] "IL_11"         "IL_13"         "IL_16"         "IL_17E"
## [5] "IL_1alpha"     "IL_3"          "IL_4"          "IL_5"
## [9] "IL_6"          "IL_6_Receptor" "IL_7"          "IL_8"
## [13] "diagnosis"


## FULL MODEL NON PCA:

fullmodelFit <- train(diagnosis ~ ., data = minitrain, method = "glm")
fulltestPred <- predict(object = fullmodelFit, newdata = minitest[,-13])
confusionMatrix(minitest$diagnosis, fulltestPred)

## Confusion Matrix and Statistics

##           Reference
## Prediction Impaired Control
##   Impaired        2      20
##   Control         9      51

##                Accuracy : 0.6463
##                  95% CI : (0.533, 0.7488)
##     No Information Rate : 0.8659
##     P-Value [Acc > NIR] : 1.00000

##                   Kappa : -0.0702
##  Mcnemar's Test P-Value : 0.06332

##             Sensitivity : 0.18182
##             Specificity : 0.71831
##          Pos Pred Value : 0.09091
##          Neg Pred Value : 0.85000
##              Prevalence : 0.13415
##          Detection Rate : 0.02439
##    Detection Prevalence : 0.26829
##       Balanced Accuracy : 0.45006

##        'Positive' Class : Impaired



## MODEL WITH PCA PREPROCESSING

preProcObj <- preProcess(x = minitrain[,-13], method = c("center", "scale", "pca"), thresh = 0.8)

trainPCA <- predict(object = preProcObj, newdata = minitrain[,-13])
testPCA <- predict(object = preProcObj, newdata = minitest[,-13])

modelFit <- train(x=trainPCA, y=minitrain$diagnosis, method = "glm")
modelFit

testPredictPCA <- predict(object = modelFit, newdata = testPCA)
confusionMatrix(minitest$diagnosis, testPredictPCA)

## Confusion Matrix and Statistics

##           Reference
## Prediction Impaired Control
##   Impaired        3      19
##   Control         4      56

##                Accuracy : 0.7195
##                  95% CI : (0.6094, 0.8132)
##     No Information Rate : 0.9146
##     P-Value [Acc > NIR] : 1.000000

##                   Kappa : 0.0889
##  Mcnemar's Test P-Value : 0.003509

##             Sensitivity : 0.42857
##             Specificity : 0.74667
##          Pos Pred Value : 0.13636
##          Neg Pred Value : 0.93333
##              Prevalence : 0.08537
##          Detection Rate : 0.03659
##    Detection Prevalence : 0.26829
##       Balanced Accuracy : 0.58762

##        'Positive' Class : Impaired
