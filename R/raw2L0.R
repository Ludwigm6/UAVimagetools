#' Analyses raw image UAV data and returns a L0 report
#'
#' @description Reads the EXIF information and divides the images into noGPS, taxi and useable L0 images
#'
#' @param pathRAW [string] path to the raw images
#' @param taxi_threshold [numeric] vector of length 2 with the lower and upper distance between two consecutive images
#'
#' @return list of exif
#'
#' @details Creates a subfolder in pathRAW with the following structure:
#' ├── flightArea
#' ├── flightLog
#' ├── imageReport
#' │   ├── images_l0.csv
#' │   ├── images_noGPS.csv
#' │   └── images_taxi.csv
#' ├── images
#' └── trashcan
#' ├── noGPS
#' └── taxi
#'Currently doesn't move any files
#'
#' @author Marvin Ludwig
#'
#' @export
#'







raw2L0 <- function(pathRAW,  taxi_threshold = c(3,5)){

  library(exifr)
  library(sf)
  library(filesstrings)

  # read input
  #-------------------------------------------

  initL0(paste0(pathRAW, "/l0"))

  img_exif <- exifr::read_exif(pathRAW, recursive = TRUE, tags = c("SourceFile", "Directory", "FileName", "DateTimeOriginal",
                                                            "GPSLongitude", "GPSLatitude", "GPSAltitude"))


  # format exif
  #-----------------------------------------------

  # divide into GPS and noGPS
  noGPS <- img_exif[is.na(img_exif$GPSLatitude),]
  img_exif <- img_exif[!is.na(img_exif$GPSLatitude),]


  # timestamp as POSIXct, order images by date
  img_exif$time <- as.POSIXct(img_exif$DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S")
  img_exif <- img_exif[order(img_exif$time),]

  # add geometry information
  img_exif <- st_as_sf(img_exif, coords = c("GPSLongitude", "GPSLatitude"), crs = 4326 ,dim = "XY")

  # time difference and dist difference between two consecutive images
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

  # divide into taxi and no taxi
  # currently based on distance thresholds!

  taxi <- img_exif[!(img_exif$distdiff > taxi_threshold[1] & img_exif$distdiff < taxi_threshold[2]),]
  img_exif <- img_exif[(img_exif$distdiff > taxi_threshold[1] & img_exif$distdiff < taxi_threshold[2]),]


  # write LOGs
  write.csv(noGPS, paste0(pathRAW, "/l0/imageReport/images_noGPS.csv"), row.names = FALSE)
  write.csv(taxi, paste0(pathRAW, "/l0/imageReport/images_taxi.csv"), row.names = FALSE)
  write.csv(img_exif, paste0(pathRAW, "/l0/imageReport/images_l0.csv"), row.names = FALSE)

  # return


  return(list(l0 = img_exif,
              taxi = taxi,
              noGPS = noGPS))


  # move files
  #-------------------------------------------
  # move noGPS images
  #filesstrings::file.move(noGPS$SourceFile, destinations = paste0(pathRAW, "/trashcan/noGPS/"))




}
