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

