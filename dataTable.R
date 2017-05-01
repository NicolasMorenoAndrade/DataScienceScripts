library(data.table)
#data frame
DF = data.frame(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF,3)

#vs data table
DT = data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DT,3)
class(DT)

#summary o tables in environment  
tables()

# NAME NROW NCOL MB COLS  KEY
# [1,] DT      9    3  1 x,y,z    
# Total: 1MB

#subsetting a data table
# by row
DT[2,]
DT[DT$y=="a",]
#Subsetting with only 1 index defaults to rows 
DT[c(2,3)]

#by column
DT[,c(2,3)]

#data table can handle R expressions within {}
{
  x = 1
  y = 2
}
k = {print(10); 5}
print(k)

#applying functions to variables by variable name when subsetting
DT[,list(mean(x),sum(z))]

#add new columns with :=
DT[,w:=z^2]

#weird bahavior
DT2 <- DT
DT[, y:= 2]

#DT2 also changed!
head(DT,n=3)
head(DT2,n=3)

## Multiple operations within the expression
DT[,m:= {tmp <- (x+z); log2(tmp+5)}]
DT
## plyr like operations
DT[,a:=x>0]
DT
DT[,b:= mean(x+w),by = a]

## Special Variables: .N
set.seed(123);
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT[, .N, by=x]
# x     N
# 1: a 33387
# 2: c 33201
# 3: b 33412

#Compare to 
table(DT$x)
# a     b     c 
# 33387 33412 33201 

## Keys
DT <- data.table(x=rep(c("a","b","c"),each=100), y=rnorm(300))
setkey(DT, x)
DT['a']

##Joins
DT1 <- data.table(x=c('a', 'a', 'b', 'dt1'), y=1:4)
DT2 <- data.table(x=c('a', 'b', 'dt2'), z=5:7)
setkey(DT1, x); setkey(DT2, x)
merge(DT1, DT2)
#MUCH faster merge

## Fast reading
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)
system.time(fread(file))
#compare
system.time(read.table(file, header=TRUE, sep="\t"))s
