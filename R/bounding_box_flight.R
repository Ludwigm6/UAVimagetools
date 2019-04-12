# flight area test

library(exifr)
library(raster)
library(rgdal)
library(mapview)
library(uavRmp)
library(spatstat)
library(ggplot2)

pts <- readOGR("/home/marvin/uav/missions/data/core_study_trees_2019.json")
cst <- readOGR("/home/marvin/uav/missions/data/core_study_trees_2019.json")

bb <- minBB(cst)

cst@coords


mapview(bb)

mapview(cst, color = "blue") + mapview(bb, color = "yellow")

cst_n <- cst[c(3,4,10,7,6),]

cstm <- cst@coords
cst <- as.data.frame(cst@coords)

bb <- getMinBBox(cstm)

bb <- as.data.frame(bb$pts)

ggplot(bb, aes(x = coords.x1, y = coords.x2))+
  geom_point()+
  geom_point(data = cst, color = "red")+
  coord_equal()



# buffer the rectange













