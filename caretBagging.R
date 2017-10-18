library(caret)
library(ElemStatLearn)

data(ozone)

ozone <- ozone[order(ozone$ozone),]
head(ozone)

## Bootstrapping aggregation by hand -----------------------------------------------------------------
ll <- matrix(NA, nrow = 10, ncol = 155)

## BAGGED LOESS
## We are going to try to predict temperature as a function of ozone
## Using a loess (local polynomial regression fitting) -similar to spline-
## and using Bootstrapping aggregation

for (i in 1:10){ #resample the data 10 different times WITH replacement
    ss <- sample(1:dim(ozone)[1], replace = TRUE)
    ozonetemp <- ozone[ss,]
    ozonetemp <- ozonetemp[order(ozonetemp$ozone),]
    loesstemp <- loess(temperature ~ ozone, data = ozonetemp, span = 0.2)
    ## fit each of the resampled data sets with a loess smooth curve
    ll[i,] <- predict(loesstemp, newdata = data.frame(ozone = 1:155))
}

## The matrix ll contains the temperature predicted by the loess curve
## fitted to each of the 10 resampled ozone set of ozone values

plot(x = ozone$ozone, y = ozone$temperature, pch = 19, cex = .5)

## add the 10 loess curves to the plot
for(i in 1:10){
lines(x=1:155, y=ll[i,], col = "grey", lwd = 2)
}

## add a red curve for the mean of the loess curves.
## THIS IS THE BAGGED LOESS CURVE
lines(x=1:155, y=apply(ll, 2, mean), col = "red", lwd = 2)
lines(x=1:155, y=apply(ll, 2, median), col = "green", lwd = 2)

## Bagging in Caret -----------------------------------------------------------------

## The idea here is  to take the predictor variable and put it into one data frame.The predictors data frame that contains the ozone data.
## The  outcome variable. it's going to be just a temperature variable from the data set and pass this to the bag function in caret package.
## parameters are  predictors  (data frame), outcome, number of replications with the number of sub samples to take from the data set.
## bagControl is about how to fit the model. So fit is the function that's going to be applied to fit the model every time.
## This could be a call to the train function in the caret package.
## Predict is a the way that given a particular model fit, that we'll be able to predict new values.
## So this could be, for example, a call to the predict function from a trained model.
## And then aggregate is the way that we'll put the var, the predictions together.
## So for example it could average the predictions across all the different replicated samples.

predictors <- data.frame(ozone$ozone)
temperature <- ozone$temperature

treebag <- bag(predictors, temperature, B = 10,
               bagControl = bagControl(fit = ctreeBag$fit,
                                       predict = ctreeBag$pred,
                                       aggregate = ctreeBag$aggregate))


plot(ozone$ozone, temperature, col = "lightgrey", pch = 19)
points(ozone$ozone, predict(treebag$fits[[1]]$fit, predictors), pch = 19, col = "red") #fit from a single cond. regression tree
points(ozone$ozone, predict(treebag, predictors), pch = 19, col = "blue") #fit from the bagged (10 model fits) cond. regression tree

## ctreeBag is a caret function that returns a conditional regression tree trained on the data set

ctreeBag$fit

## function (x, y, ...)
## {
##     loadNamespace("party")
##     data <- as.data.frame(x)
##     data$y <- y
##     party::ctree(y ~ ., data = data)
## }
## <environment: namespace:caret>

ctreeBag$pred # calculates the tree response given newdata (x) given the trained tree (object)

## function (object, x)
## {
##     if (!is.data.frame(x))
##         x <- as.data.frame(x)
##     obsLevels <- levels(object@data@get("response")[, 1])
##     if (!is.null(obsLevels)) {
##         rawProbs <- party::treeresponse(object, x)
##         probMatrix <- matrix(unlist(rawProbs), ncol = length(obsLevels),
##             byrow = TRUE)
##         out <- data.frame(probMatrix)
##         colnames(out) <- obsLevels
##         rownames(out) <- NULL
##     }
##     else out <- unlist(party::treeresponse(object, x))
##     out
## }
## <environment: namespace:caret>

ctreeBag$aggregate # the aggregation adds the values and puts them together in some way. In
## this case we'll use ctreeBag$aggregate which gets the prediction from every single one of the model fits, binds them into one data matrix,
## with each row representing the prediction from a specific model prediction and the takes the median of each column (median between model fits)

## function (x, type = "class")
## {
##     if (is.matrix(x[[1]]) | is.data.frame(x[[1]])) {
##         pooled <- x[[1]] & NA
##         classes <- colnames(pooled)
##         for (i in 1:ncol(pooled)) {
##             tmp <- lapply(x, function(y, col) y[, col], col = i)
##             tmp <- do.call("rbind", tmp)
##             pooled[, i] <- apply(tmp, 2, median)
##         }
##         if (type == "class") {
##             out <- factor(classes[apply(pooled, 1, which.max)],
##                 levels = classes)
##         }
##         else out <- as.data.frame(pooled)
##     }
##     else {
##         x <- matrix(unlist(x), ncol = length(x))
##         out <- apply(x, 1, median)
##     }
##     out
## }
## <bytecode: 0x13aae029e0>
## <environment: namespace:caret>
