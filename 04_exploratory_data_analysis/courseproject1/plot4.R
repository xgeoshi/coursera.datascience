require("data.table") ## - greately increase read time.

unzipped.file <- "household_power_consumption.txt"
dt.power <- fread(uzipped.file, na.strings = c("NA", "?"))
dt.power.sub <- dt.power[Date %in% c("1/2/2007", "2/2/2007")]
dt.power.sub[, datetime := strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S")][]

par(mfcol = c(2,2))
with(dt.power.sub, plot(datetime, Global_active_power, t = "l",
                        ylab = "Global Active Power (kilowatts)", xlab = NA))

with(dt.power.sub, plot(datetime, Sub_metering_1,
                        ylab = "Energy sub metering", xlab = NA, type = "n"))

with(dt.power.sub, lines(datetime, Sub_metering_1, col = "black"))
with(dt.power.sub, lines(datetime, Sub_metering_2, col = "red"))
with(dt.power.sub, lines(datetime, Sub_metering_3, col = "blue"))

legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1,1,1), col = c("black", "red", "blue"), bty = "n")

with(dt.power.sub, plot(datetime, Voltage, t = "l"))
with(dt.power.sub, plot(datetime, Global_reactive_power, t = "l"))

dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()