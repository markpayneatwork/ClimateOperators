# ClimateOperators

by Mark R. Payne<br>
http://www.staff.dtu.dk/mpay <br>
@MarkPayneAtWork

An R package containing wrappers to the Climate Data Operators (CDO) and the NetCDF Operators (NCO)

## Dependencies
ClimateOperators acts as an R wrapper around the CDO and NCO packages - you will to download and install these from the relevant webpages first:

* https://code.mpimet.mpg.de/projects/cdo/ 
* http://nco.sourceforge.net/ 

Make sure that these are available in your system path. 

Generally, ClimateOperators (and CDO and NCO) are intended to be used on Unix-like platforms. I expect that the package should also work on Windows and MacOS, but please note that it is untested there - *caveat emptor*. Installing CDO and NCO on these platforms is also tricky - Unix-like platforms are recommended for this type of work.

## Installation

You can install this package directly from the GitHub repository using the following command:

```{R}
devtools::install_github("markpayneatwork/ClimateOperators")
```

## Some CDO examples

The underlying principle of ClimateOperators is that it allows you to quickly and easily build and run CDO/NCO commands from within R. It helps to be familar with these various tools - the documentation for both is excellent, so I suggest making sure you're familar with that.

Here are some basic examples to get you started.

Firstly, all commands attempt to run a command by calling the relevant CDO / NCO binary. This behaviour can be overwritten using the debug option, which compiles the command (but does not run it) e.g.

```{R}
cdo("--version",debug=FALSE)
```

Omitting the argument, runs the command
```{R}
cdo("--version")
```

The remaining examples include the debug=TRUE command by default - in a real world situation you would remove this option. CDO commands are then built up as command line arguments
```{R}
cdo("sinfo","tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc",debug=TRUE)
```
This lends itself nicely to programming:
```{R}
in.fname <- "tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
out.fname <- "foo.nc"
cdo("selvar,tos",in.fname,out.fname,debug=TRUE) 
```
You can always see the command that has been built up (without running it) using the debug command
```{R}
in.fname <- "tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
out.fname <- "foo.nc"
cdo("selvar,tos",in.fname,out.fname,debug=TRUE) 
```
CDO (and NCO) often base their arguments on the back of comma-separated or space-separated lists. These can be built quickly and easily using the csl() and ssl() commands respectively. Putting this together makes for a more realistic CDO command:
```{R}
in.fname <- "tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
out.fname <- "foo.nc"
var <- "tos"
cdo(csl("selvar",var),in.fname,out.fname,debug=TRUE) 
```

Default (system-wide) options to CDO and NCO can also be supplied e.g.
```{R}
set.cdo.defaults("--silent")
in.fname <- "tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
out.fname <- "foo.nc"
var <- "tos"
cdo(csl("selvar",var),in.fname,out.fname,debug=TRUE) 
```

## Some NCO examples

NCO is conceptually identical, except there are functions for each of the operators.
```{R}
set.nco.defaults("--overwrite")
in.fname <- "tos_Omon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
out.fname <- "foo.nc"
ncra(in.fname,out.fname,debug=TRUE) 
ncwa(in.fname,out.fname,debug=TRUE) 
```
## More help

For more help, see the list of supported functions in the package help
```{R}
help(package="ClimateOperators")
```
Questions, queries, comments or theories are always welcome via the GitHub repository. Push-requests are especially welcome!
