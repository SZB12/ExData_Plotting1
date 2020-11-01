# Download and read data
if(!file.exists("./UCIdata")){
  dir.create("./UCIdata")
}
webURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(webURL,temp)
unzip(zipfile = temp, exdir = "./UCIdata")
powerData <- read.table("./UCIdata/household_power_consumption.txt",header = 
                          TRUE, sep=";")
unlink(temp)

# Change date to class POSIXlt
dateCol <- powerData$Date
dateCon <- strptime(dateCol,"%d/%m/%Y") 

# Create new year, month and day columns
powerData$Year <- dateCon$year+1900
powerData$Month <- dateCon$mon + 1
powerData$Day <- dateCon$mday

# Find the rows for dates 2007-02-01 and 2007-02-02 and convert a column to 
# numerical format
powerDataSeg <- powerData[powerData$Year==2007 & powerData$Month==02 & (
  powerData$Day==01 |powerData$Day==02),]
powerDataSeg$Global_active_power <- as.numeric(powerDataSeg$Global_active_power)

# Plot graph and save to png file
png(filename="plot1.png", width = 480, height = 480)
hist(powerDataSeg$Global_active_power, col="red",main ="Global_Active_Power",
     xlab="Global Active Power (kW)")
dev.off()