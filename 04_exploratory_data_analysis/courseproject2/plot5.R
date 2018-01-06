 # Instruction:
# How have emissions from motor vehicle sources changed from
# 1999–2008 in Baltimore City?

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
ttl <- NEI[SCC %in% vehicle & fips == "24510",
           .(emissions.total = sum(Emissions)), by = year]

# PLOT
plot.new() # Reset graphic parameters
png("plot5.png", res = 144, width = 800, height = 800) # Turn on PNG capture.

ggplot(ttl, aes(x = as.character(year), y = emissions.total, group = 1)) +
        theme_light() +
        labs(x = NULL, y = expression("PM"[2.5]*" in Tons"),
             title = "US, Baltimore City motor vehicle emissions") +
        geom_line() +
        geom_point(size = 3, col = "grey") +
        geom_label(label = round(ttl$emissions.total))

dev.off() # Turn off PNG capture.
