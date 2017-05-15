library(dplyr)
library(ggplot2)

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#summarize data
NEI %>% 
  filter(type=="ON-ROAD") %>%
  filter(fips == "24510" | fips=="06037") %>%
  group_by(fips,year) %>%
  summarize(emissionsPerYear = sum(Emissions, na.rm = TRUE)) -> baltLosAngelesMotor

#create plot and save as png

ggplot(data = baltLosAngelesMotor, aes(x=year, y=emissionsPerYear, fill=fips)) +
  geom_bar(stat = "identity") +
  facet_grid(fips~., scales="free") +
  scale_x_continuous(name = "Year", breaks = c(1999,2002,2005,2008)) +
  scale_y_continuous(name = "Total PM2.5 emissions (tons)") +
  ggtitle("PM2.5 Emissions from Motor Vehicles in Baltimore & Los Angeles") +
  scale_fill_discrete(name = "County", 
                      labels=c("Los Angeles", "Baltimore")) +
  ggsave("plot6.png", width=6, height=6, dpi=100)
