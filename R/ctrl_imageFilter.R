library(exifr)
library(sf)
library(mapview)
library(filesstrings)

source("readRAW.R")
source("readTasks.R")


cleanImages <- function(imgPath, trackPath, destination){
  images <- taskExif(imgPath)
  track <- readTasks(trackPath)
  
  track$ni <- st_nearest_feature(track, images)
  
  res <- lapply(seq(1,14,2), function(x){
    
    bt <- images$time[track$ni[x]]
    et <- images$time[track$ni[x+1]]
    
    return(images[images$time > bt & images$time < et,])
    
  })
  
  res <- do.call(rbind, res)
  
  return(res)
  
}

