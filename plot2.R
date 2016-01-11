# part 0 packages (if needed) ---------------------------------------------------------
# library(lubridate) maybe if we need to work with hours and minutes independent of days

# part 1 create data directory --------------------------------------------
## create a directory called "data" if it does not exist already
if (!file.exists("data")) {
     dir.create("data")
}

## set the directory "data" as the working directory
setwd("./data")

# part 2 grab the data from Univ of California Irvine ---------------------
## download the data set "Electric power consumption"
## details on the data set are here: https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile() 
download.file(zipUrl,temp)
dataDownloaded <- date()
unzip(temp)
unlink(temp)

## list resulting files in the data directory
list.files()
list.dirs()
list.files(all.files = TRUE, recursive = TRUE)

# part 3 import the data --------------------------------------------------
## path to the downloaded data set
path_raw <- "./household_power_consumption.txt"

## read in just a few lines to get a feel and check classes
raw_check <- read.table(path_raw, sep = ";", na.strings = "?", nrows = 5, 
                        header = TRUE, stringsAsFactors = FALSE)

head(raw_check)
str(raw_check)
classes <- sapply(raw_check, class)
classes

## read in the full data set
raw <- read.table(path_raw, sep = ";", na.strings = "?", header = TRUE, 
                  stringsAsFactors = FALSE)

# part 4 organize the data ------------------------------------------------
## convert dates and datetime to proper dates and datetime
x <- paste(raw$Date, raw$Time)
raw$datetime <- strptime(x, "%d/%m/%Y %H:%M:%S")
raw$Date <- as.Date(raw$Date, "%d/%m/%Y")

## change column order around to be more intuitive
raw <- raw[ , c(1:2, 10:11, 3:9)] 

## check the structure of raw
str(raw)

## filter to only the dates needed for the project
startdt <- as.Date("2007-02-01") 
enddt <- as.Date("2007-02-02")      
raw2 <- subset(raw, raw$Date == startdt | raw$Date == enddt)

## export if you want for checking
# write.csv(raw2, file ="zcheck_raw2.csv",row.names=FALSE)

# part 5 - plot 2 ----------------------------------------------------------
png(filename = "plot2.png", width = 480, height = 480)

with(raw2, plot(datetime, Global_active_power, type = 'l', xlab = "",
                ylab = "Global Active Power (kilowatts)"))

dev.off()
