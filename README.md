# theRpackages
cldl R packages for abstracting analyses and data visualization


# cldl package
### multimerge_vertical_csv
1. This function vertically combines all csvs in a directory (if columns match) 
   *and optionally exports the complete dataset to csv on your machine

### reshape_long
1. This function quickly reshapes dataframe from wide (1 subject per line) to long format (1 variable/value per line)

### correct_col (correct_column.R)
1. This function compares values across two specified columns of a dataset, row by row, to create/update values in a "correct" column. 
   * correct <- **1** if the two columns match values for that row
   * else, correct <- **0**

### TODO functions

# quantm package
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

# Bayes package
### BayesAnalysis_yepFormat
1. This function applies our Bayes analysis to a dataframe by applying the helper functions outlined below
  * data must begin in Yep format, else you must start with (1) data file and (2) an auxilary "levels" file

   ##### helper functions
   1. makeYeps_fromLevels  
     *  This function generates data in "Yep format" from the dataframe and a levels file
        * compares the hypothesis-predictions in the levels file to subject responses and writes "yep" columns to data to indicate if response was hypothesis-consistent
     * called from **BayesAnalysis_yepFormat** by setting optional parameter *levels (default NULL)* to the levels dataframe
   * makeNopes_fromYeps
     * 
   * allLikelihoods_yepformat
     * 
   * allKValues
     * 
   * rearrangeSummarize
     * 
   * BayesPlot
     * 
     
   ##### alternative (unused) functions
   1. allLikelihoods_otherFormat
     * This function calculates the likelihoods of a hypothesis for use in our Bayes Analysis.
     * Takes hypothesis-consistent-response column names as parameter, so dataframe doesn't need to follow the "Yep" naming convention 
   * calculateKValue
     * This function calculates Kvalues for one hypothesis (by comparing its likelihoods to all others)

### TODO 
1. check with EVENTS data & make necessary adjustments
  * "subj" v. "subject" issue

# Other Files
* how to make a package.R
  * instructions for making your own package 
  * see also, theRpackage tutorial 
