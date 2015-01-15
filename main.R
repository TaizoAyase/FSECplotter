source("./src/logfile_parser.R")
source("./src/commandline_reader.R")
source("./src/plotter.R")
source("./src/speed_setter.R")
source("./src/limit_setter.R")
#source("./src/baseline_setter.R")

require(rjson)

# args
argv <- commandArgs(trailingOnly = TRUE)
channel <- as.character(argv[1]) # this must be "1" or "2"
files <- argc[2:length(argv)]

# read configfile
conf <- fromJSON(file = "./config.json")

##### detector selector is not used in current version #####
# select detector
#if(conf$AutoSelectDetector){
#  # do nothing.
#  cat("Detector will be selected automatically...\n")
#} else if(conf$AskDetector){
#  mes <- "Select detector A or B"
#  repeat{
#    detector <- read.str(mes)
#    flag <- (detector == "A" || detector == "B")
#    if(flag) break
#  }
#} else {
#  detector <- conf$DefaultDetector
#}

#read data from args
raw_data_list <- list_maker(files, channel)

#set speed
#if(conf$AskEachFlowSpeed){
  #data_list <- set_speed(raw_data_list, ask = TRUE, ask_each = TRUE)
#} else if(conf$AskFlowSpeed){
  #data_list <- set_speed(raw_data_list, ask = TRUE, ask_each = FALSE)
#} else {
  #data_list <- set_speed(raw_data_list, conf$DefaultFlowSpeed, ask = FALSE)
#}
data_list <- set_speed(raw_data_list, conf$DefaultFlowSpeed, 
                       ask = conf$AskFlowSpeed, ask_each = conf$AskEachFlowSpeed)

# define column type 
# large OR mini
# total volume < 10 => mini, else => large
if(all(data_list[[1]][1] < 15)){
  column_type <- 'mini'
} else {
  column_type <- 'large'
}

#set xlimit
if(column_type == "mini"){
  # do nothing
  x_limit <- NA
  cat("I guess your column type is mini column. X-axis scaling will be skipped...\n")
} else if(conf$AskXscaling){
  # Ask the scale limit of x-axis to user
  x_limit <- set_xlimit() 
} else {
  # set default value
  x_limit <- conf$DefaultXscaling
  cat("Set X-axis min/max to", x_limit, "\n")
}

#set ylimit
if(conf$AskYscaling){
  # Ask the scale limit of y-axis to user
  y_limit <- set_ylimit()
} else {
  y_limit <- NA
  cat("Y-axis limit will not be set...\n")
}

#set baseline
#!!! this baseline setter is not used in the latest version !!!
#flag <- read.yn("Do you want to adjust the baseline?")
#if(flag){
#data_list <- set_baseline(data_list)
#}

df <- list2dataframe(data_list)
plot_path <- dirname(files[1])
ggplotter(df, plot_path, xlimit = x_limit, ylimit = y_limit)
