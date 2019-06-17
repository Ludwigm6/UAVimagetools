# find X nearest images at location


imagesAtLocation <- function(imgPath, loc, imgCount = 20){
  library(sf)
  
  img_exif <- exifr::read_exif(imgPath, recursive = TRUE, tags = c("SourceFile", "GPSLatitude", "GPSLongitude"))
  
  # filter no GPS images
  img_exif <- img_exif[!is.na(img_exif$GPSLatitude),]
  
  # convert to sf
  img_exif <- st_as_sf(img_exif, coords = c("GPSLongitude", "GPSLatitude"), crs = 4326 ,dim = "XY")
  
  # format tree location

  loc <- st_transform(loc, crs = 4326)
  
  
  # find nearest 5 images at the tree location
  img_exif$tree_dist <- st_distance(loc, img_exif, by_element = TRUE)
  img_exif <- img_exif[order(img_exif$tree_dist),]
  
  img <- img_exif[1:imgCount,]
  return(img)
  
  
}


