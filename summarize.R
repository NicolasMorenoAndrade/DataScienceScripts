#Getting and cleaning data class. About summarizing Script 


# Download data -----------------------------------------------------------


setwd("~/Desktop/DataScience/Scripts")
if(!file.exists("./data")) {
  dir.create("./data")
}
fileURL <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/restaurants.csv", method="curl")
restData <- read.csv("./data/restaurants.csv")

# Looking at the data
head(restData, n=3)
summary(restData)
str(restData)

#Quantiles of quantitative variables
quantile(restData$councilDistrict, na.rm = TRUE)
quantile(restData$councilDistrict, probs=c(0.5,0.75,0.9),na.rm = TRUE)

#look at specific variables and make a table
table(restData$zipCode, useNA = "ifany")

#check for missing values
sum(is.na(restData$councilDistrict))
any(is.na(restData$councilDistrict))
colSums(is.na(restData))
all(colSums(is.na(restData))==0)

#values with specific charactertics
table(restData$zipCode %in% c("21212", "21213"))

#subsetting 
restData[restData$zipCode %in% c("21212", "21213"),]

#cross tabs
data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)
#Cross Tabs...
xt <- xtabs(Freq ~ Gender + Admit, data=DF)
xt

#Flat tables
warpbreaks$replicate <- rep(1:9, len=54)
xt <- xtabs(breaks ~.,data = warpbreaks)
xt
ftable(xt)

#size of a data set
fakeData =rnorm(1e5)
object.size(fakeData)
#human readable:
print(object.size(fakeData), units = "Mb")


# Creating New Variables --------------------------------------------------

restData$nearMe <- restData$neighborhood %in% c("Roland Park","Homeland")
table(restData$nearMe)

#Creating binary variables
restData$zipWrong <- ifelse(restData$zipCode<0,TRUE,FALSE)
table(restData$zipCode<0)

# Creating categorical variables
restData$zipGroups <- cut(restData$zipCode, breaks = quantile(restData$zipCode))
table(restData$zipGroups)

#Easier cuts
library(Hmisc)
restData$zipGroups <- cut2(restData$zipCode, g=4)
table(restData$zipGroups)


#creating Factor variables
restData$zcf <- factor(restData$zipCode)
restData$zcf[1:10]

#Levels of factor variable
yesno <- sample(c("yes","no"), size=10, replace=TRUE)
yesnofac <- factor(yesno, levels = c("yes","no"))
relevel(yesnofac,ref="yes")

as.numeric(yesnofac)

#using the mutate (plyr) function
library(plyr)
restData2 <- mutate(restData, zipGroups=cut2(zipCode,g=4))
table(restData2$zipGroups)


# Reshaping data ----------------------------------------------------------
library(reshape2)
head(mtcars)

#melting data frames
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars = c("mpg","hp"))
head(carMelt)

#casting data frames
cylData <- dcast(carMelt, cyl~variable)
cylData

cylData <- dcast(carMelt, cyl~variable, mean)
cylData

#averaging values
head(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, sum)

#with plyr
ddply(InsectSprays, .(spray), summarize, sum=sum(count))
spraySums <- ddply(InsectSprays, .(spray), summarize, sum=ave(count, FUN = sum))


# Merge dfs with join (dplyr) ---------------------------------------------

df1 <- data.frame(id=sample(1:10), x=rnorm(10))
df2 <- data.frame(id=sample(1:10), y=rnorm(10))
df3 <- data.frame(id=sample(1:10), z=rnorm(10))
dfList <- list(df1,df2,df3)
join_all(dfList)

