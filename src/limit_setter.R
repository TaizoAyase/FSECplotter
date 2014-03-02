source("./src/commandline_reader.R")

# set min-max limit of x-axis
# get two numeric value from command line
set_xlimit <- function(){
  mes <- "Do you want to set min-max value of X-axis?"
  ans <- read.yn(mes)
  if(!ans) return(NA)
  
  # generate min-max vector
  mes <- "Enter minimum value for X-axis."
  min <- read.nu(mes)
  mes <- "Enter maximum value for X-axis."
  max <- read.nu(mes)
  return(c(min, max))
}

# set upper limit of y-axis
# get single numeric value from command line
set_ylimit <- function(){
  message <- "Enter the max value for Y-axis. If you don't need, press enter."
  value <- read.nu(message)
  ylimit <- suppressWarnings(as.numeric(value))
  return(ylimit)
}