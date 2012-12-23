#read number from commandline
read.nu <- function(message){
  print(message)
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
		message_out <- paste(message, '(type "y" (if yes) or "n" (if no))')
		print(message_out)
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