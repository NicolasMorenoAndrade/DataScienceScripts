library(dplyr)
library(ggplot2)

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#find SCC for coal combustion related emissions
SCC %>%
  filter(grepl("Combustion", SCC.Level.One)) %>%
  filter(grepl("coal", ignore.case=TRUE, Short.Name)) -> coalComb

#summarize data
NEI %>% 
  filter(SCC %in% coalComb$SCC) %>%
  group_by(year) %>%
  summarize(emissionsPerYear = sum(Emissions, na.rm = TRUE)) -> coalSources

#create plot and save as png

ggplot(data = coalSources, aes(x=year, y=emissionsPerYear)) +
  geom_bar(stat = "identity") +
  scale_x_continuous(name = "Year", breaks = c(1999,2002,2005,2008)) +
  scale_y_continuous(name = "Total PM2.5 emissions (tons)") +
  ggtitle("PM2.5 Emissions from Coal Sources") +
  ggsave("plot4.png", width=4.8, height=4.8, dpi=100)
