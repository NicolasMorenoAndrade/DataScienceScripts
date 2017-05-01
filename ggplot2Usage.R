library(ggplot2)


# qplot() -----------------------------------------------------------------

# The ggplot2 package has 2 workhorse functions. The
  # more basic workhorse function is qplot, (think
  #                                            quick plot), which works like the plot function in
  # the base graphics system. It can produce many
  # types of plots (scatter, histograms, box and
  #                   whisker) while hiding tedious details from the
  # user. Similar to lattice functions, it looks for
  # data in a data frame or parent environment.

# to see if there's a correlation between engine displacement (displ) 
# and highway miles per gallon (hwy)
qplot(displ, hwy, data = mpg)

# use different colors to distinguish between the 3
# factors (subsets) of different types of drive
# (drv) in the data (front-wheel, rear-wheel, and 4-wheel).
qplot(displ, hwy, data = mpg, color=drv)

qplot(displ, hwy, data = mpg, color=drv, geom=c("point","smooth"))

#boxplots 
qplot(drv , hwy, data = mpg, geom="boxplot", 
      color=manufacturer)

#histograms
#first specify the variable 
#from which you want the frequency count
qplot(hwy, data=mpg,fill=drv)

#facets
# argument facets which will be set equal to the
#   expression . ~ drv which is ggplot2's shorthand
#   for number of rows (to the left of the ~) and
#   number of columns (to the right of the ~). Here
#   the . indicates a single row and drv implies 3,
#   since there are 3 distinct drive factors. Try this
#   now.
qplot(displ,hwy, data=mpg, facets = . ~ drv)

qplot(hwy, data=mpg, facets = drv ~ ., binwidth=2)


# ggplot() ----------------------------------------------------------------

qplot(displ, hwy, data=mpg, geom=c("point","smooth"), facets = .~drv)

#how to do it with ggplot()??
g <- ggplot(mpg, aes(displ,hwy))

g+geom_point()+geom_smooth(method = "lm")

g+geom_point()+geom_smooth(method="lm") + facet_grid(.~drv) 

g+geom_point(size=4,alpha=.5, aes(color=drv))

g+geom_point(size=2,alpha=.5, aes(color=drv)) + geom_smooth(size=4,linetype=3, method="lm", se=FALSE)

g+geom_point(aes(color=drv)) + theme_bw(base_family = "Times")
#b&w background Times font in labels

#faceting
g <- ggplot(mpg, aes(x=displ, y=hwy, color=factor(year)))
g+geom_point()+facet_grid(drv~cyl,margins=TRUE)
g+geom_point()+facet_grid(drv~cyl,margins=TRUE) + geom_smooth(method = "lm",se=FALSE, size=2,color="black")
g+geom_point()+facet_grid(drv~cyl,margins=TRUE) + geom_smooth(method = "lm",se=FALSE, size=2,color="black")+
  labs(x="Displacement",y="Highway Mileage", title="Swirl Rules!")


# ggplot2 Extras ----------------------------------------------------------

#Histogram
qplot(price, data=diamonds)
qplot(price, data=diamonds, binwidth=18497/30, fill=cut)

#same data as density plot
qplot(price,data=diamonds,geom="density")
qplot(price,data=diamonds,geom="density", color=cut)

#scatterplots
qplot(carat,price,data=diamonds)
qplot(carat,price,data=diamonds, color=cut)
qplot(carat,price,data=diamonds, color=cut) + geom_smooth(method = "lm")
qplot(carat,price,data=diamonds, color=cut, facets = .~cut) + geom_smooth(method = "lm")

g <- ggplot(diamonds, aes(depth, price))
summary(g)
g + geom_point(alpha=1/3)

cutpoints <- quantile(diamonds$carat, seq(0,1,length=4), na.rm = TRUE)
diamonds$car2 <- cut(diamonds$carat, cutpoints)
g <- ggplot(diamonds, aes(depth, price))
g + geom_point(alpha=1/3) + facet_grid(cut ~ car2)

g + geom_point(alpha=1/3) + facet_grid(cut ~ car2) + geom_smooth(method = "lm", size=3, color="pink")

# Boxplots
ggplot(diamonds, aes(carat, price)) + geom_boxplot() + facet_grid(.~cut)


