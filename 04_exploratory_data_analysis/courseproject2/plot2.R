# Instruction:
# Of the four types of sources indicated by the 𝚝𝚢𝚙𝚎 (point, nonpo
# int, onroad, nonroad) variable, which of these four sources have seen
# decreases in emissions from 1999–2008 for Baltimore City?
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.

# Load libraries
require(data.table)

# File path
nei.filepath <- "summarySCC_PM25.rds"

# Read RDS file & convert to data.table
NEI <- as.data.table(readRDS(nei.filepath))

# Total Emissions by year
ttl <- NEI[fips == "24510", .(emissions.total = sum(Emissions)), by = year]

plot.new() # Reset graphic parameters
png("plot2.png", res = 144, width = 800, height = 800) # Turn on PNG capture.
par(mai = c(0.52, 0.99, 0.62, 0.22)) # Graphic parameters

col.coef <- round(48 * (1 - ttl$emissions.total / max(ttl$emissions.total)) + 1)
barcolors <- grey.colors(32)[col.coef] # 4 colors for bars

# Barplot
with(ttl, barplot(emissions.total, names.arg = year, axes = FALSE,
                  col = barcolors, cex.lab = .8)) # Barplot
mtext(side = 2, text = "PM2.5 emission in Tons", line = 4, cex = .85) # Y-text
title(main = "Baltimore City, Maryland: PM2.5 emission", cex.main = 1.4)
ylabels <- pretty(c(0, max(ttl$emissions.total))) # Y-Axis label names
yticks  <- pretty(c(0, max(ttl$emissions.total))) # Y-Axis tick marks
axis(2, las = 2, labels = ylabels, at = yticks, lwd = 2, cex.axis = 1) # Y-scale

dev.off() # Turn off PNG capture.