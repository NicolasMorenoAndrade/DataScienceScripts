library(datasets)
library(dplyr)

data("Seatbelts")

seatbeltsdf <- as.data.frame(Seatbelts)
head(seatbeltsdf)

seatbeltsdf <- mutate(seatbeltsdf,
                      morethan119 = 1 * (DriversKilled>119),
                      pp = (PetrolPrice - mean(PetrolPrice))/ sd(PetrolPrice),
                      mm = kms/1000,
                      mmc = mm - mean(mm))



logRegKilled <-  glm(morethan119 ~ pp+mmc+law,data=seatbeltsdf,family="binomial")
summary(logRegKilled)

round(summary(logRegKilled)$coef, 3)
