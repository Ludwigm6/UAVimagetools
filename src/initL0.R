#' Creates Level 0 structure
#'
#' @description creates directories for L0 image data
#'
#' @param pathL0 [string] A directory path
#'
#' @author Marvin Ludwig
#'
#' @export
#'
#'


initL0 <- function(pathL0){

  # create L0 directory structure

  pathL0 <- paste0(pathL0, "/")


  if(!dir.exists(pathL0)){
    dir.create(pathL0)
  }

  dirs <- paste0(pathL0, c("images", "trashcan", "flightLog", "flightArea", "imageReport",
                           "trashcan/noGPS", "trashcan/taxi"))
  sapply(dirs, dir.create, showWarnings = FALSE)



}
