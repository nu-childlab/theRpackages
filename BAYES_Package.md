# Bayes package
## BayesAnalysis_yepFormat
This function applies our Bayes analysis to a dataframe by applying the helper functions outlined below
* to data in "yep format" *or* to a dataframe and a "levels" file with hypothesis predictions 

## helper functions called 
#### general 
 1. list_to_recastformula
   * primarily called within helper functions for data recast 
     * generates the recast formula from a list of id.vars 

#### STEP 1: getting dataframe into correct format (Yeps/Nopes)
 1. makeYeps_fromLevels  
   *  This function generates data in "Yep format" from the dataframe and a levels file
      * compares the hypothesis-predictions in the levels file to subject responses and writes "yep" columns to data to indicate if response was hypothesis-consistent
   * called from **BayesAnalysis_yepFormat** by setting optional parameter *levels (default NULL)* to the levels dataframe
 * makeNopes_fromYeps
   * This function adds a "nope" column for each hypothesis (s.t. *hypothesis-inconsistent* response = 1)
     * based on the values in the "yep" columns (where hypothesis-consistent response = 1)
     * necessary for calculating the *likelihoods*

#### STEP 2: calculating Likelihoods 
 1. helper/single-hypothesis: calculate likelihood 
   * This function calculates the likelihoods of **one hypothesis** for use in our Bayes Analysis
   * returns dataset with likelihoods to the global environment
 * aggregate/all-hypotheses: allLikelihoods_yepformat
   * This function calculates the likelihoods **for each hypothesis in a list**
   * returns dataframe for each hypothesis with likelihoods by id.vars, and 1 merged dataframe for all hypotheses
   
#### STEP 3: calculating K Values
 1.  aggregate/all-hypotheses: allKValues
   * This function calculates KValues for **all hypothesis in a list**
     * k-values for each hypothesis in list: compares its likelihood (as the numerator), to likelihood of each other hypothesis in turn (as denominators).
     * then goes through all k-values and prints "1" to summary column for each hypothesis if **all k values** for the hypothesis > 3
   * NOTE: contains different function for calculating k-values for hypothesis than the cldl standalone calculateKValue 
     * because they have to be recursively appended together first so they aren't writing over each other when each is appended to the original dataframe
   
#### STEP 4: final dataframe, generate plots
 1. rearrangeSummarize
   * This function rearranges and summarizes the kvalue data for easier plotting
     * pulls only columns of interest into new dataframe 
     * creates "block" column combining each combo of id.vars into a block
     * adds winner column printing which hypothesis wins (k-value summary = 1) for each subject 
     * collapse across subjects for each block
 * BayesPlot
   * This function generates and formats Bayes Plot 
     
### alternative (unused) functions
 1. allLikelihoods_otherFormat
   * This function calculates the likelihoods of a hypothesis for use in our Bayes Analysis.
   * Takes hypothesis-consistent-response column names as parameter, so dataframe doesn't need to follow the "Yep" naming convention 
 *  standalone: calculateKValue
   * This function calculates Kvalues for **one hypothesis** (by comparing its likelihoods to all others)

## TODO 
1. check with EVENTS data & make necessary adjustments
  * "subj" v. "subject" issue
