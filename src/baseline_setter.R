#set baseline
#minmum value -> 0; for fomatted data list
set_zero <- function(list){
  for(i in 1:length(list$intensity)){
    data <- list$intensity[[i]][, 2]
    if(is.numeric(data)){
      min <- min(data)
      data_after <- data - min
      list$intensity[[i]][, 2] <- data_after
    }
  }
  return(list)
}

#use for tilted baseline
set_gradient_baseline <- function(dataframe, colum_size = 30){
  vol_max <- colum_size / 4
  df_use_lm <- dataframe[dataframe[, 1] < vol_max, ]
  lm_result <- lm(intensity ~ volume, data = df_use_lm)
  
  #set function of baseline
  base_line <- function(vol, lm_result){
    a <- coef(lm_result)[[2]]; b <- coef(lm_result)[[1]]
    return(a * vol + b)
  }
  
  dataframe[, 2] <- dataframe[, 2] - base_line(dataframe[, 1], lm_result)
  return(dataframe)
}