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

### error_bars
1. This function adds error bars to a ggplot using the summarySE function 
  * returns new plot to global environment and saves it as .png to a plots directory (it creates new or locates existing) in current wd
    * setwd() to relevant location before calling

### TODO functions

1. function for cldl's standard/agreed upon **graph-formatting**
  * easiliy add to bar or line plot 
  * check out AW illusions analysis (2 functions noted for CC)
* function to add **error bars** to plot
  * also: AW comparing cldl's current error bar fxn and one used preivously to see if any differences and which one better. 
* function that **concatenates files and splits based on trial type** (survey, scale, etc.)
  * see RW Illusions code
