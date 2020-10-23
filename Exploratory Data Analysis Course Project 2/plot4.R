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

# Create plot 4
coal <- grepl("Coal",data$Short.Name)
combustion <- grepl("Comb",data$Short.Name)
coal_comb <- data[coal & combustion,]
total_by_year <- with(coal_comb, tapply(Emissions, year,sum))
dates <- unique(coal_comb$year)
png("plot4.png")
plot(dates, total_by_year, col='forestgreen', type='l',xlab="Year",ylab="Total PM2.5 Emissions (tons)",main="Total PM2.5 Emissions from Coal Combustion in United States")
dev.off()
