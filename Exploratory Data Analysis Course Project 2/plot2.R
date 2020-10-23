# Load file into directory
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileURL,destfile = "./exdata_data_NEI_data.zip", method = "curl")

zipF<- "./exdata_data_NEI_data.zip"
unzip(zipF)
file.remove(zipF)

# Read in the rds file
data <- readRDS("./summarySCC_PM25.rds")

# Create plot 2
baltimore <- subset(data, fips=="24510")
total_by_year <- with(baltimore, tapply(Emissions, year,sum))
dates <- unique(baltimore$year)
png("plot2.png")
plot(dates,total_by_year, type='l', col='blue',xlab="Year",ylab="Total PM2.5 Emissions (tons)", main="Total PM2.5 Emissions in Baltimore City")
dev.off()