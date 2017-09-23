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
