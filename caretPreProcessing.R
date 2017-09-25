library(caret)
library(kernlab)

data(spam)

#createDataPartition generates the indexes to be used in the partition
inTrain <- createDataPartition(y=spam$type, p=0.75, list = FALSE)

training <- spam[inTrain,]
testing <- spam[-inTrain,]

#By plotting the variables we check for weird behaviours in their distribution, skewed
# distributions etc -> need to transform them in order to make them more useful for
# prediction algorithms. This is particularly true when you're using
# model based algorithms. Like linear discriminate analysis, naive Bayes, linear regression

# histogram of average of capital letters IN A ROW, in spam training set
hist(training$capitalAve, main = "", xlab = "Average capital run length")

# In the histogram we can see that most averages ara about 0 to 100 but there are
# a few moch more larger (up to 1200) so we have a very SKEWED VARIABLE

mean(training$capitalAve)
# [1] 5.092227
sd(training$capitalAve)
# [1] 29.72811

# The standard deviation shows how  highly variable the variable is,
# so the need to preprocess:

# Standardizing  -----------------------------------------------------------

trainCapAve <- training$capitalAve
trainCapAveS <- (trainCapAve-mean(trainCapAve))/sd(trainCapAve)
mean(trainCapAveS) #really close to zero
sd(trainCapAveS) # 1

#Standardizing the test set
# IMPORTANT when running a prediction model on the testing set, we standardize
# the set using the mean and sd FROM the TRAINING set

testCapAve <- testing$capitalAve
testCapAveS <- (testCapAve-mean(trainCapAve))/sd(trainCapAve)
mean(testCapAveS) # WILL not be zero
sd(testCapAveS)  # WILL not be 1


# caret::preProcess function ----------------------------------------------

names(training)[58]
# [1] "type"
preObj <- preProcess(training[,-58], method = c("center","scale"))
# This will create an object usable to preprocess both the training and testing set
# this method performs the same normal standardization as in the previous chunk
# On ALL VARIABLES

trainCapAveS <- predict(preObj, training[,-58])$capitalAve
mean(trainCapAveS)
sd(trainCapAveS)

# the same preObj can be used to preprocess the testing set. The predict
# function will take the same values calculated with the traininig set an apply them
# to the testing set
testCapAveS <- predict(preObj, testing[,-58])$capitalAve
mean(testCapAveS)
sd(testCapAveS)

# PASSING preProcess as an ARGUMENT to caret::train function
set.seed(32343)
modelFit <- train(type ~., data = training, preProcess=c("center", "scale"),
                  method="glm")
modelFit

# Box Cox Transform -------------------------------------------------------


# A Box Cox transformation is a way to transform non-normal dependent variables into a
# normal shape. Normality is an important assumption for many statistical techniques;
# if your data isn’t normal, applying a Box-Cox means that you are able to run a broader
# number of tests.

preObj <- preProcess(training[,-58], method = c("BoxCox"))
trainCapAveS <- predict(preObj, training[,-58])$capitalAve

#checking that the new data is normal:
par(mfrow=c(1,2))
hist(trainCapAveS)
qqnorm(trainCapAveS)

# Impute data -------------------------------------------------------------

# if some data is missing (NA's) we have to impute values into the data set, since
# usually prediction and training algorithms don't handle missing data


# For the example make some values NA
set.seed(13343)
training$capAveNA <- training$capitalAve
selectNA <- rbinom(dim(training)[1], size = 1, prob = 0.05) == 1
training$capAveNA[selectNA] <- NA

# Impute and standardize (impute using k-nearest neighbors)
preObj <- preProcess(training[,-58], method = c("knnImpute"))
capAve <- predict(preObj, training[,-58])$capAveNA

# Standardize True Values
capAveTruth <- training$capitalAve
capAveTruth <- (capAveTruth-mean(capAveTruth))/sd(capAveTruth)

# compare the true standardized set with the standardized imputed set
quantile(capAve - capAveTruth)

# Just the imputed values
quantile((capAve - capAveTruth)[selectNA])

# Principal Components Analysis -------------------------------------------

# FIRST we find which variables have a correlation bigger than 0.8
M <- abs(cor(training[,-58])) #column 58 is the output ("type" two levels: "spam" "nospam")
diag(M) <- 0 # to get rid of the 1's in the diagonal of the matrix of correlations
which(M > 0.8, arr.ind = TRUE)

##        row col
## num415  34  32
## num857  32  34

## So the variables "num415" and "num857" are highly correlated

names(spam)[c(34,32)]

## [1] "num415" "num857"

plot(spam[,34], spam[,32])

## PCA in use prcomp
smallSpam <- spam[,c(34,32)]
prComp <- prcomp(smallSpam)
plot(prComp$x[,1], prComp$x[,2])

prComp$rotation

##              PC1        PC2
## num415 0.7080625  0.7061498
## num857 0.7061498 -0.7080625

## So the first principal component is almost identical to adding the two variables, and the second subtracting

# PCA on spam data --------------------------------------------------------

typeColor <- ((spam$type=="spam")*1 + 1) #black if spam, red if not spam
prComp <- prcomp(log10(spam[,-58] + 1))
plot(prComp$x[,1], prComp$x[,2], col = typeColor, xlab = "PC1", ylab = "PC2")

## PCA with caret
preProc <- preProcess(log10(spam[,-58]+1), method = "pca", pcaComp = 2)
spamPC <- predict(preProc, log10(spam[,-58]+1))
plot(spamPC[,1],spamPC[,2], col = typeColor)

## fitting the model with principal components
preProc <- preProcess(log10(training[,-58]+1), method = "pca", pcaComp = 2)
trainPC <- predict(preProc, log10(training[,-58]+1))
modelFit <- train(x = trainPC, y = training$type,method="glm")

## trying the model with PCA on the testing set
testPC <- predict(preProc, log10(testing[,-58]+1))
confusionMatrix(testing$type, predict(object = modelFit,testPC))

## Doing the preprocessing as part of the training process
modelFit <- train(type ~ ., method = "glm", preProcess = "pca", data = training)

## predict on the testing set and confusion matrix
confusionMatrix(testing$type, predict(object = modelFit,testing))

## Confusion Matrix and Statistics

##           Reference
## Prediction nonspam spam
##    nonspam     666   31
##    spam         63  390

##                Accuracy : 0.9183
##                  95% CI : (0.9009, 0.9334)
##     No Information Rate : 0.6339
##     P-Value [Acc > NIR] : < 2.2e-16

##                   Kappa : 0.8267
##  Mcnemar's Test P-Value : 0.001387

##             Sensitivity : 0.9136
##             Specificity : 0.9264
##          Pos Pred Value : 0.9555
##          Neg Pred Value : 0.8609
##              Prevalence : 0.6339
##          Detection Rate : 0.5791
##    Detection Prevalence : 0.6061
##       Balanced Accuracy : 0.9200

##        'Positive' Class : nonspam
