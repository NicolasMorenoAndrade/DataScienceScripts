setwd("~/Desktop/DataScience/Scripts")
if(!file.exists("./data")) {
  dir.create("./data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/idahoHousing.csv", method="curl")
idahoData <- read.csv("./data/idahoHousing.csv")

strsplit(names(idahoData), split = "wgtp")[123]

library(dplyr)
GDPfileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
EDUfileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(GDPfileURL, destfile = "./data/gdpcontries.csv", method="curl")
download.file(EDUfileURL, destfile = "./data/educontries.csv", method="curl")

gdp <- read.csv("./data/gdpcontries.csv", skip=3)
names(gdp)[1] <- "CountryCode"
names(gdp)[names(gdp)=="US.dollars."] <- "USD"
class(gdp$USD)
gdpfull <- gdp
gdp <- select(gdp, CountryCode, Ranking, Economy, USD)


gdp[gdp$Ranking=="","Ranking"] <- NA
gdp$Ranking <- as.numeric(as.character(gdp$Ranking))
edu <- read.csv("./data/educontries.csv")

gdprank <- gdp[!is.na(gdp$Ranking),]
gdprank$USD <- as.character(gdprank$USD)
gdprank$USD <- gsub(",","", gdprank$USD)
gdprank$USD <- as.numeric(gdprank$USD)


mean(gdprank$USD)

names(gdprank)[names(gdprank)=="Economy"] <- "countryNames"

gdprank[grep("^United",gdprank$countryNames),"countryNames"]

test <- merge(gdpfull,edu, by="CountryCode")
fiscal <- test$Special.Notes
grep("[Ff]iscal( +year)", fiscal)

haveinfo <- fiscal[grep("[Ff]iscal( +year)", fiscal)]
length(grep("[Jj]une", haveinfo))


library(quantmod)
library(lubridate)

amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
sampleTimes <- as.data.frame(sampleTimes)
sampleTimes$weekday <- wday(sampleTimes$sampleTimes, label = TRUE)
sampleTimes$year <- year(sampleTimes$sampleTimes)

sum(sampleTimes$year==2012)
sum(sampleTimes$year==2012 & sampleTimes$weekday=="Mon")
