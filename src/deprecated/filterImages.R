




filterImages_area <- function(pathRAW, pathL0, pathBadArea = paste0(pathL0, "/trashcan/badGPS/"), flightArea){


  # read image meta data
  image_meta <- exifr::read_exif(path = pathRAW, recursive = TRUE)





  # identify bad GPS

  image_sp <- image_meta

  coordinates(image_sp) <- ~ GPSLongitude + GPSLatitude
  projection(image_sp) <- "+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"


  boxplot(image_meta$GPSLongitude)

  plot(image_meta$GPSLongitude, image_meta$GPSLatitude)




  mapview(image_meta_gps[1000:2000,], zcol = "GPSAltitude")




}






