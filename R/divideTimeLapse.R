#' Divides RAW images into flights
#'
#' @description Takes (unsorted) time lapse images and sorts them into directories
#'
#' @param imgPath path to the raw images
#' @param lapseTime time in seconds between the images of a lapse
#'
#' @return NULL
#'
#' @author Marvin Ludwig
#'


divideTimeLapse <- function(imgPath, lapseTime = 1){
  library(exifr)
  library(filesstrings)

  # read input
  #-------------------------------------------
  img_exif <- exifr::read_exif(imgPath, recursive = TRUE, tags = c("SourceFile", "DateTimeOriginal"))

  # timestamp as POSIXct, order images by date
  img_exif$DateTimeOriginal <- as.POSIXct(img_exif$DateTimeOriginal, format = "%Y:%m:%d %H:%M:%S")
  img_exif <- img_exif[order(img_exif$DateTimeOriginal),]

  # time difference and dist difference between two consecutive images
  img_exif$timediff <- 0

  for(i in seq(nrow(img_exif)-1)){
    img_exif$timediff[i+1] <- img_exif$DateTimeOriginal[i+1] - img_exif$DateTimeOriginal[i]
  }

  # define flight tags based on time differences:
  times <- which(img_exif$timediff > lapseTime)
  img_exif$flight <- length(times)+1


  for(g in seq(length(times), 1)){
    img_exif$flight[which(img_exif$DateTimeOriginal < img_exif$DateTimeOriginal[times[g]])] <- g
  }

  # first occurence of flight number is the time and folder name
  for(d in unique(img_exif$flight)){
    # create folder
    cur_dir <- paste0(imgPath, "/",
                      gsub(pattern = c(":| |-"),
                           replacement = "_",
                           as.character(img_exif$DateTimeOriginal[match(d, img_exif$flight)])))


    dir.create(cur_dir)

    # move corresponding images
    print(cur_dir)
    filesstrings::move_files(img_exif$SourceFile[img_exif$flight == d], cur_dir, overwrite = FALSE)

  }

}



