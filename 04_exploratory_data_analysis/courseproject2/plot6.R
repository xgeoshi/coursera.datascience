# Instruction:
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips == 06037).
# Which city has seen greater changes over time in motor vehicle emissions?

# Load libraries
require(data.table)
require(ggplot2)

# File path
nei.filepath <- "summarySCC_PM25.rds"
scc.filepath <- "Source_Classification_Code.rds"

# Read RDS file & convert to data.table
NEI <- as.data.table(readRDS(nei.filepath))
SCC <- as.data.table(readRDS(scc.filepath))

# Subset motor vehicle's SCC:
vehicle <- SCC[grep("vehicle", EI.Sector, ignore.case = T), unique(SCC)]

# Subset motor vehicle's SCC and Baltimore city fips data only.
ttl <- NEI[SCC %in% vehicle & fips %in% c("24510", "06037"),
           .(emissions.total = sum(Emissions)),
           by = .(fips = as.factor(fips), year)]

# PLOT
plot.new() # Reset graphic parameters
png("plot6.png", res = 144, width = 800, height = 800) # Turn on PNG capture.

ggplot(ttl, aes(x = as.character(year), y = emissions.total, group = fips)) +
        facet_grid(fips ~ ., scales = "free",
                   labeller = as_labeller(c("24510" = "Baltimore City",
                                            "06037" = "Los Angeles County"))) +
        theme_light() +
        labs(x = NULL, y = expression("PM"[2.5]*" in Tons"),
             title = "Motor vehicle emissions",
             subtitle = "Baltimore City vs. Los Angeles County") +
        geom_line(lwd = 1, show.legend = FALSE, col = "grey60") +
        geom_point(lwd = 3, col = "black")

dev.off() # Turn off PNG capture.