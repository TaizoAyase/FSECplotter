source("./src/logfile_parser.R")
source("./src/commandline_reader.R")
source("./src/plotter.R")
source("./src/speed_setter.R")

argv <- commandArgs(trailingOnly = TRUE)
raw_data_list <- list_maker(argv)
data_list <- speed_setter(raw_data_list, ask = TRUE)
df <- list2dataframe(data_list)

plot_path <- dirname(argv[1])
ggplotter(df, plot_path)
