#' A CLDL Function
#'
#' reshapes dataframe from wide(1 subject per line) to long format (1 variable/value per line)
#' @param filepath filepath of the dataset 
#' @param list_of_id_vars variables identifying invididual rows of data 
#' @param variable_name string: column name for possible variable types 
#' @param value_name string: column name for the value of those variables 
#' @return returns reshaped dataset to global environment
#' @keywords reshape wide long melt
#'
#' @examples 
#' reshape_long("/Users/caseycolby/Desktop/gleebest2-data.csv", c("subj", "date", "cond", "DOB", "Age", "tr1", "tr2", "tr3"), card_number, response)
#'
#' @export


reshape_long<- function(filepath, list_of_id_vars, variable_name = NULL, value_name = NULL) {
  # read in original file, 1 subject per line
  data <- read.csv(filepath)
  # reshape with 'melt' so 1 trial per line 
  # id.vars 
  # rename 'value' (dependent variable) and 'variable' column names
  data <- reshape2::melt(data, id.vars = list_of_id_vars, variable.name = variable_name, value.name = value_name)

  assign("data", data, .GlobalEnv)
}