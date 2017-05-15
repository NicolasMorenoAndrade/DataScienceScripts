library(dplyr)
library(ggplot2)

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#summarize data
NEI %>% 
  filter(type=="ON-ROAD" & fips == 24510) %>%
  group_by(year) %>%
  summarize(emissionsPerYear = sum(Emissions, na.rm = TRUE)) -> baltMotor

#create plot and save as png

ggplot(data = baltMotor, aes(x=year, y=emissionsPerYear)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(name = "Year", breaks = c(1999,2002,2005,2008)) +
  scale_y_continuous(name = "Total PM2.5 emissions (tons)") +
  ggtitle("PM2.5 Emissions from Motor Vehicles in Baltimore City") +
  ggsave("plot5.png", width=5.5, height=5.5, dpi=100)
