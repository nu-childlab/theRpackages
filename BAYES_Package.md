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
