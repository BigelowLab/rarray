#' Retrieve the example OISST data url
#'
#' @export
#' @return chr URL
oisst_example_url = function(){
  "http://psl.noaa.gov/thredds/dodsC/Datasets/noaa.oisst.v2.highres/sst.day.mean.2023.nc"
}


#' R6 Class Representing a NetCDF resource
#'
#' @export
#' @description A Rarr object provides accessors for dimension and variable data.
Rarr <- R6::R6Class("Rarr",
                   
  public = list(
    
    #' @field filename chr, the filename or URL (for OPeNDAP)
    filename = NULL,
    
    #' @field nc ncdf4, the ncdf4 object we are navigating
    nc = NULL,
    
    #' @field dims named list
    dims = NULL,
    
    #' @field vars named list
    vars = NULL,

    #' @description initialize
    #' @param filename chr, the filename or URL (for OPeNDAP)
    initialize = function(filename = oisst_example_url()) {
      self$filename <- filename[1]
      if (inherits(self$filename, "character")) self$open()
      
      self$dims = sapply(names(self$nc$dim),
          function(nm){ 
            Rdim$new(self$nc$dim[[nm]])
          }, simplify = FALSE)
      
      self$vars = sapply(names(self$nc$var),
                         function(nm){ 
                           Rvar$new(self$nc$var[[nm]])
                         }, simplify = FALSE)
    },
    
    #' @description Open the NetCDF resource
    open = function() {
      self$nc = ncdf4::nc_open(self$filename)
    },
    
    #' @description 
    #' Close the NetCDF resource (done automatically upon gargabe cleanup)
    close = function() {
      if (inherits(self$nc, "ncdf4")) ncdf4::nc_close(self$nc)
    },
    
    #' @description print a description of the object
    #' @param ... unused
    #' Print a long summary of the NetCDF object
    print = function(...){
      for (d in self$dims) print(d)
      for (v in self$vars) print(v)
    },
    
    #' @description  Dump a summary ala print.ncdf4
    dump = function(){
      print(self$nc)
    }
  ), # end of public methods
  
  private = list(
    finalize = function(){
      self$close()
    }
  ) # end of private methods
)