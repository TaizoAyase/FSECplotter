#read number from commandline
read.nu <- function(message){
	message <- paste(message, "\n")
  cat(message)
  f_in <- file("stdin")
	tmp <- readLines(f_in, 1)
	nu <- suppressWarnings(as.numeric(tmp))
  close(f_in)
	return(nu)
}#=> numaric

#ask yes or no
#returns logical vector
read.yn <- function(message){
	repeat{
		message_out <- paste(message, '(type "y" (if yes) or "n" (if no))\n')
		cat(message_out)
    f_in <- file("stdin")
		tmp <- readLines(f_in, 1)
		if(tmp == "y"){
      close(f_in)
			return(TRUE)
			break
		}else if(tmp == "n"){
      close(f_in)
			return(FALSE)
			break
		}
	}
}#=> logical

#ask char
#returns charactor vector (length = 1)
read.str <- function(message){
  message_out <- paste(message, "\n")
  cat(message_out)
  f_in <- file("stdin")
  str <- readLines(f_in, 1)
  close(f_in)
  return(str)
}#=> charactor
