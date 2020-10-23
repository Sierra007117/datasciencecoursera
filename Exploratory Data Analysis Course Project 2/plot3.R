# Load libraries
library(ggplot2)
library(dplyr)

# Load file into directory
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile = "./exdata_data_NEI_data.zip", method = "curl")

zipF<- "./exdata_data_NEI_data.zip"
unzip(zipF)
file.remove(zipF)

# Read in the rds file
data <- readRDS("./summarySCC_PM25.rds")

# Create plot 3
baltimore <- subset(data, fips=="24510")
by_type_year <- baltimore %>% group_by(type,year) %>% summarise(total=sum(Emissions))
png("plot3.png")
ggplot(by_type_year,aes(year, total, col=type)) +
    geom_line() +
    labs(x="Year",y="Total PM2.5 Emissions (tons)",title="Total PM2.5 Emissions in Baltimore City by Type") +
    theme(plot.title = element_text(hjust = 0.5))
dev.off()
