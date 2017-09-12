library(MASS)
library(dplyr)

data("shuttle")
data("InsectSprays")

head(shuttle)

shuttle <- mutate(shuttle,
                  autolander = 1 * (use == "auto"),
                  winddir = 1 * (wind == "head"))

fit <- glm(autolander ~ winddir, data = shuttle, family = binomial)
fit2 <- glm(autolander ~ winddir+magn, data = shuttle, family = binomial)

head(InsectSprays)

levels(InsectSprays$spray)
InsectSpraysAB <- InsectSprays[InsectSprays$spray=="A"|InsectSprays$spray=="B",]
poissonglm <- glm(InsectSpraysAB$count ~ InsectSpraysAB$spray - 1, family = "poisson")
summary(poissonglm)

exp.coef <- exp(coef(poissonglm))
