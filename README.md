rray
================

An R package to explore easy access to NetCDF data sources modeled after
the super convenient [xarray](https://xarray.dev/). The desired outcomes
are

- ease of exploration of NetCDF contents

- ease of extracting to georeferenced objects (sf, stars, terra)

# Requirements

- [R v4.1+](https://www.r-project.org/)
- [rlang](https://CRAN.R-project.org/package=rlang)
- [ncdf4](https://CRAN.R-project.org/package=ncdf4)
- [R6](https://CRAN.R-project.org/package=R6)
- [sf](https://CRAN.R-project.org/package=sf)
- [stars](https://CRAN.R-project.org/package=stars)
- [tidync](https://CRAN.R-project.org/package=tidync)
- [dplyr](https://CRAN.R-project.org/package=dplyr)

# Installation

    remotes::install_github("BigelowLab/rarr")

``` r
suppressPackageStartupMessages({
  library(rray)
  library(tidync)
  library(stars)
})

url = oisst_example_url()
```

## Path 1: rolling up an R6 package

``` r
X = Rarr$new(url)
X
```

    ## dimension name: time   units: days since 1800-01-01 00:00:00   length: 365 
    ##   vals: 2023-01-01, 2023-01-02, 2023-01-03  ...  2023-12-28, 2023-12-29, 2023-12-30 
    ## dimension name: lat   units: degrees_north   length: 720 
    ##   vals: -89.875, -89.625, -89.375  ...  89.125, 89.375, 89.625 
    ## dimension name: lon   units: degrees_east   length: 1440 
    ##   vals: 0.125, 0.375, 0.625  ...  359.125, 359.375, 359.625 
    ## variable name: sst   units: degC   longname: Daily Sea Surface Temperature 
    ##   dims:  lon, lat, time [1440, 720, 365]

## Path 2: using tidync

``` r
Y = tidync(url)
```

    ## not a file: 
    ## ' http://psl.noaa.gov/thredds/dodsC/Datasets/noaa.oisst.v2.highres/sst.day.mean.2023.nc '
    ## 
    ## ... attempting remote connection

    ## Connection succeeded.

``` r
Y
```

    ## 
    ## Data Source (1): sst.day.mean.2023.nc ...
    ## 
    ## Grids (4) <dimension family> : <associated variables> 
    ## 
    ## [1]   D2,D1,D0 : sst    **ACTIVE GRID** ( 378432000  values per variable)
    ## [2]   D0       : time
    ## [3]   D1       : lat
    ## [4]   D2       : lon
    ## 
    ## Dimensions 3 (all active): 
    ##   
    ##   dim   name  length      min    max start count     dmin   dmax unlim coord_dim 
    ##   <chr> <chr>  <dbl>    <dbl>  <dbl> <int> <int>    <dbl>  <dbl> <lgl> <lgl>     
    ## 1 D0    time     365  8.14e+4 8.18e4     1   365  8.14e+4 8.18e4 TRUE  TRUE      
    ## 2 D1    lat      720 -8.99e+1 8.99e1     1   720 -8.99e+1 8.99e1 FALSE TRUE      
    ## 3 D2    lon     1440  1.25e-1 3.60e2     1  1440  1.25e-1 3.60e2 FALSE TRUE
