library(dplyr)
setwd("~/Desktop/DataScience/Scripts/")
if(!file.exists("data")) dir.create("data")

# This is the complete data from the experiment 
fileURL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/humanact.zip", method = "curl")

# This is samsungData, the data from the experimen usec in the course and swirl 
# which is just the training data set
load("./data/samsungData.rda")
names(samsungData)[1:12]
table(samsungData$activity)

