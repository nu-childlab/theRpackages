#' A CLDL Function
#'
#' This function vertically combines multiple csv datasets and optionally exports the complete dataset to csv on your machine
#' @param folder_path path to folder containing individual datasets
#' @param export_path = NULL optional path/filename if you want to export the complete csv to that location
#' @return returns complete dataset to global environment
#' @keywords merge 
#'
#' @examples 
#' multimerge_vertical_csv("/Users/cec804/Desktop/themostData_6-29-16", "/Users/cec804/Desktop/themost_completeData_6-29-16.csv")
#' multimerge_vertical_csv("/Users/caseycolby/Desktop/themostData_6-29-16")
#'
#' @export


 multimerge_vertical_csv <- function(folder_path, export_path = NULL) {
   
   combine <- function(folder_path) {
    #create list of data frame filenames
    filenames <- list.files(path = folder_path, full.names = TRUE)
    #create list of data frames by reading in the data at each filename
    datalist <- lapply(filenames, function(x) 
    {read.csv(file=x, header=TRUE)})
    #Reduce applies function to a list of data frames
    #rbind combines vertically by rows into a single dataframe
    Reduce(function(x,y) {rbind(x,y)}, datalist)
   }
   
   #save the combined dataset to workspace
   completedata <- combine(folder_path)
   assign("data", completedata, .GlobalEnv)
 
   if(is.null(export_path)){
   	print("optional: include second argument path/name.csv to export complete dataset")
   } else {
    #export complete dataset to a new filepath, leave off the row numbers 
   	write.csv(completedata, export_path, row.names=FALSE)
   }
   
}