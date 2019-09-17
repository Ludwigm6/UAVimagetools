#' First and last waypoint of the tasks
#'
#'
#'
#'


readTasks <- function(path){
  
  tasks <- list.files(path, full.names = TRUE)
  
  res <- lapply(seq(length(tasks)), function(t){
    
    cur <- read.table(tasks[t],
                      skip = 1, header = FALSE)
    cur$task <- t
    # filter waypoints
    cur <- cur[cur$V9 != 0,]
    
    # get first and last waypoint of task area
    cur <- cur[c(which(cur$V1 == 7), nrow(cur)),]
    cur$tag <- c("b", "e")
    return(cur)
    
  })
  res <- do.call(rbind, res)
  res <- st_as_sf(res, coords = c("V10", "V9", "V11"), dim = "XYZ",crs = 4326)
  return(res)
}



