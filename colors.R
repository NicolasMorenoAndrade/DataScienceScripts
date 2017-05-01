library(grDevices)


# colorRamp ---------------------------------------------------------------


#colors() lists the names  of 657 predefined colors
sample(colors(),10)

#colorRamp, takes a palette of colors (the arguments) and returns a function that takes values
# between 0 and 1 as arguments

pal <- colorRamp(c("red","blue"))
# We don't see any output, but R has created the function pal which we can call with a single argument between 0
# and 1. Call pal now with the argument 0.

pal(0)
#         R    G    B
#      [,1] [,2] [,3]
# [1,]  255    0    0

pal(1)
#      [,1] [,2] [,3]
# [1,]    0    0  255

pal(0.5)
#       [,1] [,2]  [,3]
# [1,] 127.5    0 127.5

pal(seq(0,1,len=6))
#      [,1] [,2] [,3]
# [1,]  255    0    0
# [2,]  204    0   51
# [3,]  153    0  102
# [4,]  102    0  153
# [5,]   51    0  204
# [6,]    0    0  255


# colorRampPalette --------------------------------------------------------

p1 <- colorRampPalette(c("red","blue"))

p1(2)
# [1] "#FF0000" "#0000FF"

p1(6)
# [1] "#FF0000" "#CC0033" "#990066" "#650099" "#3200CC" "#0000FF"

p2 <- colorRampPalette(c("red","yellow"))

# 10-long vector. For each element, the red component is fixed at FF, and the green component
#  grows from 00 (at the first element) to FF (at the last).
p2(2)
# [1] "#FF0000" "#FF1C00" "#FF3800" "#FF5500" "#FF7100" "#FF8D00" "#FFAA00" "#FFC600" "#FFE200" "#FFFF00"

showMe <- function(cv){
  myarg <- deparse(substitute(cv))
  z<- outer( 1:20,1:20, "+")
  obj<- list( x=1:20,y=1:20,z=z )
  image(obj, col=cv, main=myarg  )
}

showMe(p1(20))
showMe(p2(20))

p3 <- colorRampPalette(c("blue","green"), alpha=.5)
p3(5)


# RColorBrewer ------------------------------------------------------------
cols <- brewer.pal(3, "BuGn")
showMe(cols)
pal <- colorRampPalette(cols)
# The call showMe(pal(3)) would be identical to the showMe(cols) call. So use showMe to look at pal(20).
showMe(pal(20))
library(datasets)
image(volcano, col = pal(20))
image(volcano, col = p1(20))

