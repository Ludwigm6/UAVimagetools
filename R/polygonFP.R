#' Polygon to FP line
#'
#' @description converts a polygon to a line used by makeAP
#'
#' @author Marvin Ludwig
#'

polygonFlight <- function(p, sides = c(4, 3),take_off = c(477704, 5632173), epsg = 25832){
  library(sf)
  library(sp)

  # convert takeoff to sf
  # toDo
  #take_off <- st_point(x = take_off), crs = epsg)
  test <- st_cast(p, "POINT")[1:4]
  names(test) <- 1:4

  mapview(test)





  # convert to multiple lines
  poly_to_line <- lapply(seq(4), function(x){
    return(sf::st_coordinates(p)[c(x,x+1),c(1,2)])

  })

  area_corners <- sf::st_cast(sf::st_sfc(sf::st_multilinestring(x = poly_to_line), crs = 25832), "MULTIPOINT")

  mapview(area_corners, label = TRUE)
  fp_area <- sf::st_sfc(sf::st_linestring(x = rbind(sf::st_coordinates(ml[[4]])[,c(1,2)],
                                                    sf::st_coordinates(ml[[3]])[,c(1,2)], take_off)), crs = 25832)

  fp_area <- sf::st_sfc(sf::st_linestring(x = rbind(sf::st_coordinates(ml[[4]]),
                                                    sf::st_coordinates(ml[[3]]))), crs = 25832)

  fp_area <- sf::st_sfc(sf::st_linestring(x = sf::st_coordinates(ml[[3]])), crs = 25832)



  sp::Lines(rbind(sf::st_coordinates(ml[[4]])[,c(1,2)], st_coordinates(ml[[3]])[,c(1,2)], take_off))



}

