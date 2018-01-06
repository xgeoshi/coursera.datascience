# Instruction:
# Across the United States, how have emissions from coal
# combustion-related sources changed from 1999–2008?

# Load libraries
require(data.table)
require(ggplot2)

# File path
nei.filepath <- "summarySCC_PM25.rds"
scc.filepath <- "Source_Classification_Code.rds"

# Read RDS file & convert to data.table
# NEI <- as.data.table(readRDS(nei.filepath))
# SCC <- as.data.table(readRDS(scc.filepath))

# Subset coal's SCC IDs:
coals <- SCC[grep("coal", EI.Sector, ignore.case = T), unique(SCC)]

# Subset sums of year emissions related to coal combustion sources only. 
ttl <- NEI[SCC %in% coals, .SD, by = year]

# plot.new() # Reset graphic parameters
# png("plot4.png", res = 144, width = 800, height = 800) # Turn on PNG capture.

# PLOT
ggplot(ttl, aes(x = as.factor(year), y = log10(Emissions))) +
        geom_boxplot()
        # theme_light() +
        # labs(x = NULL, y = expression("PM"[2.5]*" in Tons"),
        #      title = "US coal combustion-related source emissions") +
        # geom_line() +
        # geom_point(size = 3, col = "grey") +
        # scale_y_continuous(labels = function(x) format(x, big.mark = " "))

# dev.off() # Turn off PNG capture.