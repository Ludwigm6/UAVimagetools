#' Filter images without a GPS Exif Information
#'
#' Doesn't delete any images, just moves them to the trashcan folder
#'
#' @param pathRAW [string] path to the raw images
#' @param pathL0 [string] path to the L0 destination
#'
#'
#' @author Marvin Ludwig
#'




filterImages_gps <- function(pathRAW, pathL0){

  pathNoGPS <- paste0(pathL0, "/trashcan/noGPS/")

  image_meta <- exifr::read_exif(path = pathRAW, recursive = TRUE)

  # identify images with no GPS signal
  image_meta_gps <- image_meta[is.na(image_meta$GPSLatitude),]
  image_meta <- image_meta[!is.na(image_meta$GPSLatitude),]

  # move images with no GPS to folder noGPS
  filesstrings::file.move(files = image_meta_gps$SourceFile, destinations = pathNoGPS)


}
