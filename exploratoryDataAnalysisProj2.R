library(dplyr)

# Global Environment Setup ------------------------------------------------

rm(list=ls())
#Download data
setwd("~/Desktop/DataScience/Scripts/data")

if(!file.exists("pm25EmmissionData.zip")){
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL, destfile = "pm25EmmissionData.zip", method = "curl")
system("unzip pm25EmmissionData.zip")
}

#read data

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

setwd("~/Desktop/DataScience/Scripts")


# Questions ---------------------------------------------------------------

# You must address the following questions and tasks in your exploratory analysis. 
# For each question/task you will need to make a single plot. Unless specified, 
# you can use any plotting system in R to make your plot.
# 
# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.
# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot 
# answering this question.
# 3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
# variable, which of these four sources have seen decreases in emissions from 1999–2008 
# for Baltimore City? Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.
# 4. Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999–2008?
# 5. How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?
# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?


# Exploratory Analisys ----------------------------------------------------

dim(NEI)
# [1] 6497651       6

head(NEI)
#     fips      SCC Pollutant Emissions  type year
# 4  09001 10100401  PM25-PRI    15.714 POINT 1999
# 8  09001 10100404  PM25-PRI   234.178 POINT 1999
# 12 09001 10100501  PM25-PRI     0.128 POINT 1999
# 16 09001 10200401  PM25-PRI     2.036 POINT 1999
# 20 09001 10200504  PM25-PRI     0.388 POINT 1999
# 24 09001 10200602  PM25-PRI     1.490 POINT 1999

#what percentage 0f na's?

by_year <- group_by(NEI, year)
year_sum <- summarize(by_year,
                      count = n(),
                      percnas = mean(is.na(Emissions)),
                      emissionsPerYear = sum(Emissions, na.rm = TRUE))
year_sum

# # A tibble: 4 × 4
#     year   count percnas emissionsPerYear
#     <int>   <int>   <dbl>            <dbl>
# 1  1999 1108469       0          7332967
# 2  2002 1698677       0          5635780
# 3  2005 1713850       0          5454703
# 4  2008 1976655       0          3464206

epy <- year_sum$emissionsPerYear
years <- year_sum$year





