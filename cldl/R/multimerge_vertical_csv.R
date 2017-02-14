#' A CLDL Function
#'
#' This function vertically combines multiple csv datasets and saves dataframe to global environment and a csv to a 'data' folder in your current working directory
#' @param folder_path path to folder containing individual datasets
#' @return returns complete dataset to global environment
#' @keywords merge 
#'
#' @examples 
#' multimerge_vertical_csv("/Users/cec804/Desktop/themostData_6-29-16")
#' multimerge_vertical_csv("/Users/caseycolby/Desktop/themostData_6-29-16")
#'
#' @export


 multimerge_vertical_csv <- function(folder_path, export_path = NULL) {
   
   combine <- function(folder_path) {
    # create list of data frame filenames
    filenames <- list.files(path = folder_path, full.names = TRUE)
    # create list of data frames by reading in the data at each filename
    datalist <- lapply(filenames, function(x) 
    {read.csv(file=x, header=TRUE)})
    # Reduce applies function to a list of data frames
    # rbind combines vertically by rows into a single dataframe
    Reduce(function(x,y) {rbind(x,y)}, datalist)
   }
   
   # save the combined dataset to workspace
   completedata <- combine(folder_path)
   assign("data_concat", completedata, .GlobalEnv)
   
   
   #===exporting csv and setting up directory structure====
   
   # setwd() to folder_path's parent
   setwd(dirname(folder_path))
   # create or locate 'data' directory structure in the pwd
   currDir <- getwd()
   subDir <- paste("data", Sys.Date(), sep="_")
   dir.create(file.path(currDir, subDir), showWarnings = FALSE) # create data dir if !exists
   # create sub directories for rawData (individual csvs) and concatenated data (1 csv)
   subDir_raw <- "raw_csvs"
   subDir_concat <- "concat"
   dir.create(file.path(subDir, subDir_raw), showWarnings = FALSE) # create if !exists
   
   # get filepath to those directories for export
   filepath_raw <- paste(currDir, subDir, subDir_raw, sep="/")
   filepath_concat <- paste(currDir, subDir, sep="/")
   # add filename to the end of filepath_concat so it's proper write.csv export path
      # create datestamped name for concatenated data csv and add csv extension
      concatName <- paste("complete-data", Sys.Date(), sep="_")
      concatName <- paste0(concatName,".csv")
   filepath_concat <- paste(filepath_concat,concatName,sep="/")
   
   # write concatenated csv, leave off row numbers
   write.csv(completedata, filepath_concat, row.names=FALSE)
   # copy original directory with raw csvs to 'raw csvs' subfolder so everythign is present and organized! 
   file.copy(folder_path, filepath_raw, recursive=TRUE)
   
}