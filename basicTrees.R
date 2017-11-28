## written by following the example in chapter 8 ISLR

library(ISLR)
library(caret)

data(Hitters)

hittersSalary <- Hitters[!is.na(Hitters$Salary),]
hist(hittersSalary$Salary)

hittersSalary$Salary <- log(hittersSalary$Salary)

BoxCoxTrans(hittersSalary$Salary)
