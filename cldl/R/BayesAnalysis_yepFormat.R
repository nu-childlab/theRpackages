#' A CLDL Function
#'
#' This function applies our Bayes Analysis to data (in YepFormat)
#' @param df the dataframe, must contain [hypothesis]Yep columns to indicate if response was consistent with each hypothesis. Be sure to include "randomYep" colunn if you want chance (default 50\%) as a hypothesis alternative. 
#' @param hypotheses the list of hypotheses (as strings)
#' @param list_id_vars the list of independent variables 
#' @param by_proportion defaults to FALSE: ggplot by number of subjects, if TRUE, plots by proportion of subjects
#' @param number_of_subjects default is NULL, value required if ggplotting by proportion
#' @param include_random default is TRUE, includes "random" as hypothesis alternative, and chance defualts to 50\% [change this in calculateLikelihood fxn]
#' @param start_from_levels default is TRUE, will combine levels and data files and create 'yeps' and then add randomYep column to data. if false, assumes this is already complete and yep columns already exist and analysis applied from that point
#' 
#' @return returns 'kdata' containing the k values, 'data3' containing summary and winner, 'data4' which collapses by block, 'data4.long' which melts to long format for graphing, and the Bayes plot 
#' @keywords Bayes Likelihood Kvalue 
#'
#' @examples 
#' BayesAnalysis_yepFormat(data, c("strong", "weak", "average", "X1biggest", "X2biggest"), c("subject", "mixing", "alignment"))
#' BayesAnalysis_yepFormat(data, c("strong", "weak", "average", "X1biggest", "X2biggest"), c("subject", "mixing", "alignment"), TRUE, 30)
#' BayesAnalysis_yepFormat(rawdata, c("strong", "weak", "average"), c("subject", "mixing", "alignment"), levels=read.csv("~/Desktop/lst2-levels-formerging.csv"))
#'
#' @export

BayesAnalysis <- function(data, hypotheses, list_id_vars, proportion=FALSE, number_of_subjects=NULL, levels=NULL) {
	library(cldl)
  #if starting from levels, makeyeps:
  if(!(is.null(levels))) {
	  makeYeps_fromLevels(data, levels, hypotheses)
    makeNopes_fromYeps(yepdata, hypotheses)
  } 
  #else starting with yeps, makenopes:
  else {
    makeNopes_fromYeps(data, hypotheses)
  }
	allLikelihoods_yepFormat(nopedata, list_id_vars, hypotheses)
	allKValues(ldata, hypotheses)
	rearrangeSummarize(kdata, list_id_vars, hypotheses)
	BayesPlot(data4.long, list_id_vars, proportion, number_of_subjects)

  
	
	rm(nopedata, envir=.GlobalEnv)
	if(exists("yepdata")){rm(yepdata, envir=.GlobalEnv)}
	if(exists("levels")){rm(levels, envir=.GlobalEnv)}
	
}