require("data.table") ## - greately increase read time.

unzipped.file <- "household_power_consumption.txt"
dt.power <- fread(uzipped.file, na.strings = c("NA", "?"))
dt.power.sub <- dt.power[Date %in% c("1/2/2007", "2/2/2007")]

hist(dt.power.sub$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", col = "red")
dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()