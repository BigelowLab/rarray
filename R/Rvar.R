#' R6 Class Representing a NetCDF variable attribute
#'
#' @export
#' @description
#' A Rdim object provides accessors for variable data
Rvar = R6::R6Class("Rvar",
                   
  public = list(
    #' @field ncvar4 ncvar4 class object (it's a list)
    ncvar4 = NULL,
    
    #' @description intialize
    #' @param x ncvar4 object (it's a list)
    initialize = function(x) {
      stopifnot(inherits(x, "ncvar4"))
      self$ncvar4 = x
    },
    
    #' @description 
    #' Print a long summary of the NetCDF variable
    #' @param ... unused
    print = function(...){
      dimnames = paste(self$dimnames, collapse = ", ")
      dims = paste0( self$size, collapse = ", ")
      
      cat("variable name:" , self$name, "  units:", self$units, "  longname:", self$longname, "\n")
      cat("  dims: ", sprintf("%s [%s]", dimnames, dims), "\n")
    }
    
  ),
  active = list(
    #' @field name variable name
    name = function() self$ncvar4$name,
    #' @field ndims number of dims
    ndims = function() self$ncvar4$ndims,
    #' @field size dim sizes
    size = function() self$ncvar4$size,
    #' @field units variable units
    units = function() self$ncvar4$units,
    #' @field longname variable long name
    longname = function() self$ncvar4$longname,
    #' @field dimnames dimension names
    dimnames = function(){
      sapply(self$ncvar4$dim, function(d) d$name)
    })   # end of active
)