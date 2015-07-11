
#This will work as long as you have extracted the txt file from the zip file, 
#and have that txt file in your working directory

#Read in a data frame containing only the lines corresponding to the two days we want.
df2 <- read.table("./household_power_consumption.txt", skip=grep("1/2/2007", 
                                                                 readLines("./household_power_consumption.txt")),nrows=2878, sep=";", na.strings = "?", comment.char = "", 
                  header=TRUE, colClasses= "character")

##Data cleanup
#Give each column the right name
names(df2) <- c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity",            
                "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

#Above, set colClasses="character" so it would read in faster. So now we have to give each variable the proper type.
#We will also add a new column, "datetime," combining Date and Time. This will make working with the time easier.

library(dplyr)
df2 = mutate(df2, Global_active_power = 
               as.numeric(Global_active_power), Global_reactive_power = as.numeric(Global_reactive_power),
             Voltage = as.numeric(Voltage), Global_intensity = as.numeric(Global_intensity), Sub_metering_1 = 
               as.numeric(Sub_metering_1), Sub_metering_2 = as.numeric(Sub_metering_2), Sub_metering_3 = 
               as.numeric(Sub_metering_3))

df2 = mutate(df2, datetime = as.POSIXct(strptime(paste(df2$Date, df2$Time, sep = " "),"%d/%m/%Y %H:%M:%S")))

#Make a plot and save it as plot3.png
png(file = "plot3.png")
with(df2, plot(df2$datetime, df2$Sub_metering_1, xlab = "", ylab= "Energy sub metering", type="l")
     )
#Add the other two sub metering sets and a legend to that plot
lines(df2$datetime, df2$Sub_metering_2, col="red")
lines(df2$datetime, df2$Sub_metering_3, col="blue")
legend("topright", lty=c(1,1,1), col=c("black", "blue", "red"), 
       legend = c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
      ) 
#Close the graphics device
dev.off()