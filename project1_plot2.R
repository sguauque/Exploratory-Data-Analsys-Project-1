## Question 1

setwd("D:/Dropbox/UniversidadCooperativa/Formacion_Docente/Coursera/04_ExploratoryDataAnalysis/Week1")

# Loading the data

##if directory "data" does not exist, create it
if(!file.exists("data")){dir.create("data")}

## set the URL from which to download the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" #Measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years. 
# Different electrical quantities and some sub-metering values are available.

#Download the American Community Survey data and load it into an R object called acs
quiz4 <- download.file(fileUrl, destfile = "./data/project1.zip")
# trying URL 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
# Content type 'application/zip' length 20640916 bytes (19.7 MB)
# downloaded 19.7 MB

## Figure out the date of download
dateDownload <- date()
dateDownload
# [1] "Fri Jan 26 14:41:42 2018"

unzip("./data/project1.zip", exdir = "./data")
list.files("./data")
# [1] "household_power_consumption.txt" "project1.zip" 

proj1 <-read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)
nrow(proj1)
# [1] 2075259

ncol(proj1)
# [1] 9

round(2075259*9*8/2^{20},2) # estimate memory necesary to load the data for 2,075,259 rows and 9 columns
# [1] 142.5 MB

proj1 <-read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)

head(proj1)
tail(proj1)

library(sqldf)
proj2 <- read.csv.sql("./data/household_power_consumption.txt","select * from file where Date = '1/2/2007' or Date = '2/2/2007' ",sep=";") # We will only be using data from the dates 2007-02-01 and 2007-02-02.

head(proj2)
tail(proj2)

# You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime and as.Date functions.

#as.POSIXct(paste(proj2$Date, proj2$Time), format="%d-%m-%y %H:%M:%S")
proj2$DateTime <- with(proj2, as.POSIXct(paste(as.Date(Date, format="%d/%m/%Y"), Time, tz="UCT"))) # capital Y to get correct year
proj2$day <- weekdays(as.Date(proj2$DateTime))


## PLOT #2
library(plyr)

proj2$GAP_mean_Temp <- ddply(proj2, .(DateTime), summarize, GAP_mean_Temp = mean(Global_active_power))

proj2Mean <- aggregate(Global_active_power ~ day, proj2, mean)
nrow(proj2Mean)

Sys.setlocale("LC_TIME", "English") #change R from Spanish to english

png(filename = "./data/plot2.png", width = 480, height = 480, units = "px")
with(proj2$GAP_mean_Temp, plot(DateTime, GAP_mean_Temp, type = "l", ylab = "Global Active Power (kilowatts)", xlab = NA))
dev.off()
