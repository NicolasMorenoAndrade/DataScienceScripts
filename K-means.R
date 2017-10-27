

load("~/Desktop/DataScience/Scripts/data/kmeansSwirl.RData")


# Intuition - Centroids by hand -------------------------------------------

dataFrame$x -> x
dataFrame$y -> y

# plot initial (guessed) centroids
plot.new()

points(cx,cy,col=c( "red", "orange", "purple"), pch=3, cex=2,lwd=2)


mdist <- function(x,y,cx,cy)
{
  distTmp <- matrix(NA, nrow = 3, ncol = 12)
  distTmp[1, ] <- (x - cx[1])^2 + (y - cy[1])^2
  distTmp[2, ] <- (x - cx[2])^2 + (y - cy[2])^2
  distTmp[3, ] <- (x - cx[3])^2 + (y - cy[3])^2
  return(distTmp)
}

distTmp <- mdist(x,y,cx,cy)
#find min distance to current centroid
newClust <- apply(distTmp,2,which.min)
# [1] 2 2 2 1 3 3 3 1 3 3 3 3

cols1 <- c("red","orange","purple")
points(x,y,pch=19, cex=2, col=cols1[newClust])

#new centroids calculation
#x-coordinates
newCx <- tapply(x,newClust,mean)
# 1        2        3
# 1.210767 1.010320 2.498011

#y-coordinates
newCy <- tapply(y,newClust,mean)
# 1        2        3
# 1.730555 1.016513 1.354373

points(newCx,newCy,col=cols1,pch=8,cex=2,lwd=2)

distTmp2 <- mdist(x,y,newCx,newCy)

newClust2 <- apply(distTmp2,2,which.min)
# [1] 2 2 2 2 3 3 1 1 3 3 3 3

points(x,y,pch=19, cex=2, col=cols1[newClust2])

#new centroids calculation
#x-coordinates
finalCx <- tapply(x,newClust,mean)
#y-coordinates
finalCy <- tapply(y,newClust,mean)

points(finalCx,finalCy,col=cols1,pch=9,cex=2,lwd=2)



# R kmeans() --------------------------------------------------------------

# eturns the information that the data clustered into 3 clusters each of size 4. It also
# returns the coordinates of the 3 cluster means, a vector named cluster indicating how the 12 points were
# partitioned into the clusters, and the sum of squares within each cluster. It also shows all the
# available components returned by the function.

kmObj <- kmeans(dataFrame,centers=3)
# #of iterations the algorithm perform
kmObj$iter

#plot using the clusters just found as colors
plot(x,y, col=kmObj$cluster,pch=19,cex=2)

#add centroids to the plot
points(kmObj$centers,col=c("black","red","green"), pch=3, cex=3, lwd=3)

# Now for some fun! We want to show you how the output of the kmeans function is affected by its random
# start (when you just ask for a number of clusters). With random starts you might want to run the
# function several times to get an idea of the relationships between your observations. We'll call kmeans
# with the same data points (stored in dataFrame), but ask for 6 clusters instead of 3.


#visualize the reclustering
plot(x,y, col=kmeans(dataFrame,centers=6)$cluster,pch=19,cex=2)

# a few more times...
plot(x,y, col=kmeans(dataFrame,centers=6)$cluster,pch=19,cex=2)
plot(x,y, col=kmeans(dataFrame,centers=6)$cluster,pch=19,cex=2)

# Keeps on changing due to kmeans() random initialization of centroids..
# perhaps 6 are too many clusters.. less!
