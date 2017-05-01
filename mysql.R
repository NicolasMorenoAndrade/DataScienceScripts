library(RMySQL)


# Connect -----------------------------------------------------------------


#connect to UCSC genome mysql database
ucscDb <- dbConnect(MySQL(), user = "genome", host = "genome-mysql.soe.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;")
dbDisconnect(ucscDb)

#hg 19 is the 19th build of the human genome. In this case we just connect to one database
hg19 <- dbConnect(MySQL(), user = "genome", db = "hg19", host = "genome-mysql.soe.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
#11048 (!!!)
allTables[1:5]


# Query -------------------------------------------------------------------

#get simensions and fields o a specific table

dbListFields(hg19, "affyU133Plus2")
# [1] "bin"         "matches"     "misMatches"  "repMatches"  "nCount"      "qNumInsert"  "qBaseInsert" "tNumInsert" 
# [9] "tBaseInsert" "strand"      "qName"       "qSize"       "qStart"      "qEnd"        "tName"       "tSize"      
# [17] "tStart"      "tEnd"        "blockCount"  "blockSizes"  "qStarts"     "tStarts"    

# how many rows the table has?
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# select a specific subset
query <- dbSendQuery(hg19,"select * from affyU133Plus2 where misMatches between 1 and 3")
# get the selected subset into an R df
affyMis <- fetch(query)
quantile(affyMis$misMatches)

#to make sure everything is OK we can fetch just a few records
affyMisSmall <- fetch(query, n = 10)
#CLEAR the query from remote server
dbClearResult(query)

dim(affyMisSmall)
# Read --------------------------------------------------------------------

#Read from table

affyData <- dbReadTable(hg19,"affyU133Plus2")
head(affyData)


# Close the connection ----------------------------------------------------

#REMEMBER to CLOSE THE CONNECTION
dbDisconnect(hg19)

#as soon as you don't need the connection you shuld close it 
