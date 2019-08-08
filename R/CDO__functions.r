#' Climate Data Operators (CDO)
#'
#' Provides an interface for running commands suitable for use with
#' the (externally installed) Climate Data Operators (CDO)
#' @param debug Doesn't run the command, but returns the command that would be run
#' @name cdo
#' @export
#' @examples
#' # What version of CDO am I running?
#' cdo("--version")
#'
#' # Select a variable from a CMIP5 model
#' # Note, to run this in the wild, remove the debug=TRUE argument
#' in.fname <- "tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
#' out.fname <- "foo.nc"
#' cdo("selvar",in.fname,out.fname,debug=TRUE)
#'
#' # Use the defaults and csl to build up a more complex argument
#' # Note, to run this in the wild, remove the debug=TRUE argument
#' in.fname <- "tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
#' out.fname <- "foo.nc"
#' set.cdo.defaults("--silent")
#' yrs <- seq(1950,2005,by=5) #Every fifth year
#' cdo(csl("selyear",yrs),in.fname,out.fname,debug=TRUE)
cdo <- function(...,debug=FALSE) {
  #Build command
  cmd.args <- ssl(options("cdo.defaults")$cdo.defaults,list(...))
  out.val <- paste("cdo",cmd.args)
  if(!debug) {
    run.time <- system.time(rtn <- system2("cdo",cmd.args))
    if(rtn!=0) stop( sprintf("CDO command failed. Error message: %s",rtn))
    attr(out.val,"run.time") <- run.time["elapsed"]

  }
return(out.val)
}

#'@export
#'@rdname cdo
#'@param defaults Character string supplying the defaults to be used by CDO
#'@details Default options for cdo can be set at the system wide level
#'using the \code{set.cdo.defaults()} command. Two of the most useful
#'of these include "-O" (to overwrite files by default) and "-s" to
#'silence the outputs of cdo. See the helpfiles of CDO for more.
set.cdo.defaults <- function(defaults="") {
  options("cdo.defaults"=defaults)
}

# Comma separated list
#
#' @details \code{csl} converts a set of arguments into a comma separated list
#' @rdname cdo
#' @export
csl <- function(...) {  #Comma separated arguments
  cmd <- paste(unlist(list(...)),collapse=",")
  return(cmd)
}

# Space separated arguments
#
#' @details \code{ssl} converts a set of arguments into a space separated list
#' @export
#' @rdname cdo
ssl <- function(...) {  #Comma separated arguments
  cmd <- paste(unlist(list(...)),collapse=" ")
  return(cmd)
}

#========================================================================
# CDO Grid Descriptor ####
#========================================================================
#' Create a CDO compatable grid descriptor
#'
#' Creates a grid descriptor that can be used by CDO in regridding operations
#' @param  x Provides information to define the grid
#' @export griddes
#' @name griddes
setGeneric("griddes",
           function(x, ...)
             standardGeneric("griddes")
)


#' @export
#'@rdname griddes
setMethod("griddes",signature(x="Raster"),
          function(x,...){
            #Start with the header
            str <- c("#",
                     sprintf("# %s",x@title),
                     "#")
            #Specify lonlat grid
            str <- c(str,"gridtype = lonlat",
                     sprintf("gridsize = %i",ncell(x)),
                     "xname = lon",
                     "xlongname = longitude",
                     "xunits = degrees_east",
                     "yname = lat",
                     "ylongname=latitude",
                     "yunits = degrees_north")
            #Specify grid size and resolution
            str <- c(str,
                     sprintf("xsize = %i",ncol(x)),
                     sprintf("ysize = %i",nrow(x)))
            #Get coordinates information
            pts <- coordinates(x)
            str <- c(str,
                     sprintf("xfirst = %f",min(pts[,1])),
                     sprintf("xinc = %f",res(x)[1]),
                     sprintf("yfirst = %f",min(pts[,2])),
                     sprintf("yinc = %f",res(x)[2]) )
            return(str)
          })


#' @export
#'@rdname griddes
#' @param  res  The resolution of the grid (single number of vector of two numbers)
setMethod("griddes",signature(x="Extent"),
          function(x,res=1,...){
            r <- raster(x)
            res(r) <- res
            return(griddes(r))
          })

