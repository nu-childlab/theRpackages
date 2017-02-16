#' A CLDL Function
#'
#' This function combines calls to multimerge_vertical_csv and trial_type_split to merge a directory of .csvs and split the concatenated dataset into separate dataframes by trial_type 
#' @param folder_path folder_path path to folder containing individual .csv files, requires they have the same columns
#' @param type_list specifies a list of trial_type values (as strings) to split/output datasets by; or defaults to c("text", "single-"stim", "survey-text")
#' @return (1) writes .csvs to Data_preprocessed directory (creates or locates) for the datasets split by trial_type (2) returns those dataframes to the global environment 
#' @keywords merge concatenate split separate survey trial_type type post-processing
#'
#' @examples 
#' trial_type_split(data)
#' trial_type_split("~/Desktop/totalData.csv")
#' trial_type_split(data2, c("text", "single-stim"))
#' trial_type_split(dataIllu, c("survey-text", "survey-likert"))
#'
#' @export

merge_and_split <- function(folder_path, type_list = c("text", "single-stim", "survey-text")) {
  cldl::multimerge_vertical_csv(folder_path)
  # writes .csvs to data_preprocessed and setwd() to its parent  
  # returns totalData to .GlobalEnv
  cldl::trial_type_split(totalData,type_list)
}

merge_and_split("~/Desktop/lgs2est")