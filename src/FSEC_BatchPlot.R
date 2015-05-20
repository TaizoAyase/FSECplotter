source("./logfile_parser.R")
source("./plotter.R")

#args is expected to be FSEC log files(full path)
#args[1] is "hogehoge/FSECplotter"
args <- commandArgs(trailingOnly = TRUE)

#change working dir
cmmd_path <- dirname(args[1])
file_path <- args[2:length(args)]
ch_dir <- paste(cmmd_path, "/lib", sep = "")
setwd(ch_dir)

#Parse the LogFiles of ARGs
time_int_table <- list(0)
for(i in 1:length(file_path)){
	time_int_table[[i]] <- logfileParser(file_path[i])
	names(time_int_table[[i]]) <- basename(file_path[i])
}

#forming data
time <- list(0)
intensity <- list(0)
for(i in 1:length(time_int_table)){
	time[[i]] <- unlist(lapply(time_int_table[[i]], "[", 1))
	intensity[[i]] <- unlist(lapply(time_int_table[[i]], "[", 2))
}
speed <- 0.5
volume <- lapply(time, FUN = "*", speed)

#set some constants
len <- length(time_int_table)
int_max <- max(unlist(intensity))
int_min <- min(unlist(intensity))
vol_max <- max(unlist(volume))
vol_min <- min(unlist(volume))

#generate File Name
timedate <- gsub(":", "", Sys.time())
plotName <- paste("FSECplot", timedate, ".pdf", sep = "")

ch_dir_plot <- dirname(file_path[1])
setwd(ch_dir_plot)

#open graffic device in PDF format
pdf(plotName, width = 10)

#make plots for each data
for(i in 1:len){
	plot(volume[[i]], intensity[[i]],
		col = rainbow(len)[i], #set colors
		type = "l", #line type is line w/o dots
		ylim = c(int_min, int_max), #set lim of y-axis
		xlab = "", ylab = "", #label is not drawn
		xaxt = "n", yaxt = "n") #axis is not drawn
	par(new = TRUE)
}

#draw axis and labels
par(xpd = TRUE)
axis(1, labels = TRUE); axis(2, labels = TRUE)
text(mean(range(volume)), -(int_max - int_min) / 6,
	"volume(ml)")
text(-(vol_max - vol_min) / 8, (int_max - int_min) / 2,
	"intensity", srt = 90)

#make legend
filenames <- basename(file_path)
leg_name <- sapply(strsplit(filenames, "\\."), "[", 1)
legend("topright",
	legend = leg_name,
	col = rainbow(len),
	lty = 1)

#close graffic device
dev.off()