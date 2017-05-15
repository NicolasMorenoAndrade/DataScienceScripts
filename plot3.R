library(dplyr)
library(ggplot2)

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#summarize data
NEI %>% 
  filter(fips == 24510) %>%
  group_by(year, type) %>%
  summarize(emissionsPerYear = sum(Emissions, na.rm = TRUE)) -> baltimoreData

#create plot and save as png

ggplot(data = baltimoreData, aes(x=year, y=emissionsPerYear, color=type)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(name = "Year", breaks = c(1999,2002,2005,2008)) +
  scale_y_continuous(name = "Total PM2.5 emissions (tons)") +
  ggtitle("PM2.5 Emissions in Baltimore City") +
  scale_color_discrete(name="Source Type") +
  ggsave("plot3.png", width=4.8, height=4.8, dpi=100)
