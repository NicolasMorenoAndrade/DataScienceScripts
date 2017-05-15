library(dplyr)

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#summarize data
NEI %>% 
  filter(fips == 24510) %>%
  group_by(year) %>%
  summarize(emissionsPerYear = sum(Emissions, na.rm = TRUE)) -> baltimoreData

#plot
#save plot as png
png("plot2.png",width=480,height=480,units="px")

#plot with base plot system
plot(baltimoreData$year, baltimoreData$emissionsPerYear, 
     main="Total PM2.5 emissions in Baltimore City",
     pch=19,
     type = "o",
     ylab="Total PM2.5 Emissions",
     xlab="Year",
     col = "green", 
     lty = 6)

dev.off()