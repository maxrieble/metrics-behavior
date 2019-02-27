rm(list=ls(all=TRUE));gc() # clear out memory and run garbage collection
setwd("C:/Users/user/OneDrive/Master Study/Materials/carp")
load("CarpData.rdata")
load("behaviors.rdata")

CarpData<-pos

library(adehabitatHR)
library(dplyr)
library(maptools)
library(rgdal)
rec=read.csv("hydrophones.csv",sep=",")
shoreline=

# Creates a raster base for kernels based on the receivers
loc<-SpatialPoints(cbind(rec$x,rec$y))
ud<-adehabitatHR::kernelUD(loc,grid=200,h=5,kern=c("bivnorm"),extent=0.5) 
udvol<-adehabitatHR::getvolumeUD(ud)
raster<- SpatialPixels(SpatialPoints(coordinates(udvol)))


RangeFunc<-function(IDnum,Daynum){
  
  # subset by ID 
  temp<-pos
  
  cat("calculating the home range","\n")
  flush.console()
  
  # subsample by unique Id and full day: (as in distancefunc)
  #posHR<-filter(temp, days == sort(unique(pos$days))[DayNum])   
  posHR<-dplyr::filter(temp,ID == IDlist[IDnum], days == Daylist[Daynum]) 
  
  
  if( nrow(posHR) > 30){
    #turn it to a spatialpointsdataframe
    sp_df<-SpatialPointsDataFrame(coordinates(cbind((posHR$x),posHR$y)),data = data.frame(ID=(rep("a",nrow(posHR)))))
    remove(posHR) #remove the dataframe for to save memory
    
    #kernel utilization method
    kud <- adehabitatHR::kernelUD(sp_df[,1], grid=raster, h=10) #see documentation ?kernelUD
    
    return(kud) #return kernel utilization density
  }else
  {
    NA
  }
} #end func

HRcarp<-mapply(RangeFunc,behaviors$IDnum,behaviors$Daynum)
behaviors$HR95<-vector(length = length(HRcarp))
for(i in 1:length(HRcarp)){
  if(!is.na(HRcarp[[i]])){   # For all rows in which a HR could be calculated, calculate HR95
    behaviors$HR95[i]<-adehabitatHR::kernel.area(HRcarp[[i]],percent= 95)}
  else{
    behaviors$HR95[i]<-NA
  }
}

save(behaviors, file ="behaviors.rdata") # overwrite earlier version of behaviors
load("behaviors.rdata")






##for plotting ##

#colour ramps for plotting
jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF","yellow", "#FF7F00", "red", "#7F0000")) 
french.flag <-colorRampPalette(c("#00007F", "blue", "white", "red", "#7F0000"))
ocean.blue<- colorRampPalette(c("darkblue","lightblue","cyan"))


plotHR<-function(){
  par(mar = c(0.1,0.1,0.1,0.1))
  for(x in seq(95,5,-5)){
    #if(!is.na(HRcarp[[i]])){   # For all rows in which a HR could be calculated, calculate HR95
      plot(adehabitatHR::getverticeshr(HRcarp[5],percent= x), add = TRUE, col = jet.colors(100)[100-x], border = F)
    #}
    
  #plot_outside()
  #plot(shoreline2, add = TRUE, lwd = 2)
  
  lines(c(3405050,3405150)-50, c(5872403, 5872403), lwd = 3.5, lend = 2)
  text(labels = "100 metres", x = 3405100-50, y = 5872375, cex = 1.4)
  polygon(x = c(3405189,3405189,3405169,3405189), y = c(5872827,5872872,5872802,5872827) - 439,col = "white")
  polygon(x = c(3405189,3405189,3405209,3405189), y = c(5872827,5872872,5872802,5872827) - 439,col = "black")
  text(3405189,5872916 - 459, labels = "N", cex = 1.5, font = 2)
  
  }
}

png(filename = paste(i,"CarpHR.png"),width = 14.5*1.414, height = 14.5,units = "cm", bg = "white", res = 600, pointsize = 10)
plotHR()
dev.off()
#}
