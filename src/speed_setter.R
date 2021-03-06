source("./src/commandline_reader.R")

#speed setter for matrix
conv2speed <- function(matrix_data, name = "all samples"){
  #get flow speed from command line
  message = paste("Enter flow speed(ml/min) for", name)
  speed <- read.nu(message)
  #[, 1] * speed, [, 2] * 1
  result <- sweep(matrix_data, MARGIN = 2, c(speed, 1), FUN = "*")
  return(result)
}

#speed setter for list
#different value can be set for each element
speed_setter_ask <- function(list_data, ask_each = TRUE){
  if(ask_each){
    #ask user:flow speed is same value among the all samples?
    flag <- read.yn("Is flow speed the same value among all samples?")
  } else {
    flag <- TRUE
  }
  
  #if TRUE, use lapply function
  if(flag){
    speed <- read.nu("Enter flow speed(ml/min)")
    list_speed <- lapply(list_data, FUN = sweep, 2, c(speed, 1), "*")
    result <- lapply(list_speed, FUN = "colnames<-", c("volume", "intensity"))
    return(result)
  #if not, use for loop and set each flow speed
  }else{
    list_speed <- list()
    len <- length(list_data)
    for(i in 1:len){
      name <- names(list_data[i])
      list_speed[[i]] <- conv2speed(list_data[[i]], name)
      names(list_speed)[i] <- name
    }
    result <- lapply(list_speed, FUN = "colnames<-", c("volume", "intensity"))
    return(result)
  }
}

#speed setter for not asking to user
speed_setter_no_ask <- function(list_data, speed){
  list_speed <- lapply(list_data, FUN = sweep, 2, c(speed, 1), "*")
  result <- lapply(list_speed, FUN = "colnames<-", c("volume", "intensity"))
  return(result)
}

#interface
set_speed <- function(list_data, speed, ask = FALSE, ask_each = FALSE){
  if(ask){
    return(speed_setter_ask(list_data, ask_each))
  }else{
    return(speed_setter_no_ask(list_data, speed))
  }
}