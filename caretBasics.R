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


# Training options --------------------------------------------------------

## Default S3 method:
# train(x, y, method = "rf", preProcess = NULL, ...,
#       weights = NULL, metric = ifelse(is.factor(y), "Accuracy", "RMSE"),
#       maximize = ifelse(metric %in% c("RMSE", "logLoss", "MAE"), FALSE, TRUE),
#       trControl = trainControl(), tuneGrid = NULL,
#       tuneLength = ifelse(trControl$method == "none", 1, 3))


#metric options are "RMSE" (root mean squared error) and "RSquared" (R²) for continous 
# outcomes and "Accuracy" (fraction correct) an "Kappa" (measure of concordance) for
# categorical outcomes

args(trainControl)
# function (method = "boot", number = ifelse(grepl("cv", method), 10, 25), 
#           repeats = ifelse(grepl("[d_]cv$", method), 1, NA), 
#           p = 0.75, search = "grid", initialWindow = NULL, horizon = 1, 
#           fixedWindow = TRUE, skip = 0, verboseIter = FALSE, returnData = TRUE, 
#           returnResamp = "final", savePredictions = FALSE, classProbs = FALSE, 
#           summaryFunction = defaultSummary, selectionFunction = "best", 
#           preProcOptions = list(thresh = 0.95, ICAcomp = 3, k = 5, 
#                             freqCut = 95/5, uniqueCut = 10, cutoff = 0.9), 
#           sampling = NULL, 
#           index = NULL, indexOut = NULL, indexFinal = NULL, timingSamps = 0, 
#           predictionBounds = rep(FALSE, 2), seeds = NA, 
#           adaptive = list(min = 5, alpha = 0.05, method = "gls", complete = TRUE), 
#           trim = FALSE, allowParallel = TRUE) 


# Plotting Predictors -----------------------------------------------------

library(ISLR)
library(ggplot2)

data(Wage)
summary(Wage)

inTrain <- createDataPartition(y = Wage$wage, p = 0.7, list = FALSE)
training <- Wage[inTrain,]
testing <- Wage[-inTrain,]

dim(training); dim(testing)

# feature plot (caret package)
featurePlot(x = training[,c("age", "education", "jobclass")],
            y = training$wage,
            plot = "pairs")

# qplot (ggplot2)
qplot(x=training$age, y=training$wage)

# Use qplot to try to quickly figure out why the outliers
qplot(age, wage, data = training, color=jobclass)

# add regression smoothers
qq <- qplot(age, wage, data = training, color=education)
qq + geom_smooth(method = 'lm', formula=y~x) 

# cut2 making factors (Hmisc package)
library(Hmisc)
cutWage <- cut2(training$wage, g=3)
table(cutWage)  

T1 <- table(cutWage, training$jobclass)
T1

# proportions table
prop.table(T1,1)

#boxplots with the new factors
p1 <-  qplot(cutWage, age, data = training, fill = cutWage, geom = c("boxplot"))
p1

#adding points on top of the boxplots
p2 <-  qplot(cutWage, age, data = training, fill = cutWage, 
             geom = c("boxplot","jitter"))
p2

# use of grid arrange
library(gridExtra)
grid.arrange(p1,p2, ncol=2)

# density plots with qplot
qplot(wage, color=education, data = training, geom = "density")
