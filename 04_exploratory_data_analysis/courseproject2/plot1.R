# Instruction: Have total emissions from PM2.5 decreased in the United States
# from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission
# from all sources for each of the years 1999, 2002, 2005, and 2008.

# Load libraries
require(data.table)

# File path
nei.filepath <- "summarySCC_PM25.rds"

# Read RDS file & convert to data.table
dt.NEI <- as.data.table(readRDS(nei.filepath))

# Total Emissions by year
ttl <- dt.NEI[, .(emissions.total = sum(Emissions)), by = year]

col.coef <- round(48 * (1 - ttl$emissions.total / max(ttl$emissions.total)) + 1)
barcolors <- grey.colors(32)[col.coef] # 4 colors for bars

plot.new() # Reset graphic parameters
png("plot1.png", res = 144, width = 800, height = 800) # Turn on PNG capture.
par(mai = c(0.52, 0.99, 0.62, 0.22)) # Graphic parameters

# Barplot
with(ttl, barplot(emissions.total, names.arg = year, axes = FALSE,
                  col = barcolors, cex.lab = .8)) # Barplot
mtext(side = 2, text = "PM2.5 emission in Tons", line = 4, cex = .85) # Y-text
title(main = "United States total PM2.5 emission", cex.main = 1.4) # Title
ylabels <- c(0, paste(1:7, "Mln")) # Y-Axis label names
yticks  <- seq(0, 7000000, by = 1000000) # Y-Axis tick marks
axis(2, las = 2, labels = ylabels, at = yticks, lwd = 2, cex.axis = 1) # Y-scale

dev.off() # Turn off PNG capture.