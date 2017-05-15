
# Environment Setup -------------------------------------------------------


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


# Hierarchical Clustering -------------------------------------------------

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

#plotting max acceleration for the first subject
par(mfrow = c(1,2))
plot(sub1[,10], pch = 19, col = sub1$activity, ylab = names(sub1)[10])
plot(sub1[,11], pch = 19, col = sub1$activity, ylab = names(sub1)[11])

#clustering based on max acceleration
distanceMatrix <- dist(sub1[, 10:12])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))

#singular value decomposition
svd1 <- svd(scale(sub1[,-c(562,563)])) #562 and 563 are just IDS
plot(svd1$u[,1], col = sub1$activity, pch = 19)
plot(svd1$u[,2], col = sub1$activity, pch = 19)


#find maximum contributor
plot(svd1$v[,2], pch = 19) 
maxContrib <- which.max(svd1$v[,2])
#New clustering with maximum contributor
distanceMatrix <- dist(sub1[, c(10:12,maxContrib)])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col= unclass(sub1$activity))


# K-means -----------------------------------------------------------------

#what is the max contributor?
names(samsungData[maxContrib])
# [1] "fBodyAcc.meanFreq...Z"

#k-means clustering (nstart=100, first try)
kClust <- kmeans(sub1[,-c(562,563)], centers=6,
                 nstart=100)
table(kClust$cluster,sub1$activity)

#cluster 5 (Laying) (could be another) Variable Centers (Laying)
plot(kClust$center[5,1:10], pch=19,
     ylab="Cluster Center",
     xlab="")
#cluster 2 (Walking) (could be another) Variable Centers (Laying)
plot(kClust$center[2,1:10], pch=19,
     ylab="Cluster Center",
     xlab="")

