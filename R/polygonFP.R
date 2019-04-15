#' Polygon to FP line
#'
#' @description converts a polygon to a line used by makeAP
#'
#' @author Marvin Ludwig
#'

polygonFlight <- function(p, take_off = c(477704, 5632173)){
  library(sf)


  # convert to multiple lines
  poly_to_line <- lapply(seq(4), function(x){
    return(st_coordinates(pts_buffer)[c(x,x+1),c(1,2)])

  })

  ml <- st_cast(st_sfc(st_multilinestring(x = poly_to_line), crs = 25832), "LINESTRING")
  mapview(ml)

  # find out the nearest two lines to take off point
  nearest <- which(st_distance(take_off, ml) == min(st_distance(take_off, ml)))



}

