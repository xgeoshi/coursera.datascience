require("data.table") ## - greately increase read time.

unzipped.file <- "household_power_consumption.txt"
dt.power <- fread(uzipped.file, na.strings = c("NA", "?"))
dt.power.sub <- dt.power[Date %in% c("1/2/2007", "2/2/2007")]
dt.power.sub[, datetime := strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S")][]

with(dt.power.sub, plot(datetime, Global_active_power, t = "l",
                        ylab = "Global Active Power (kilowatts)", xlab = NA))
dev.copy(png, file = "plot2.png", height = 480, width = 480)
dev.off()