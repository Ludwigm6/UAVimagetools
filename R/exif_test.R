library(exifr)
library(raster)
library(rgdal)
library(mapview)

setwd("/home/marvin/uav/data/2019_03_28_halfmoon/flight_01/")


test_e <- exifr::read_exif(path = getwd(), recursive = TRUE)


test_sp <- test_e
test_sp$GPSLatitude
test_sp$GPSLongitude



# remove images with no GPS signal
test_sp <- test_sp[!is.na(test_sp$GPSLatitude),]
test_sp <- test_sp[!is.na(test_sp$GPSLongitude),]



coordinates(test_sp) <- ~ GPSLongitude + GPSLatitude
projection(test_sp) <- CRS("+init=epsg:4326")

mapview(test_sp, zcol = "LightValue")

