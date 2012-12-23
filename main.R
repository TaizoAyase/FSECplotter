source("./logfile_parser.R")
source("./commandline_reader.R")
source("./plotter.R")

argv <- commandArgs(trailingOnly = TRUE)
raw_data <- list_maker(argv)
data <- speed_setter(raw_data, ask = TRUE)
FSECplotter(data)
