#' Read Exif from one mission
#' 
#'  
#'   
#'    

library(exifr)
library(sf)


taskExif <- function(path){
  img_exif <- read_exif(path, recursive = TRUE, tags = c("SourceFile", "Directory", "FileName", "DateTimeOriginal",
                                                         "GPSLongitude", "GPSLatitude", "GPSAltitude"))
  
  # filter GPS
  noGPS <- img_exif[is.na(img_exif$GPSLatitude),]
  img_exif <- img_exif[!is.na(img_exif$GPSLatitude),]
  
  # timestamp as POSIXct, order images by date
  img_exif$time <- as.POSIXct(img_exif$DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S")
  img_exif <- img_exif[order(img_exif$time),]
  
  # add geometry information
  img_exif <- st_as_sf(img_exif, coords = c("GPSLongitude", "GPSLatitude", "GPSAltitude"), crs = 4326 ,dim = "XYZ")
  return(img_exif)
}

