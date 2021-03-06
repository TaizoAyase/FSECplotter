
get_section <- function(file, section_name){
  logfile <- readLines(file, encoding = "UTF-8")
  
  # search:data of "section_name"
  # set start
  data_start <- which(logfile == section_name)
    
	#search the blank
	blank_row <- which(logfile == "")
	#define the end of data:
	#next blank from the row of "[LC Chromatogram(Detector X-Ch1)]"
	data_end <- blank_row[min(which(data_start < blank_row))]
	
	#store the raw data as character format
	#separated by \t
	data <- logfile[data_start:(data_end - 1)] #=> vector of character
  
	#split the raw data by \t:
	#generating list of character
	data_split <- strsplit(data, "\t") #=> list
  
  return(data_split)
}


#parse single FSEC logfile
logfileParser <- function(file, detector = "B", channel){
	#the patameter "detector" is "A" OR "B"
	
	#search:data of detector
	#set start
	if(detector == "A"){
    section_read <- paste("[LC Chromatogram(Detector A-Ch", channel,")]", sep = "")
	}else if(detector == "B"){
    section_read <- paste("[LC Chromatogram(Detector B-Ch", channel,")]", sep = "")
	}
  
  # get the list of section of chromatogram table
  data_split <- get_section(file, section_read)
	
	#convert character to numeric:
	#including NA value
	#Warnings is suppressed
	#Expected warning is "as.numeric(char) => NA"
	data_numeric <- suppressWarnings(lapply(data_split, FUN = as.numeric))#=>list

	#search the elements including NA(character)
	na_list <- lapply(data_numeric, FUN = is.na) #=> logical vector

	#create the logical vector which element of data list is character
	data_na <- unlist(lapply(na_list, FUN = any)) #=> logical vector

	#store the numeric data
	time_int_list <- data_numeric[!data_na]

	#create data.frame
	num_len <- length(time_int_list)
	m <- matrix(NA, ncol = 2, nrow = num_len)
	for(i in 1:num_len){
		m[i, ] <- time_int_list[[i]]
	}
	time_int_df <- as.data.frame(m)
  colnames(time_int_df) <- c("time", "intensity")
	return(time_int_df)
} #=> data.frame

#input files(vector)
#output list; time * intensity
list_maker <- function(files, channel){
  file_name <- basename(files)
  list_name <- gsub(".txt$", "",file_name)
  
  output_ls <- list()
  for(i in 1:length(files)){
    detector <- define_detector(files[i])
    output_ls[[i]] <- logfileParser(files[i], detector = detector, channel = channel)
    names(output_ls)[i] <- list_name[i]
  }
  return(output_ls)
} #=> list

# define the detector for plot
define_detector <- function(file){
  detector_config <- get_section(file, "[Configuration]")
  pos_detID <- grep('Detector ID', detector_config)
  detector_list <- detector_config[[pos_detID]]
  
  # if the file has two detectors(i.e. has "Detector B"), use it
  if("Detector B" %in% detector_list){
    return("B")
  }else{
    # if not, use "Detector A"
    return("A")
  }
}
