# tree position control

library(sf)
library(mapview)
library(filesstrings)



# example with mof_cst_00074


tree <- data.frame(name = "mof_cst_00074", lat = 477877, lon = 5632190)
tree <- st_as_sf(tree, coords = c("lat", "lon"), crs = 25832, dim = "XY")



flights <- list.dirs(path = "~/uav/uav_core14/raw/", recursive = FALSE)


cst74_images <- lapply(flights, function(x){
  
  imgs <- imagesAtLocation(x, loc = tree)
  return(imgs)
  
})


mapview(cst74_images[[10]]) + mapview(tree, color = "red")


# move images (from core14 onwards)

for(i in seq(10,19)){
  file.copy(cst74_images[[i]]$SourceFile, to = "/home/marvin/uav/uav_core14/ts_mof_cst_00074/")
  
  
}





