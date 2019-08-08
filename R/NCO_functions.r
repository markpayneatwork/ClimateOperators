#' NCO operators
#'
#' Provides an interface to the (external to R) NetCDF Operators (NCO)
#'
#' @name nco
#' @export
#' @param ... List of arguments to be converted to a text string
#' @param debug Doesn't run the command, but returns the command that would be run
#' @param defaults Character string supplying the defaults to be used by CDO
#' @details Default options for nco can be set at the system wide level
#'using the \code{set.nc.defaults()} command. Two of the most useful
#'of these include "--overwrite" (to overwrite files by default) and
#'"--netcdf4" to force NetCDF4 output. See the documentation of NCO for more.
set.nco.defaults <- function(defaults="") {
  options("nco.defaults"=defaults)
}

#' @export
#' @rdname nco
ncks <- function(...,debug=FALSE) {nco.cmd("ncks",...,debug=debug)}

#' @export
#' @rdname nco
ncwa <- function(...,debug=FALSE) {nco.cmd("ncwa",...,debug=debug)}

#' @export
#' @rdname nco
ncra <- function(...,debug=FALSE) {nco.cmd("ncra",...,debug=debug)}

#' @export
#' @rdname nco
ncrcat <- function(...,debug=FALSE) {nco.cmd("ncrcat",...,debug=debug)}

#' @export
#' @rdname nco
ncecat <- function(...,debug=FALSE) {nco.cmd("ncecat",...,debug=debug)}

#' @export
#' @rdname nco
nces <- function(...,debug=FALSE) {nco.cmd("nces",...,debug=debug)}

#' @export
#' @rdname nco
ncbo <- function(...,debug=FALSE) {nco.cmd("ncbo",...,debug=debug)}

#' @export
#' @rdname nco
ncdiff <- function(...,debug=FALSE) {nco.cmd("ncdiff",...,debug=debug)}

#' @export
#' @rdname nco
ncap2 <- function(...,debug=FALSE) {nco.cmd("ncap2",...,debug=debug)}

#' @export
#' @rdname nco
ncrename <- function(...,debug=FALSE) {nco.cmd("ncrename",...,debug=debug)}

#' @export
#' @rdname nco
ncatted <- function(...,debug=FALSE) {nco.cmd("ncatted",...,debug=debug)}


nco.cmd <- function(cmd,...,debug) {
  #Build command
  cmd.args <- paste(c(options("nco.defaults")$nco.defaults,
                      unlist(list(...))),collapse=" ")
  if(!debug) {

    run.time <- system.time(rtn <- system2(cmd,cmd.args))
    if(rtn!=0) stop( sprintf("%s command failed. Error message: %s",cmd,rtn))

    out.val <-paste(cmd,cmd.args)
    attr(out.val,"run.time") <- run.time["elapsed"]
  } else {
    out.val <- paste(cmd,cmd.args)

  }
  return(out.val)
}

