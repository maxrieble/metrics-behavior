rm(list=ls(all=TRUE));gc() # clear out memory and run garbage collection
setwd("C:/Users/user/OneDrive/Master Study/Materials/carp") # set the working directory

## step 1: amalgamate files together
files<-list.files(".",pattern = ".txt", recursive = TRUE, all.files = TRUE)

CarpData<-read.delim(files[1], header = TRUE)
for(i in 2:length(files)){
  newfile<-read.delim(files[i], header = TRUE)
  #  CarpData<-rbind(Carp,newfile)
  CarpData<-rbind(CarpData,newfile)
  print(i)
}

save(CarpData, file = "CarpData.rdata")
load("CarpData.rdata")
#step 2. investigate times and clean up data.
head(CarpData); names(CarpData)
CarpData<-CarpData[,-c(2,9,22,18,19)] #remove unnecessary columns
CarpData$time<-paste(CarpData$date, CarpData$time)
CarpData$time<-as.POSIXct(CarpData$time, format = "%d.%m.%Y %H:%M:%S", tz = "GMT") # Time is in GMT
attr(CarpData$time, "tzone")<-"CET"
CarpData$x<-CarpData$x + 3000000

CarpData$hours<-as.POSIXct(cut(CarpData$time, "hour"))#, tz = "GMT")
CarpData$days<-as.POSIXct(cut(CarpData$time, "day"))#, tz = "GMT")
CarpData$mins<-as.POSIXct(cut(CarpData$time, "min"))#, tz = "GMT")
CarpData$week<-as.POSIXct(cut(CarpData$time, "week"))#, tz = "GMT")
CarpData$month<-as.POSIXct(cut(CarpData$time, "month"))#, tz = "GMT")
CarpData$year<-as.POSIXct(cut(CarpData$time, "year"))#, tz = "GMT")


save(CarpData, file = "CarpData.rdata")
pos<-CarpData;
save(pos, file = "CarpData.rdata")
head(pos)

