#' A CLDL Function
#'
#' This function vertically combines multiple csv datasets and saves dataframe to global environment and a csv to a 'data' folder in your current working directory
#' @param df a dataframe in the global environment, or a filepath (string) to a csv 
#' @param type_list specify a list of trial_type values (as strings) to ouput separate csvs/dataframes for, or leave default; default is set to c("text", "single-"stim", "survey-text")
#' @return returns dataframes corresponding to each specified trial_type (1) to global environment (2) writes .csvs to working directory
#' @keywords split separate survey trial_type type
#'
#' @examples 
#' trial_type_split(data)
#' trial_type_split("~/Desktop/totalData.csv")
#' trial_type_split(data2, c("text", "single-stim"))
#' trial_type_split(dataIllu, c("survey-text", "survey-likert"))
#'
#' @export

trial_type_split <- function(df, type_list = c("text", "single-stim", "survey-text")) {
  
  # 1. check if df is a filepath ("character") or dataframe ("list") 
  if(typeof(df)=="character"){
    setwd(dirname(df))
    df <- read.csv(df) # setwd() to df's parent for saving future data 
  } 
  
  # some setup 
  type <- "trial_type" # CLDL standard colname for types
  totalData <- data.frame() # empty dataframe for including data of type_list types
  
  # 2. validate that inputs in correct format 
  validate_inputs <- function() {
    # a. validate "trial_type" is col in df 
    if(type %in% names(df)) {
      # b. validate types in type_list exist in type col
      for (item in type_list) {
        if(item %in% df[[type]]) {
          # do nothing
        } else {
          print("ERR 1: one or more items in type_list were not found in dataframe")
          return(FALSE) 
        }
      }
    } 
    else {
      print("ERR 0: no column 'trial_type' found in dataframe, please name relevant column 'trial_type'")
      return(FALSE)
    }
    return(TRUE) # return true if this point reached (return false would break from fxn early)
  }
  # ==== call fxn, continue only if validations return true! ====
  if(validate_inputs() == FALSE){return(FALSE)} # return false breaks from the whole function early

  # 3. separate data frames based on the type list, create a dataframe name/variable 
  for(item in type_list){
    if(grepl("survey-text",item)){
       temp_name <- "surveyData" 
    } else if (grepl("single-stim",item)){
      temp_name <- "testData" 
    } else if (grepl("text", item)) {
      temp_name <- "instructions" 
    } else if (grepl("categorize", item)) {
      temp_name <- "trainingData"
    } else {
      temp_name <- paste(item, "Data", sep="") # if other type, just paste the type to Data
    }
      
    # b. create a dataframe for it by subsetting rows of that type
    temp_df <- df[which(df[[type]]==item),]
      
    # c. setup directory structure for exporting
    # create or locate 'data' directory structure in the pwd
    currDir <- getwd() 
    subDir <- "Data_processed"
    dir.create(file.path(currDir, subDir), showWarnings = FALSE) # create data dir if !exists
    # create sub directory for split data
    subDir_split <- paste("data_split",Sys.Date(),sep="_")
    dir.create(file.path(subDir, subDir_split), showWarnings = FALSE) # create if !exists
    # get filepath split directory for export
    filepath_split <- paste(currDir, subDir, subDir_split, sep="/")
    
    # d. export csv
    # add csv extension to name 
    exportName <- paste0(temp_name,".csv")
    # add filename.csv to the end of filepath so it can be used in write.csv as path
    filepath_split <- paste(filepath_split,exportName,sep="/")
    # write concatenated csv, leave off row numbers
    write.csv(temp_df, filepath_split, row.names=FALSE)
      
    # d. return dataframe to global environment
    assign(temp_name,temp_df,.GlobalEnv)
    
    # e. except instructions, add all the dataframes to 'totalData'
    if(temp_name!="instructions") {totalData <- rbind(totalData,temp_df)}
  }
  
  # total data
  exportName <- paste0("totalData",".csv")
  filepath_split <- paste(currDir, subDir, subDir_split, sep="/")
  filepath_split <- paste(filepath_split,exportName,sep="/")
  write.csv(totalData, filepath_split, row.names=FALSE)
}