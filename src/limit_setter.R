source("./src/commandline_reader.R")

set_ylimit <- function(){
  message <- "Enter the max value for Y-axis. If you don't need, press enter."
  value <- read.nu(message)
  ylimit <- suppressWarnings(as.numeric(value))
  return(ylimit)
}