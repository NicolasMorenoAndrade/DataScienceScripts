library(lattice)
library(datasets)


# Scatterplots ------------------------------------------------------------

##simple scatterplot
print(xyplot(Ozone ~ Wind, data = airquality))

airquality <- transform(airquality, Month=factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality,
       layout=c(5,1))

## Basic modifiers 
xyplot(Ozone ~ Wind , data = airquality,pch=8,col="red",main="Big Apple Data")

# Panel functions in lattice ----------------------------------------------

set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each=50)
y <- x + f - f * x +rnorm(100, sd=0.5)
f <- factor(f, labels=c("Group 1", "Group 2"))
xyplot(y~x | f, layout=c(2,1))

## Custom panel functions
xyplot(y~x | f, panel=function(x,y,...){
  panel.xyplot(x,y,...) ##First call default panel for xyplot
  panel.abline(h=median(y),lty = 2) ## add a horizontal line at median
})

xyplot(y~x | f, panel=function(x,y,...){
  panel.xyplot(x,y,...) ##First call default panel for xyplot
  panel.lmline(x,y,col=2) ## Ovaerlay a regression line
})

# Many panel lattice plot -------------------------------------------------

library(ggplot2) ## to access diamonds data frame
table(diamonds$color, diamonds$cut)

#labels 
myxlab <- "Carat"
myylab <- "Price"
mymain <- "Diamonds are Sparkly!"

#multi panel plot. the strip arg controls the labelimg of panels set to TRUE tpo see difference
xyplot(price ~ carat | color*cut,data=diamonds, pch=20, strip=FALSE, xlab=myxlab, ylab=myylab, main=mymain) 

