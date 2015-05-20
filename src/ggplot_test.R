setwd("/Users/takemotomizuki/Documents/Dropbox/nureki_lab/FSECplotter")
require(ggplot2)

#file <- "./testfile.txt"
source("./commandline_reader.R")
source("./plotter.R")
source("./logfile_parser.R")

setwd("~/Documents/Dropbox/nureki_lab/RseP/FSEC/120612/")
files <- grep("TA[0-9]+.txt", dir(), value = TRUE)
raw_data <- list_maker(files)
data_w_speed <- speed_setter(raw_data, ask = FALSE, speed = 0.5)

#df <- data.frame(volume = numeric(0), intensity = numeric(0), sample_name = character(0))
df <- data.frame()
list_len <- length(data_w_speed)
for(i in 1:list_len){
  name_vec <- rep(names(data_w_speed)[i], nrow(data_w_speed[[i]]))
  data_w_speed[[i]] <- cbind(data_w_speed[[i]], name_vec)
  df <- rbind(df, data_w_speed[[i]])
}
colnames(df) <- c("volume", "intensity", "sample_name")

g <- ggplot(df, aes(x = volume, y = intensity, group = sample_name, col = sample_name))
g <- g + geom_line(size = 1)
g <- g + theme_grey(22)

print(g)
ggsave("plottest.pdf", g)