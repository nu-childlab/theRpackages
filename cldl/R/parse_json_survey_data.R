#' A CLDL Function
#'
#' This function parses the json objects stored in one dataframe column (e.g. JsPsych survey data)
#' @param df the dataframe containing survey data
#' @param json_colname {string} the name of the column containing the json objects to parse 
#' @return returns dataframe to global environment with columns appended to contain the parsed/separated info from the json object
#' @keywords json survey parse
#'
#' @examples 
#' parse_json_survey_data(surveyData, "responses")
#'
#' @export

parse_json_survey_data <- function(df,json_colname) {
  parsedSurvey <- data.frame() # empty dataframe to append rows to
  getjson <- function(i, df, colname) {
    newrow <- df[i,colname]
    newrow <- as.character(newrow)
    newdf <- as.data.frame(jsonlite::fromJSON(newrow))
    parsedSurvey <<- rbind.data.frame(parsedSurvey, newdf)  # has to be globally assigned for this
  }
  lapply(1:nrow(df), function(x) getjson(x, df, json_colname))
  # Add these back to the original dataframe!!!! 
  
  parsedSurveyData <<- cbind(df, parsedSurvey)
}
