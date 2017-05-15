library(dplyr)

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#summarize data
by_year <- group_by(NEI, year)
year_sum <- summarize(by_year,
                      count = n(),
                      percnas = mean(is.na(Emissions)),
                      emissionsPerYear = sum(Emissions, na.rm = TRUE))
#vectors to be plotted
epy <- year_sum$emissionsPerYear
years <- year_sum$year

#save plot as png
png("plot1.png",width=480,height=480,units="px")

#plot with base plot system
plot(years, epy, pch=19,
     type = "o",
     ylab="Total PM2.5 Emissions",
     xlab="Year",
     col = "green", 
     lty = 6)

dev.off()