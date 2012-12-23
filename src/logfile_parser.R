logfileParser <- function(file, detector = "B"){
	#the patameter "detector" is "A" OR "B"
	
	#read a file (for each line)
	logfile <- readLines(file, encoding = "UTF-8")
		
	#search:data of detector
	#set start
	if(detector == "A"){
		data_start <- which(logfile == "[LC Chromatogram(Detector A-Ch1)]")
	}else if(detector == "B"){
		data_start <- which(logfile == "[LC Chromatogram(Detector B-Ch1)]")
	}
	
	#search the blank
	blank_row <- which(logfile == "")
	#define the end of data:
	#next blank from the row of "[LC Chromatogram(Detector X-Ch1)]"
	data_end <- blank_row[min(which(data_start < blank_row))]
	
	#store the raw data as character format
	#separated by \t
	data <- logfile[data_start:(data_end - 1)] #=> vector of character
	
	#extract the time and intensity data
	len <- length(data)
	time <- numeric(0)
	intensity <- numeric(0)
	
	#split the raw data by \t:
	#generating list of character
	data_split <- strsplit(data, "\t") #=> list
	
	#convert character to numeric:
	#including NA value
	#Warnings is suppressed
	#Expected warning is "as.numeric(char) => NA"
	data_numeric <- suppressWarnings(lapply(data_split, FUN = as.numeric))#=>list

	#search the elements including NA(character)
	na_list <- lapply(data_numeric, FUN = is.na) #=> logical vector

	#create the logical vector:
	#which element of data list is character
	data_na <- unlist(lapply(na_list, FUN = any)) #=> logical vector

	#store the numeric data and return
	time_int_list <- data_numeric[!data_na]

	#create matrix
	num_len <- length(time_int_list)
	m <- matrix(NA, ncol = 2, nrow = num_len)
	for(i in 1:num_len){
		m[i, ] <- time_int_list[[i]]
	}
	return(as.data.frame(m))
} #=> data.frame

#input files(vector)
#output list; time * intensity
list_maker <- function(files){
  file_name <- basename(files)
  list_name <- gsub(".txt$", "",file_name)
  
  output_ls <- list()
  for(i in 1:length(files)){
    output_ls[[i]] <- logfileParser(files[i])
    names(output_ls)[i] <- list_name[i]
  }
  return(output_ls)
} #=> list