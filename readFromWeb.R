
# Getting data off webpages - readLines() ---------------------------------

con <- url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlcode <- readLines(con)   
close(con)
htmlcode


# Parsing with XML --------------------------------------------------------

library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes = TRUE)

xpathSApply(html, "//title", xmlValue)
#[1] "Jeff Leek - Google Scholar Citations"

xpathSApply(html, "//td[@id='col-citedby']", xmlValue)
#NOT WORKING ???

# Using httr --------------------------------------------------------------

library(httr)
html2 = GET(url)
content2 = content(html2, as="text")
parsedHTML = htmlParse(content2, asText = TRUE)
xpathSApply(html, "//title", xmlValue)


# Accesing websites with passwords ----------------------------------------

pg1 <- GET("http://httpbin.org/basic-auth/user/passwd")
pg1
# Response [http://httpbin.org/basic-auth/user/passwd]
# Date: 2017-04-03 03:13
# Status: 401
# Content-Type: <unknown>
#   <EMPTY BODY>

#So we need to authenticate:
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd",
           authenticate("user","passwd"))
pg2

# Response [http://httpbin.org/basic-auth/user/passwd]
# Date: 2017-04-03 03:15
# Status: 200
# Content-Type: application/json
# Size: 47 B
# {
#   "authenticated": true, 
#   "user": "user"
# }

names(pg2)
