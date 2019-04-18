# create Level 0 structure


initL0 <- function(pathL0){

  # create L0 directory structure

  pathL0 <- paste0(pathL0, "/")


  if(!dir.exists(pathL0)){
    dir.create(pathL0)
  }

  dirs <- paste0(pathL0, c("images", "trashcan", "flightLog", "flightArea", "report"))
  sapply(dirs, dir.create, showWarnings = FALSE)



}
