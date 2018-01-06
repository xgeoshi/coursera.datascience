#Instruction:
# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in
# emissions from 1999–2008 for Baltimore City? Which have seen increases in
# emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.

# Load libraries
require(data.table)
require(ggplot2)

# File path
nei.filepath <- "summarySCC_PM25.rds"

# Read RDS file & convert to data.table
NEI <- as.data.table(readRDS(nei.filepath))

# Total Emissions by year
ttl <- NEI[fips == "24510", .(emissions.total = sum(Emissions)),
           by = .(year, type)]

plot.new() # Reset graphic parameters
png("plot3.png", res = 144, width = 800, height = 800) # Turn on PNG capture.

# PLOT
ggplot(ttl, aes(x = as.character(year), y = emissions.total, group = type,
                col = type)) +
        theme_light() + # plot theme change
        labs(x = NULL, y = "PH2.5 in Tons", # Axis titles, X-Axis is removed
             title = "Baltimore City emissions") + # Plot title
        geom_line(aes(size = type)) + # Allow line thickness manual adjust
        scale_size_manual(values = c(0.5, 0.5, 0.5, 1.5)) + # Line thick values
        geom_point(lwd = 2) # Points and it's thickness.

dev.off() # Turn off PNG capture.