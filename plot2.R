# Download and read data
if(!file.exists("./UCIdata")){
  dir.create("./UCIdata")
}
webURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
download.file(webURL,temp)
unzip(zipfile = temp, exdir = "./UCIdata")
powerData <- read.table("./UCIdata/household_power_consumption.txt",header = TRUE, sep=";")
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

# Change date to class POSIXlt
timeCol <- powerDataSeg$Time
timeCon <- strptime(timeCol,"%H:%M:%S") 

# Create new hour, min and sec columns
powerDataSeg$Hour <- timeCon$hour
powerDataSeg$Min <- timeCon$min
powerDataSeg$Sec <- timeCon$sec

# Create new column for total seconds, x axis
powerDataSeg$Time_Sec <- powerDataSeg$Hour*3600 + powerDataSeg$Min*60 + 
  powerDataSeg$Sec + powerDataSeg$Day*24*3600

# Create bounds for x axis total seconds
maxTime <- max(powerDataSeg$Time_Sec)
minTime <- min(powerDataSeg$Time_Sec)
avgTime <- (maxTime+minTime)/2

# Plot graph and save to png file
png(filename="plot2.png", width = 480, height = 480)
plot(powerDataSeg$Time_Sec,powerDataSeg$Global_active_power,type="n", axes = 
       FALSE, xlab="Day",ylab="Global_Active_Power (kW)")
lines(powerDataSeg$Time_Sec,powerDataSeg$Global_active_power)
axis(1, c(minTime,avgTime,maxTime), c("Thurs", "Fri", "Sat"))
axis(2, c(0,2,4,6), c(0,2,4,6))
box()
dev.off()