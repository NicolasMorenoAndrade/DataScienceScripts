## written by following the example in chapter 8 ISLR

library(ISLR)
library(caret)
library(tree)


data(Hitters)

hittersSalary <- Hitters[!is.na(Hitters$Salary),]
hist(hittersSalary$Salary)

predictors <- names(Hitters)[names(Hitters) != "Salary"]
hittersSalary$LogSalary <- log(hittersSalary$Salary)

bcSalary <- BoxCoxTrans(hittersSalary$Salary)

hittersSalary$bcSalary <- predict(bcSalary, hittersSalary$Salary)

with(hittersSalary, all.equal(bcSalary,LogSalary))
## TRUE

form <- as.formula(paste("LogSalary~",
                         paste(predictors, collapse="+"), sep=""))
salaryTree <- tree(form, data = hittersSalary)
summary(salaryTree)
plot(salaryTree)
text(salaryTree, pretty = 0)


islrTree <- tree(LogSalary~Years+Hits, data=hittersSalary)
plot(islrTree)
text(islrTree, pretty = 0)

set.seed (3)
## cvsalarytree <- cv.tree(salaryTree)
## plot(cvsalarytree)
