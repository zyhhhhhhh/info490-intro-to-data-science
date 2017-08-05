
load("/Users/zyh/Documents/2016Fall/Data science/hw9/weather2011.rda")
makePlotRegion = function(xlim, ylim, bgcolor, ylabels,
               margins, cityName, xtop = TRUE,cumDays,monthNames) {
  # This function is to produce a blank plot that has 
  # the proper axes labels, background color, etc.
  # It is to be used for both the top and bottom plot.
  
  # The parameters are
  # xlim is a two element numeric vector used for the two
  #   end points of the x axis
  # ylim is the same as xlim, but for the y axis
  # ylabels is a numeric vector of labels for "tick marks"
  #   on the y axis
  # We don't need to x labels because they are Month names
  # margins specifies the size of the plot margins (see mar parameter in par)
  # cityName is a character string to use in the title
  # xtop indicates whether the month names are to appear
  # at the top of the plot or the bottom of the plot
  # 
  # See the assignment for a pdf image of the plot that is
  # produced as a result of calling this function.
  par(bg = bgcolor,  mar = margins)
  plot(NULL, xlim = xlim, ylim =ylim, yaxt = "n", xaxt = "n")
  axis(side = 2, at = ylabels, tick = TRUE, lty = 1,  col = "black", col.ticks = "white", las = 1,cex.axis = 0.6)
  axis(side = 4, at = ylabels, tick = TRUE, lty = 1, col = "black", col.ticks = "white", las = 1,cex.axis = 0.6)
  title(cityName)
  if(xtop == TRUE){
    side = 3;
  }
  else{
    side = 1;
  }
  axis(side, at = cumDays[-13] + 14, tick = FALSE, labels = monthNames, cex.axis = 0.4)
  
}


drawTempRegion = function(day, high, low, col){
  # This plot will produce 365 rectangles, one for each day
  # It will be used for the record temps, normal temps, and 
  # observed temps
  
  # day - a numeric vector of 365 dates
  # high - a numeric vector of 365 high temperatures
  # low - a numeric vector of 365 low temperatures
  # col - color to fill the rectangles
  rect(xleft = c(0:364), xright = c(1:365), ybottom = low, ytop = high, col = col,border = TRUE)
  
}

addGrid = function(location, col, ltype, vertical = TRUE) {
  # This function adds a set of parallel grid lines
  # It will be used to place vertical and horizontal lines
  # on both temp and precip plots
  
  # location is a numeric vector of locations for the lines
  # col - the color to make the lines
  # ltype - the type of line to make
  # vertical - indicates whether the lines are vertical or horizontal
  if (vertical == TRUE){
    abline(v = location, col = col, lty = ltype)}
  else{
    abline(h = location, col = col, lty = ltype)}
  
}

monthPrecip = function(day, dailyprecip, normal){
  # This function adds one month's precipitation to the 
  #   precipitation plot.
  # It will be called 12 times, once for each month
  # It creates the cumulative precipitation curve,
  # fills the area below with color, add the total
  # precipitation for the month, and adds a reference
  # line and text for the normal value for the month
  
  # day a numeric vector of dates for the month
  # dailyprecip a numeric vector of precipitation recorded
  # for the month (any NAs can be set to 0)
  # normal a single value, which is the normal total precip
  #  for the month
  points(x = day, y = dailyprecip, col = "blue", type = "l", lwd = 3)
  polygon(x = c(day, max(day), day[1]), y = c(dailyprecip, 0, 0), col = "#ecd3bf", border = NA)
  points(x =c(day[1], max(day)), y = rep(normal,2), type = "l", lwd = 1)
  
}

