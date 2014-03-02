source("./src/logfile_parser.R")
source("./src/commandline_reader.R")
source("./src/plotter.R")
source("./src/speed_setter.R")
source("./src/limit_setter.R")
#source("./src/baseline_setter.R")

#read data from command line
argv <- commandArgs(trailingOnly = TRUE)
raw_data_list <- list_maker(argv)

#set speed
data_list <- set_speed(raw_data_list, ask = TRUE)

#set ylimit
mes <- "Do you want to set max value of Y axis?"
y_limit <- set_ylimit()

#set baseline
#!!! this baseline setter is not used in the latest version !!!
#flag <- read.yn("Do you want to adjust the baseline?")
#if(flag){
#data_list <- set_baseline(data_list)
#}

df <- list2dataframe(data_list)
plot_path <- dirname(argv[1])
ggplotter(df, plot_path, ylimit = y_limit)