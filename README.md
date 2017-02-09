# theRpackages
cldl R packages for abstracting analyses and data visualization


# cldl

### TODO functions

# quantm
### quantm_stats
1. This function combines calls to quantm_resid and quantm_mm to run all stats on **1 factor (log and raw)**

##### helper functions
1. quantm_resid
  * this function creates dataframes with **log and raw** resids for 1 factor 
* quantm_mm
  * this function generates maximal models and writes model comparisons to a file for 1 **dataframe** 

### TODO functions
1. quantm_graphing
  * abstract plotting functions so it generates 4 sets of plots in 4 folders
    * raw/log x include/exclude outliers
  * look at the commented "wouldn't it be cool" seciton
    * log calc inside function failed 

# Other Files
* how to make a package.R
  * instructions for making your own package 
  * see also, theRpackage tutorial 
