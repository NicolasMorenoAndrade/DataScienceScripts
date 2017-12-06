## written by following the example in chapter 8 ISLR

library(ISLR)
library(caret)
library(tree)


data(Hitters)

hittersSalary <- Hitters[!is.na(Hitters$Salary),]
hist(hittersSalary$Salary)

## The histogram shows non normal distribution of the data
## We can log normalize or boxcox normalize
predictors <- names(Hitters)[names(Hitters) != "Salary"]

## log
hittersSalary$LogSalary <- log(hittersSalary$Salary)
## Box Cox
bcSalary <- BoxCoxTrans(hittersSalary$Salary)
hittersSalary$bcSalary <- predict(bcSalary, hittersSalary$Salary)

with(hittersSalary, all.equal(bcSalary,LogSalary))
## TRUE

# tree with all possible predictors splits/ leaves
form <- as.formula(paste("LogSalary~",
                         paste(predictors, collapse="+"), sep=""))
salaryTree <- tree(form, data = hittersSalary)
summary(salaryTree)
plot(salaryTree)
text(salaryTree, pretty = 0)

## tree just using years and hits as predictors
islrTree <- tree(LogSalary~Years+Hits, data=hittersSalary)
summary(islrTree)
plot(islrTree)
text(islrTree, pretty = 0)

## Prune previous trees to make exactly equal to ISLR's
prunedIslrTree <- prune.tree(islrTree, best = 3)
plot(prunedIslrTree)
text(prunedIslrTree, pretty = 0)



## set.seed (3)
## cvsalarytree <- cv.tree(salaryTree)
## plot(cvsalarytree)
