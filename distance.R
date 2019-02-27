# Setup, setwd, libraries, lists #####
rm(list=ls(all=TRUE));gc() # clear out memory and run garbage collection
setwd("C:/Users/user/OneDrive/Master Study/Materials/carp") # set the working directory
library(dplyr)
library(sp)
load("CarpData.rdata")
IDlist<-unique(CarpData$ID) #create IDlist as list of unique ID´s
Daylist<-seq.POSIXt(from=min(CarpData$days),to=max(CarpData$days), by= "day")  #create Daylist as a sequence of all days from the first to the last including those without data.
behaviors<-expand.grid(IDnum = 1:length(IDlist), Daynum = 1:length(Daylist))  #create behaviors df with all combinations of IDnum and Daynum
behaviors$ID<-IDlist[behaviors$IDnum] # Add authentic ID to behaviors
behaviors$Day<-Daylist[behaviors$Daynum] # Add authentic Date to behaviors
  
# create distance function ####
distFunc<-function(IDnum, Daynum,threshold){   
  data<-dplyr::filter(CarpData,ID == IDlist[IDnum], days == Daylist[Daynum]) #subseting the data
  if(nrow(data) > 3){
    distance<-c(0,sqrt((data$x[-1]-data$x[-length(data$x)])^2 + (data$y[-1]-data$y[-length(data$y)])^2)) # calculate distances between points
    timediff<-c(0,difftime(data$time[-1],data$time[-length(data$time)],unit = "secs")) # calculate time diff between points
    data<-data.frame(ID = data$ID,x = data$x, y = data$y, day = data$days, dist = distance, timedif.sec = timediff) # only keep relevant columns
    #speed<-data$dist/data$timedif.sec  # calculate speed if needed (currently commented out)
    #data<-data[-which(data$timedif.sec < 0),] # remove rows if timedif is negative - clearly will be an error for negative timediff
    data<-data[-which(data$dist <= threshold),]  # remove rows where distance is below a threshold indistinguishable from error
    dist<-sum(na.omit(data$dist))
    return(dist)
  }else{
    return(NA)
  }
}  

#mapply function and save file ####
#behaviors$distance<-mapply(distFunc,behaviors$IDnum,behaviors$Daynum,5)
behaviors$distance<-mapply(distFunc,behaviors$IDnum,behaviors$Daynum,rep(5, nrow(behaviors)))

save(behaviors, file ="behaviors.rdata")




