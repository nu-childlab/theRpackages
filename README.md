# theRpackages
cldl R packages for abstracting analyses and data visualization


# cldl
### functions

### TODO functions

# quantm
### functions 
#### quantm_stats
This function combines calls to quantm_resid and quantm_mm to run all stats on **1 factor (log and raw)**

##### helper functions
* quantm_resid
  * this function creates dataframes with **log and raw** resids for 1 factor 
* quantm_mm
  * this function generates maximal models and writes model comparisons to a file for 1 **dataframe** 


### included files 
1. sample data input
  * quantm1-data-transformed.csv
2. sample stats output 
  * sample log and raw output files for 3 factors in sample input 

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
