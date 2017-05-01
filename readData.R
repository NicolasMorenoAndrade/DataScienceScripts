setwd("~/Desktop/DataScience/Scripts/")
cameraDatacsv <- read.csv("./data/cameras.csv")


# xls ---------------------------------------------------------------------

#read xls with library xlsx
library(xlsx)
cameraDataxlsx <- read.xlsx("./data/cameras.xlsx", sheetIndex = 1, header = TRUE)

# XML ---------------------------------------------------------------------

#read xml with xml package
library(XML)
library(RCurl)
library(httr)


fileURL <- "http://www.w3schools.com/xml/simple.xml"


#La funcion GET del paquete httr fue necesaria por errores multiples del xmlTreeParse al intentar directo input url
doc <- xmlTreeParse(rawToChar(GET(fileURL)$content),useInternal=TRUE)

class(doc)
#[1] "XMLInternalDocument" "XMLAbstractDocument"

rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode

rootNode[[1]]
rootNode[[2]]
rootNode[[2]][[1]]

xmlApply(rootNode,xmlValue)

#get the items on the menu and its prices. Note use of Xpath code (//name)

xpathSApply(rootNode, "//name", xmlValue)
# [1] "Belgian Waffles"             "Strawberry Belgian Waffles"  "Berry-Berry Belgian Waffles" "French Toast"               
# [5] "Homestyle Breakfast"

#price ...
xpathSApply(rootNode, "//price", xmlValue)


# Extract html ------------------------------------------------------------

fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternal=TRUE)
scores <- xpathSApply(doc,"//div[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//div[@class='game-info']",xmlValue)

scores
teams


# JSON --------------------------------------------------------------------

library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)

class(jsonData)
#[1] "data.frame"

head(jsonData)

names(jsonData$owner)
jsonData$owner$login

#data frames into JSON data set to export
myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)

#...and back to data frame
iris2 <- fromJSON(myjson)
head(iris2)

