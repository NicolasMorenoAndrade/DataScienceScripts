
save(dataMatrix, faceData, mat, file = "~/Desktop/DataScience/Scripts/data/pcaSvd.Rdata")

heatmap(dataMatrix)


#add pattern to the random data matrix
set.seed(678910)
for(i in 1:40){
  # flip a coin
  coinFlip <- rbinom(1,size=1,prob=0.5)
  # if coin is heads add a common pattern to that row
  if(coinFlip){
    dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,3),each=5)
  }
}


# SVD ---------------------------------------------------------------------


# X=UDV^t
# Here U and V each have orthogonal (uncorrelated) columns. U's columns are the left singular vectors of X
# and V's columns are the right singular vectors of X.  D is a diagonal matrix, by which we mean that all
# of its entries not on the diagonal are 0. The diagonal entries of D are the singular values of X.

#toy example of SVD
mat
#      [,1] [,2] [,3]
# [1,]    1    2    3
# [2,]    2    5    7

svd(mat)

# $d
# [1] 9.5899624 0.1806108
# 
# $u
#            [,1]       [,2]
# [1,] -0.3897782 -0.9209087
# [2,] -0.9209087  0.3897782
# 
# $v
#            [,1]       [,2]
# [1,] -0.2327012 -0.7826345
# [2,] -0.5614308  0.5928424
# [3,] -0.7941320 -0.1897921

matu <- svd(mat)$u
matv <- svd(mat)$v
diag <- svd(mat)$d

matu %*% diag %*% t(matv)


# PCA ---------------------------------------------------------------------

#relation of pca with svd
svd(scale(mat))
prcomp(scale(mat))

# Notice that the principal components of the scaled matrix, shown in the Rotation component of the prcomp
# output, ARE the columns of V, the right singular values. Thus, PCA of a scaled matrix yields the V
# matrix (right singular vectors) of the same scaled matrixvd1.

svd1 <- svd(dataMatrix)
svd1$v[,1]


# data compression Facedata -----------------------------------------------

dim(faceData)

svd1 <- svd(scale(faceData))
a1 <- (svd1$u[,1] * svd1$d[1]) %*% t(svd1$v[,1])

myImage <- function(iname){
  par(mfrow=c(1,1))
  par(mar=c(4,5,4,5))
  image(t(iname)[,nrow(iname):1])
}

myImage(a1)

a2 <- svd1$u[,1:2] %*% diag(svd1$d[1:2]) %*% t(svd1$v[,1:2])

myImage(a2)
myImage(svd1$u[,1:5] %*% diag(svd1$d[1:5]) %*% t(svd1$v[,1:5]))
myImage(svd1$u[,1:10] %*% diag(svd1$d[1:10]) %*% t(svd1$v[,1:10]))

