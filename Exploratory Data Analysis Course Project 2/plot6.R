# Load libraries
library(ggplot2)
library(dplyr)

# Load file into directory
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile = "./exdata_data_NEI_data.zip", method = "curl")

zipF<- "./exdata_data_NEI_data.zip"
unzip(zipF)
file.remove(zipF)

# Read in the rds files and merge them
NEI <- readRDS("./summarySCC_PM25.rds")
SCC <- readRDS("./Source_Classification_Code.rds")
data <- merge(NEI,SCC,by="SCC")

# Create plot 6
baltimore_la <- subset(data, fips %in% c("24510","06037"))
baltimore_la_veh <- baltimore_la[grep('vehicle',baltimore_la$EI.Sector,ignore.case=TRUE),]
baltimore_la_fips <- baltimore_la_veh %>% group_by(fips,year) %>% summarise(total=sum(Emissions))
baltimore_la_fips$fips <- gsub('24510', 'Baltimore City', baltimore_la_fips$fips)
baltimore_la_fips$fips <- gsub('06037', 'Los Angeles County', baltimore_la_fips$fips)
baltimore_la_fips <- baltimore_la_fips  %>% rename(location = fips)
png("plot6.png")
ggplot(baltimore_la_fips,aes(year,total,col=location)) + 
    geom_line() +
    labs(x="Year",y="Total PM2.5 Emissions (tons)",title="Total PM2.5 Emissions in Baltimore City and Los Angeles County") +
    theme(plot.title = element_text(hjust = 0.5)) 
dev.off()
