library(dplyr)
setwd("~/Desktop/DataScience/Scripts/")
if(!file.exists("data")) dir.create("data")

# This is the complete data from the experiment 
if(!file.exists("./data/humanact.zip")){ 
fileURL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/humanact.zip", method = "curl")
}

# This is samsungData, the data from the experimen usec in the course and swirl 
# which is just the training data set
load("./data/samsungData.rda")
names(samsungData)[1:12]
table(samsungData$activity)

#plotting average acceleration for first subject
par(mfrow = c(1,2), mar = c(5,4,1,1))
samsungData <- transform(samsungData, activity = factor(activity))
sub1 <- subset(samsungData, subject==1)
plot(sub1[,1], col = sub1$activity, ylab = names(sub1)[1])
plot(sub1[,2], col = sub1$activity, ylab = names(sub1)[2])
legend("bottomright", legend = unique(sub1$activity), col = unique(sub1$activity), pch=1)

#clustering based just on average acceleration
source("myplclust.R")
distanceMatrix <- dist(sub1[, 1:3])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))



