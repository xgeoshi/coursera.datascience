 require("data.table") || install.packages("data.table")
 require("RColorBrewer") || install.packages("RColorBrewer")

 ## File read (reads from your current working directory)
        pay <- fread("_e143dff6e844c7af8da2a4e71d7c054d_payments.csv",
                     na.strings = c("NA", "?"))

 ## Plot 1
        par(new = TRUE)
        pdf("Rplot1.pdf")
        ny.pay <- pay[Provider.State=="NY"]
        layout(matrix(c(1, 1, 1, 1, 2, 3, 4, 5), 4, 2, byrow = TRUE))
        with(ny.pay, plot(Average.Covered.Charges, Average.Total.Payments,
                          pch  = 19,
                          col  = rgb(0, 0, 0, 0.15),
                          log  = "xy",
                          main = "Total payments vs. Covered Charges in NY",
                          xlab = "log(Average Covered Charges)",
                          ylab = "log(Average Total Payments)"
                          )
             )

        text(83000, 32000, "*linear regression", col = "red")

        ny.pay.lm <- with(ny.pay,
                          lm(Average.Total.Payments ~ Average.Covered.Charges)
                          )
        abline(ny.pay.lm, col = "red", untf = TRUE)
        plot(ny.pay.lm, pch = 19, col = rgb(0,0,0,0.15))
        dev.off()

 ## Plot 2
        pdf("Rplot2.pdf")
        xlmt <- c(min(pretty(min(pay$Average.Covered.Charges))),
                  max(pretty(max(pay$Average.Covered.Charges))))
        ylmt <- c(min(pretty(min(pay$Average.Total.Payments))),
                  max(pretty(max(pay$Average.Total.Payments))))
        
        stt.fctr <- factor(pay$Provider.State)
        stt.levels <- levels(stt.fctr)
        
        drg.fctr <- factor(pay$DRG.Definition)
        ncolors.drg <- nlevels(drg.fctr)
        col.drg.palette <- RColorBrewer::brewer.pal(ncolors.drg, "RdYlBu")
        transparency.hex <- toupper(sprintf("%x", ceiling(255 * .6)))
        col.drg.palette.transp <- paste0(col.drg.palette, transparency.hex)
        
        par(new = TRUE)
        par(oma = c(7, 2, 2, 0)) #marin between plots in multiview
        par(mai = c(.21, .21, .21, .21)) # ~50% smaler edge margins
        par(mgp = c(1.6, .4, 0)) #50% smaler axis label & scale margins
        par(mfrow = c(2, 3))
        
        for (stt in stt.levels) {
                data <- pay[Provider.State == stt]
                col.drg <- col.drg.palette.transp[factor(data$DRG.Definition)]
                with(data,
                     plot(Average.Covered.Charges, Average.Total.Payments,
                          col.lab = "dimgrey",
                          xlim = xlmt,
                          ylim = ylmt,
                          pch = 19,
                          ann = FALSE,
                          log  = "xy",
                          col = col.drg
                          )
                     )
                                
                text(x = xlmt[1] * 1.3, y = ylmt[2] * 0.95, labels = stt,
                     col = "dimgrey", cex = 2)
                
                for (l in seq(ncolors.drg)) {
                        data <- pay[drg.fctr == levels(drg.fctr)[l] &
                                            Provider.State == stt]
                        abline(with(data, lm(Average.Total.Payments ~
                                                     Average.Covered.Charges)),
                               untf = TRUE,
                               col = col.drg.palette[l],
                               lwd = 2)
                }
        }
        
        par(fig = c(0, 1, 0, 1),
            oma = c(5, 0, 0.3, 0),
            mar = c(3, 3, 3, 0),
            new = TRUE)
        
        frame()
        
        title(main = "mean covered charges VS mean total payments: by medical condition and the state",
              xlab = "log( Average Covered Charges )",
              ylab = "log( Average Total Payments )", cex = 1.5)
        
        par(fig = c(0, 1, 0, 1),
            oma = c(0, 0, 0, 0),
            mar = c(0, 0, 0, 0),
            new = TRUE)
        
        frame()
        
        legend("bottom", legend = levels(drg.fctr), xpd = TRUE, #horiz = TRUE,
               pch = 19, col = col.drg.palette, ncol = 2, cex = 0.6, bty = "n")
        dev.off()
        