finalPlot = function(temp, precip, lax = TRUE){
  # The purpose of this function is to create the whole plot
  # Include here all of the set up that you need for
  # calling each of the above functions.
  # temp is the data frame sfoWeather or laxWeather
  # precip is the data frame sfoMonthlyPrecip or laxMonthlyPrecip

  
  # Here are some vectors that you might find handy
  
  monthNames = c("January", "February", "March", "April",
               "May", "June", "July", "August", "September",
               "October", "November", "December")
  daysInMonth = c(31, 28, 31, 30, 31, 30, 31, 
                  31, 30, 31, 30, 31)
  cumDays = cumsum(c(1, daysInMonth))
  
  normPrecip = as.numeric(as.character(precip$normal))
  ### Fill in the various stages with your code
 
  
  ### Add any additional variables that you will need here
  
  
  ### Set up the graphics device to plot to pdf and layout
  ### the two plots on one canvas
  ### pdf("", width = , height = )
  ### layout(  )
  if (lax == TRUE){
    pdf("/Users/zyh/Documents/2016Fall/Data science/hw9/laxpdf1", width = 8, height = 11)
  }
  else{
    pdf("/Users/zyh/Documents/2016Fall/Data science/hw9/sfopdf1", width = 8, height = 11)
  }
  
  layout(matrix(c(1,2), nrow = 2, ncol = 1, byrow = TRUE), height = c(3,1))
  ### Call makePlotRegion to create the plotting region
  ### for the temperature plot
  if (lax == TRUE){
    makePlotRegion(xlim =c(1,365),  ylim =c(-10, 110),bgcolor = "#ecd3bf", ylabels =seq(-30,120, by = 10),  margins =c(2,2,6,2),cityName =  "LAX Weather", TRUE,cumDays,monthNames)
  }
  else{
    makePlotRegion(xlim =c(1,365),  ylim =c(-10, 110),bgcolor = "#ecd3bf", ylabels =seq(-30,120, by = 10),  margins =c(2,2,6,2),cityName =  "SFO Weather", TRUE,cumDays,monthNames)
  }
  
  ### Call drawTempRegion 3 times to add the rectangles for
  ### the record, normal, and observed temps
  drawTempRegion(c(1:365), temp$RecordHigh, temp$RecordLow, col = "#d4c38f")
  drawTempRegion(c(1:365), temp$NormalHigh, temp$NormalLow, col = "#b0b0b0")
  drawTempRegion(c(1:365), temp$High, temp$Low, col = "darkred")
  
  ### Call addGrid to add the grid lines to the plot
  addGrid(cumDays,  col = "black", lty = 3, TRUE)
  addGrid(seq(-20,  120, by = 10), col = "white", lty = 1, FALSE)
  ### Add the markers for the record breaking days
  text(x=25, y = 111, labels = "Temperature", cex = 1.1, col = "black", font=2)
  text(x=70, y = 108, labels = "Bars are range representing the temperature.", cex = 0.6)
  text(x=70, y = 105, labels = paste("Average daily low temperature for 2011 is ",mean(temp$Low,na.rm=TRUE),",",sep = ""), cex = .6)
  text(x=70, y = 102, labels = paste("and average daily high is ",mean(temp$High,na.rm=TRUE),".", sep = ""), cex = .6)
  ### Add the titles 
  l_rect = (364/2)-2
  r_rect = (364/2)+2
  rect(xleft=l_rect , xright=r_rect, ytop= 35  , ybottom=  15, col="#d4c38f",border=NA)
  rect(xleft=l_rect , xright=r_rect ,ytop= 30, ybottom= 20  , col="#b0b0b0",border=NA)
  rect(xleft=l_rect , xright=r_rect,ytop=33, ybottom=23, col="darkred",border=NA)
  l_t = (364/2)-15
  r_t = (364/2)+15
  
  
  text(x=l_t, y = 35, labels = "RECORD HIGH", cex = 0.4)
  text(x=l_t, y = 15, labels = "RECORD LOW", cex = 0.4)
  text(x=l_t, y = 25, labels = "NORMAL RANGE", cex = 0.4)
  text(x=r_t, y = 33, labels = "ACTUAL HIGH", cex = 0.4)
  text(x=r_t, y = 23, labels = "ACTUAL LOW", cex = 0.4)
  
  
  ### Call makePlotRegion to create the plotting region
  ### for the precipitation plot
  makePlotRegion(xlim = c(1, 365), ylim = c(0, 8), bgcolor = "#ecd3bf", ylabels = seq(0, 6, by = 1), margins = c(2,2,0.5,2), cityName = "", xtop = FALSE,cumDays,monthNames)
  
  ### Call monthPrecip 12 times to create each months 
  ### cumulative precipitation plot. To do this use 
  ### sapply(1:12, function(m) {
  ###             code
  ###             monthPrecip(XXXX)
  ###             }) 
  ### the anonymous function calls monthPrecip with the 
  ### appropriate arguments
  sapply(1:12,  function(m){
     monthPrecip(day = cumDays[m] + temp$Day[temp$Month==m], dailyprecip = cumsum(temp$Precip[temp$Month == m]),normal = as.numeric(as.character(precip$normal[m])))
  })
  ### Call addGrid to add the grid lines to the plot
  segments(x0 = c(cumsum(daysInMonth)), y0 = 0, y1 = 6,
           col = "black", lty=3)
  addGrid(location = seq(0, 6, by = 1), col = "white", ltype = 1, vertical = FALSE)
  ### Add the titles
  text(x=10, y = 3, labels = "Normal Precipitation", cex = 0.6)
  text(x=10, y = 0.5, labels = "Actual Precipitation", cex = 0.6)
  text(x=15, y = 7, labels="Precipitation", cex= 0.9)
  text(x=180, y = 6, labels=paste("This is cumulative monthly precipitation against normal monthly precipitation. Total precipitation in SF this year is ",sum(as.numeric(precip$precip)),sep = ""), cex= .6)
  ### Close the pdf device dev.off()
  dev.off()
}

### Call: finalPlot(temp = sfoWeather, precip = sfoMonthlyPrecip)
finalPlot(temp = laxWeather, precip = laxMonthlyPrecip, lax = TRUE)
#finalPlot(temp = sfoWeather, precip = sfoMonthlyPrecip, lax = FALSE)


