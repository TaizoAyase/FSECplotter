require(ggplot2)

#convert list to single dataframe
list2dataframe <- function(list){
  df_out <- data.frame()
  list_len <- length(list)
  
  #bind all dataframe to single dataframe
  for(li in 1:list_len){
    name_vec <- rep(names(list)[li], nrow(list[[li]]))
    list[[li]] <- cbind(list[[li]], name_vec)
    df_out <- rbind(df_out, list[[li]])
  }
  
  colnames(df_out) <- c("volume", "intensity", "name")
  return(df_out)
}#=> data.frame, ncol = 3

#function for plotting, output to pdf file
ggplotter <- function(dataframe, pdf_path = "./", ylimit = NA){
  g <- ggplot(dataframe, aes(x = volume, y = intensity, group = name, col = name))
  default_plot <- g + geom_line(size = lwd) + theme_bw(22)
  if(is.na(ylimit)){
    final_plot <- default_plot
  }else{
    final_plot <- default_plot + ylim(min(detaframe$intensity), ylimit)
  }
  
  #generate Plot File Name from System Time
  timedate <- gsub(":", "", Sys.time())
  plot_name <- paste("FSECplot_", timedate, ".pdf", sep = "")
  #change directory
  setwd(pdf_path)
  
  ggsave(plot_name, final_plot, width = 20, height = 12)
  return()
}

#-*- old version -*-
#using default plot() function
#not loaded on memory
# FSECplotter <- function(dataset, 
# 	plot_path = "./", 
# 	pdf_plot = TRUE, dev_width = 10){
# 	
# 	#dataset is expected as list
#  	#the elements of list is expected to be named
# 	#dataset[[i]] :: each sample data
# 	#class(dataset[[i]]) => matrix
# 
# 	#set max / min constants
# 	volume <- unlist(lapply(dataset, FUN = "[", , 1))
# 	intensity <- unlist(lapply(dataset, FUN = "[", , 2))
# 
# 	int_max <- max(unlist(intensity))
# 	int_min <- min(unlist(intensity))
# 	vol_max <- max(unlist(volume))
# 	vol_min <- min(unlist(volume))
# 
#   if(pdf_plot){
#   	#generate Plot File Name
#   	timedate <- gsub(":", "", Sys.time())
#   	plotName <- paste("FSECplot_", timedate, ".pdf", sep = "")
#   	#change directory to 
#   	setwd(plot_path)
#   	#open graffic device in PDF format
#   	pdf(plotName, dev_width)
#   }
# 
# 	#make plots for each data
#   len <- length(dataset)
# 	for(i in 1:len){
# 		plot(dataset[[i]][, 1], dataset[[i]][, 2],
# 			col = rainbow(len)[i], #set colors
# 			type = "l", #line type is line w/o dots
# 			xlim = c(vol_min, vol_max), #set limit of x-axis
# 			ylim = c(int_min, int_max), #set limit of y-axis
# 			xlab = "", ylab = "", #label is not drawn
# 			xaxt = "n", yaxt = "n" #axis is not drawn
#       )
# 		par(new = TRUE)
# 	}
# 
# 	#draw axis and labels
# 	par(xpd = TRUE)
# 	axis(1, labels = TRUE); axis(2, labels = TRUE)
# 	text(mean(range(volume)), -(int_max - int_min) / 6,
# 		"volume(ml)")
# 	text(-(vol_max - vol_min) / 8, (int_max - int_min) / 2,
# 		"intensity", srt = 90)
# 
# 	#make legend
# 	leg_name <- names(dataset)
# 	legend("topright",
# 		legend = leg_name,
# 		col = rainbow(len),
# 		lty = 1)
# 
# 	#close graffic device
#   if(pdf_plot) dev.off()
# }