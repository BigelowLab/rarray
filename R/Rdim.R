#' R6 Class Representing a NetCDF dimension attribute
#'
#' @export
#' @description
#' A Rdim object provides accessors for dimension data
Rdim <- R6::R6Class("Rdim",
  public = list(
    #' @field ncdim4 list 
    ncdim4 = NULL,
   
    #' @description intialize
    #' @param x ncdim4 object (it's a list)
    initialize = function(x) {
      stopifnot(inherits(x, "ncdim4"))
      self$ncdim4 = x
    },
  
    #' @description 
    #' Print a long summary of the NetCDF dimensions
    #' @param ... unused 
    print = function(...){
      n = self$len
      cat("dimension name:" , self$name, "  units:", self$units, "  length:", n, "\n")
      hi = seq_len(3)
      ti = n - rev(hi)
      v = self$vals
      h = paste(v[hi], collapse = ", ")
      t = paste(v[ti], collapse = ", ")
      cat("  vals:", h, " ... ", t, "\n")
    } ), # end of public methods
                   
                  
                   
  active = list(
    #' @field name dimension name
    name = function(){
      self$ncdim4$name
    },
    #' @field units dimension units
    units = function(){
      self$ncdim4$units
    },
    #' @field vals dimension values (vector)
    vals = function(){
      v = if (self$name == "time"){
        v = parse_time(self$ncdim4)
      } else {
        self$ncdim4$vals
      }
      v
    },
      
    #' @field len length of the dimension
    len = function(){
      self$ncdim4$len
    }
  ) # end of active list
                   
)


#' Parse the epoch
#' 
#' @param x the "units string value form a `ncdim4` object
#' @return list with time (POSIXct), unit, and multiplier
parse_epoch = function(x = "days since 1800-01-01 00:00:00"){
 xx = strsplit(x, " ", fixed = TRUE)[[1]]
 time0 = as.POSIXct(paste0(xx[3:4], collapse = "T"), 
                    format = "%Y-%m-%dT%H:%H:%S",
                    tz = "UTC")
 list(time = time0,
      units = xx[1],
      multiplier = switch(xx[1],
                          "days" = 3600*24,
                          "hours" = 3600,
                          "seconds" = 1))
}
  
  
  
#' Parse the time 
#' 
#' Time if denoted in the time$units element.  It the the form
#'  "UNITS since EPOCH"
#' 
#' @param x ncdim4 class object with name time
#' @return POSIXct
parse_time = function(x){
  stopifnot(inherits(x, 'ncdim4') && (x$name == "time")) 
  epoch = parse_epoch(x$units)
  x$vals * epoch$multiplier + epoch$time
}

