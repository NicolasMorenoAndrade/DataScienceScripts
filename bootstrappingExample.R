## Bootstrap procedure for calculating confidence intervals for the median from a data set of n observations

## 1.  Sample n observations with replacement from the observed dat resulting in one simulated data set
## 2. Take the median (statistic of interest in this example) of the simulated data set
## 3. Repeat these steps B times, resulting in B simulated medians. You want B to be large to counter the 'montecarlo error'
## 4. These medians are approximately drawn from the sampling distribution of the median of n observations. Therefore we can:
##                                                                                        - Draw a Histogram of them
## - Calculate their standard deviation to estimate the standard error of the median
## - Take the 2.5th and 97.5th percentiles as a confidence interval for the median


library(UsingR)
library(ggplot2)

data(father.son)
x <- father.son$sheight
n <- length(x)
B <- 10000 #number of botstrap resampling
resamples <- matrix(sample(x, n*B, replace = TRUE), B,n) #B times n resamplings, in Bxn Matrix
medians <- apply(resamples, 1, median)

sd(medians)
# [1] 0.08462557

#confidence interval for the medians
quantile(medians, c(0.025,0.975))
#     2.5%    97.5%
# 68.43713 68.81509

#Histogram of bootsrap resamples
g <- ggplot(data.frame(medians = medians), aes(x = medians))
g <- g + geom_histogram(color = "black",
                        fill = "lightblue",
                        binwidth = 0.05)
print(g)
