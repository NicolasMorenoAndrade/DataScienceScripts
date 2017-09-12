load("~/Desktop/DataScience/data/ravensData.rda")
head(ravensData)

#linear model
lmRavens <- lm(ravensData$ravenWinNum ~ ravensData$ravenScore)
summary(lmRavens)$coef

# logistic model
logRegRavens = glm(ravensData$ravenWinNum ~ ravensData$ravenScore,family="binomial")
summary(logRegRavens)

## plotting the fit
plot(ravensData$ravenScore,logRegRavens$fitted,pch=19,col="blue",xlab="Score",
     ylab="Prob Ravens Win")

# To interpret our coefficients, let’s exponentiate them.
exp(logRegRavens$coeff)

exp(confint(logRegRavens))

anova(logRegRavens, test = "Chisq")
