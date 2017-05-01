setwd("~/Desktop/DataScience/Scripts/")
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/quiz1data.csv", method = "curl")

q1data <- read.csv("./data/quiz1data.csv")
names(q1data)
table(q1data$VAL)

q1data$FES

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileURL, destfile = "./data/quiz1data.xlsx", method = "curl")
library(xlsx)
q1dataxls <- read.xlsx("./data/quiz1data.xlsx", sheetIndex = 1, header = FALSE)
dat <- q1dataxls[c(18:23),c(7:15)]

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml" 
library(XML)
library(RCurl)
library(httr)
doc <- xmlTreeParse(rawToChar(GET(fileURL)$content),useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode

zipcodes <- as.numeric(xpathSApply(rootNode, "//zipcode", xmlValue))
class(zipcodes)
length(zipcodes[zipcodes==21231])

library(data.table)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = "./data/quiz1data_2.csv", method = "curl")
DT <- fread("./data/quiz1data_2.csv")
class(DT)

system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(DT[,mean(pwgtp15),by=SEX])
