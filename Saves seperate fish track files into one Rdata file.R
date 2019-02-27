rm(list=ls(all=TRUE));gc() # clear out memory and run garbage collection
setwd("U:/Muehlbradt/Andreas Carp Videos/Positions/June") # set the working directory

## step 1: amalgamate files together
files<-list.files(".",pattern = ".txt", recursive = TRUE, all.files = TRUE)

FishData<-read.delim(files[1], header = TRUE)
for(i in 2:length(files)){
  newfile<-read.delim(files[i], header = TRUE)
#  CarpData<-rbind(Carp,newfile)
  FIshData<-rbind(CarpData,newfile)
  print(i)
}

save(FishData, file = "FishData.rdata")
load("FishData.rdata")
#step 2. investigate times and clean up data.
head(FishData); names(FishData)
FishData<-FishData[,-c(2,9,22,18,19)] #remove unnecessary columns
FishData$time<-paste(FishData$date, FishData$time)
FishData$time<-as.POSIXct(FishData$time, format = "%d.%m.%Y %H:%M:%S", tz = "GMT") # Time is in GMT
attr(FishData$time, "tzone")<-"CET"
FishData$x<-FishData$x + 3000000

FishData$hours<-as.POSIXct(cut(FishData$time, "hour"))#, tz = "GMT")
FishData$days<-as.POSIXct(cut(FishData$time, "day"))#, tz = "GMT")
FishData$mins<-as.POSIXct(cut(FishData$time, "min"))#, tz = "GMT")
FishData$week<-as.POSIXct(cut(FishData$time, "week"))#, tz = "GMT")

pos<-FishData;
save(pos, file = "FishData.rdata")
head(pos)
