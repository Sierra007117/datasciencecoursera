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

# Create plot 5
baltimore <- subset(data, fips=="24510")
baltimore_veh <- baltimore[grep('vehicle',baltimore$EI.Sector,ignore.case=TRUE),]
baltimore_sector <- baltimore_veh %>% group_by(EI.Sector,year) %>% summarise(total=sum(Emissions))
baltimore_sector$EI.Sector <- gsub('Mobile - On-Road ', '', baltimore_sector$EI.Sector)
png("plot5.png")
ggplot(baltimore_sector,aes(year,total,col=EI.Sector)) + 
    geom_line() +
    labs(x="Year",y="Total PM2.5 Emissions (tons)",title="Total PM2.5 Emissions in Baltimore City by Vehicle Type") +
    theme(plot.title = element_text(hjust = 0.5))
dev.off()