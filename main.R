source("./src/logfile_parser.R")
source("./src/commandline_reader.R")
source("./src/plotter.R")
source("./src/speed_setter.R")

argv <- commandArgs(trailingOnly = TRUE)
raw_data <- list_maker(argv)
data <- speed_setter(raw_data, ask = TRUE)
FSECplotter(data)
