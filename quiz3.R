
setwd("~/Desktop/DataScience/Scripts")
if(!file.exists("./data")) {
  dir.create("./data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/idahoHousing.csv", method="curl")
idahoData <- read.csv("./data/idahoHousing.csv")

head(idahoData)

agricultureLogical <- idahoData$ACR == 3 & idahoData$AGS == 6 


which(agricultureLogical)

library(jpeg)
library(dplyr)
jpgURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(jpgURL, destfile = "./data/instructor.jpg", method="curl")
jpgData <- readJPEG("./data/instructor.jpg", native = TRUE)

quantile(jpgData, probs = c(0.3, 0.8))


GDPfileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
EDUfileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(GDPfileURL, destfile = "./data/gdpcontries.csv", method="curl")
download.file(EDUfileURL, destfile = "./data/educontries.csv", method="curl")

gdp <- read.csv("./data/gdpcontries.csv", skip=3)
names(gdp)[1] <- "CountryCode"
names(gdp)[names(gdp)=="US.dollars."] <- "USD"
class(gdp$USD)
gdp <- select(gdp, CountryCode, Ranking, Economy, USD)
gdp <- gdp[2:232,]

gdp[gdp$Ranking=="","Ranking"] <- NA
gdp$Ranking <- as.numeric(as.character(gdp$Ranking))
edu <- read.csv("./data/educontries.csv")

gdprank <- gdp[!is.na(gdp$Ranking),]
gdprank$USD <- as.character(gdprank$USD)
gdprank$USD <- gsub(",","", gdprank$USD)
gdprank$USD <- as.numeric(gdprank$USD)
test <- merge(gdprank,edu, by="CountryCode")
test2 <- test[order(-test$Ranking),]


by_income <- group_by(test, Income.Group)
income_avg <- summarize(by_income, avg_income = mean(USD, na.rm = TRUE))


by_rank <- group_by(test, Income.Group)
income_rank <- summarize(by_rank, avg_rank = mean(Ranking, na.rm = TRUE))


#Easier cuts
library(Hmisc)
test$rankGroups <- cut2(test$Ranking, g=5)
table(test$rankGroups, test$Income.Group )
