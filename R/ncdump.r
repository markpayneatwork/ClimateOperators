#' Extract metadata using ncdump
#'
#' ncdump is a utility provided when installing the NetCDF libraries that is very handy
#' for extracting metadata information from a netcdf file
#'
#' @param f Path to the netcdf file to process
#'
#' @return `ncdump.coordinates` returns a named list of the coordinates. `ncdump.time` returns just the
#' time dimension, if it exists
#' @export
#' @name ncdump
ncdump.coordinates <- function(f) {
    require(lubridate)
    #Get ncdump output
    ncdump <- system2("ncdump", sprintf("-ct %s",f),stdout=TRUE)
    #Drop everything up to and including data:
    dat <- ncdump[-c(1:grep("^data:",ncdump))]
    #Combine and split
    vars.l <- strsplit(paste0(dat,collapse=""),";")[[1]]
    vars.dat <- strsplit(vars.l,", ")
    vars.dat[[length(vars.dat)]] <- NULL  #Drop the last
    #Treat first item separately
    var.names <- sapply(vars.dat,function(x) gsub("^ (.+?) = .*$","\\1",x[1]))
    vars.dat <- lapply(vars.dat,function(x) gsub("^.* = (.*)$","\\1",x))
    #Convert time first
    names(vars.dat) <- var.names
    if("time" %in% var.names) {
      time.objs <- lubridate::parse_date_time(vars.dat$time,c("ymd","ymd H","ymd HMS"))
      if(any(is.na(time.objs))) stop(paste("Failed to parse some date-times strings:",
                                          paste(vars.dat$time[is.na(time.objs)],
                                                collapse=", ")))
      vars.dat$time <- time.objs
    }
    #Try to convert rest to numeric
    for(this.var in setdiff(var.names,"time")) {
      this.num <- as.numeric(vars.dat[[this.var]])
      if(!any(is.na(this.num))) { #Success!
        vars.dat[[this.var]] <- this.num
      }
    }

    return(vars.dat)
}

#' @export
#' @name ncdump
ncdump.times <- function(f) {
  all.coords <- ncdump.coordinates(f)
  return(all.coords$time)
}

#' @export
#' @name ncdump
ncdump <- function(f) {
  #Get ncdump output
  ncd <- system2("ncdump", sprintf("-h %s",f),stdout=TRUE)
  rtn <- paste(ncd,collapse="\n")
  cat(rtn)
  return(invisible(NULL))
}

