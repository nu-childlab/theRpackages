#' A CLDL Function
#'
#' This function compares values across two specified columns of a dataset, row by row, to create/update values in a 'correct' column. 'correct' is assigned a 1 if the two columns match values for that row, else a 0. 
#' @param data the original dataset 
#' @param col1 the first column name for comparison
#' @param col2 the second column name for comparison
#' @param new_dataset the name for the new dataset, as a string 
#' @return returns a new dataset to the global environment with the 'correct' column appended
#' @keywords correct compare column 1s 0s 
#'
#' @examples 
#' correct_col(data2, data2$tr2, data2$tr3, "data3")
#' correct_col(data, data$response, data$expected, "data2")
#' 
#' 
#' @export


correct_column <- function(data, col1, col2, new_dataset) {
  for (i in 1:nrow(data)) {
    if (col1[i] == col2[i]) {
      data$correct[i] <- 1
    } else {
      data$correct[i] <- 0
    }
  }
  
  assign(new_dataset, data, .GlobalEnv)
}
