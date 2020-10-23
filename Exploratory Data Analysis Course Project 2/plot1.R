# Load file into directory
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile = "./exdata_data_NEI_data.zip", method = "curl")
    
zipF<- "./exdata_data_NEI_data.zip"
unzip(zipF)
file.remove(zipF)

# Read in the rds file
data <- readRDS("./summarySCC_PM25.rds")

# Create plot 1
total_by_year <- with(data, tapply(Emissions, year,sum))
dates <- unique(data$year)
png("plot1.png")
plot(dates,total_by_year/100, type='l', col='red',xlab="Year",ylab="Total PM2.5 Emissions (hundred tons)", main="Total PM2.5 Emissions in United States")
dev.off()
