# example workflow RAW to L0 with 20.04.1019 flight

library(exifr)
library(sf)

pathRAW <<- "~/uav/data/raw/2019_04_24_core14/"
img_exif <- read_exif(pathRAW, recursive = TRUE, tags = c("SourceFile", "Directory", "FileName", "DateTimeOriginal",
                                                          "GPSLongitude", "GPSLatitude", "GPSAltitude"))

# filter GPS
noGPS <- img_exif[is.na(img_exif$GPSLatitude),]
img_exif <- img_exif[!is.na(img_exif$GPSLatitude),]


# timestamp as POSIXct, order images by date
img_exif$time <- as.POSIXct(img_exif$DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S")
img_exif <- img_exif[order(img_exif$time),]

# add geometry information
img_exif <- st_as_sf(img_exif, coords = c("GPSLongitude", "GPSLatitude"), crs = 4326 ,dim = "XY")

# initialize time difference column and fill it time difference between two consecutive images
img_exif$timediff <- 0
img_exif$distdiff <- 0

for(i in seq(nrow(img_exif)-1)){
  img_exif$timediff[i+1] <- img_exif$time[i+1] - img_exif$time[i]
  img_exif$distdiff[i+1] <- st_distance(img_exif[i,], img_exif[i+1,])
}




# define flight tags based on time differences:
times <- which(img_exif$timediff >1)
img_exif$flight <- length(times)


for(g in seq(length(times), 1)){
  cur_group <- which(img_exif$time < img_exif$time[times[g]])
  img_exif$flight[cur_group] <- g

}















