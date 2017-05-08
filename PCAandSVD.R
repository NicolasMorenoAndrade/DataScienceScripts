
save(dataMatrix, mat, file = "~/Desktop/DataScience/Scripts/data/pcaSvd.Rdata")

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