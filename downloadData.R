setwd("~/Desktop/DataScience/Scripts/")
if(!file.exists("data")) dir.create("data")
fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.csv", method = "curl")

# Didn't find xls version of the file (not on website)
#fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
#download.file(fileURL, destfile = "./data/cameras.xlsx", method = "curl")

fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xml?accessType=DOWNLOAD"
download.file(fileURL, destfile = "./data/cameras.xml", method = "curl")

fileURL <- "https://www.w3schools.com/xml/simple.xml"
download.file(fileURL, destfile = "./data/w3schools.xml", method = "curl")


list.files("./data")

# [1] "cameras.csv"

dateDownloaded <- date()
dateDownloaded
