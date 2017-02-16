# cldl package

### reshape_long
1. This function quickly reshapes dataframe from wide (1 subject per line) to long format (1 variable/value per line)

### correct_col (correct_column.R)
1. This function compares values across two specified columns of a dataset, row by row, to create/update values in a "correct" column. 
   * correct <- **1** if the two columns match values for that row
   * else, correct <- **0**

### error_bars
1. This function adds error bars to a ggplot 
  * using the summarySE function from Cookbook for R (found here: http://www.cookbook-r.com/Manipulating_data/Summarizing_data/)
  * **returns** new plot to global environment and saves it as .png to a plots directory (it creates new or locates existing) in current wd
    * setwd() to relevant location before calling

## merge_and_split
1. Merges all .csvs in a directory *and* splits concatenated dataset into dataframes by trial_type
  * combines calls to **multimerge_vertical_csv** and **trial_type_split**
  * **returns** datasets (concatenated & split by type) to RStudio Global Environment and writes .csvs to 'Data_processed' directory (creates or locates directory) 
  * **parameter 1**: a path to the directory containing .csvs (requires that all .csvs have the same columns)
  * **parameter 2**: a list of "trial_type" values to split by
    * if you leave this parameter empty, **defaults to c("text", "single-stim", "survey-text")**
    
### multimerge_vertical_csv
1. This function vertically combines all csvs in a directory (if columns match) 
   * saves dataframe to global environment 
   * saves .csv to a 'data_datestamp' folder (locates or creates) in the parent directory of the original directory

### trial_type_split
1. This function splits a dataframe or .csv by specified trial_types and outputs separate dataframes/csvs for each (survey, scale, text, etc.)
  * **parameter 1**: a dataframe in the global environment or a filepath to a .csv on your machine 
  * **parameter 2**: a list of values for "trial_type" to split upon. 
    * if you leave this parameter empty, **defaults to c("text", "single-stim", "survey-text")**
  
### TODO functions

1. function for cldl's standard/agreed upon **graph-formatting**
  * easiliy add to bar or line plot 
  * check out AW illusions analysis (2 functions noted for CC)
