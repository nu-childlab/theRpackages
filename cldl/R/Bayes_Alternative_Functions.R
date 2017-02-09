#' A CLDL Function
#'
#' This function calculates the likelihoods of a hypothesis for use in our Bayes Analysis
#' @param data the dataset; each hypothesis requires a column where hypothesis-consistent response = 1 else 0, and a column for inconsistent = 1, for each hypothesis
#' @param list_id_vars the list of independent variables for the recast function (list of strings)
#' @param list_of_hypotheses the list of hypotheses. each requires a list of the same name in R with the corresponding hyp-consistent and hyp-inconsistent column names 
#' @return returns dataframe for each hypotehsis with likelihoods by ID variables, and 1 merged df with all hypotheses
#' @keywords Bayes likelihood 
#'
#' @examples 
#' strong <- c("strongYep", "strongflop"); weak <- c("weakYep", "weakflop"); allLikelihoods_otherFormat(data, c("subject", "block"), c("strong", "weak"))
#' 
#'
#' @export

allLikelihoods_otherFormat <- function(data, list_id_vars, list_of_hypotheses) {

  # function to calculate likelihood for each hypothesis (with added feature of constructing the yep/nope colnames from the hypothesis name)
  getLikelihood <- function (data, list_id_vars, hypothesis, hypothesisName) {
    cldl::calculateLikelihood(data, list_id_vars, hypothesis[1], hypothesis[2], hypothesisName)
  }
  # calculate the likelihood for each hypothesis in the list
  lapply(list_of_hypotheses, function(x) getLikelihood(data, list_id_vars, get(x), x))
  # merge the list of dataframes once all are created
  listdf<- lapply(list_of_hypotheses, function(x) paste(x,"data",sep=""))
  data2 <- Reduce(function(x,y) merge(x,y,by=list_id_vars), lapply(listdf, function(x) get(x)))
  assign("data2", data2, .GlobalEnv)
}




#' A CLDL Function
#'
#' This function calculates Kvalues for one hypothesis (by comparing its likelihoods to all others), for use in our Bayes Analysis
#' @param df the dataframe, must contain the likelihoods for all hypotheses
#' @param first_hypothesis the hypothesis for the numerator (to compare to all others)
#' @param rest_hypotheses the list of the other hypotheses to compare to
#' @return returns dataframe containing the k values
#' @keywords kvalue bayes hypothesis
#'
#' @examples 
#' calculateKValue(data2, "weak", c("X1biggest", "average"))
#' calculateKValue(data2, "strong", c("weak", "average", "X1biggest", "X2biggest"))
#'
#' @export


calculateKValue <- function(df, first_hypothesis, rest_hypotheses) {
  attach(df)
  
  # construct columnnames as strings
  cols <- lapply(rest_hypotheses, function(x) paste("K",first_hypothesis,x,sep=""))
 
   # obtain likelihoods for comparisons
  getLikelihood <- function(hypothesis) {
    get(paste("likelihood",hypothesis,sep="")) #get the numerical values 
  }
  likelihoodfirst <- getLikelihood(first_hypothesis)
  likelihoodrest <- lapply(rest_hypotheses, function(x) getLikelihood(x))
  
  # compare likelihoods
  kvalue <- as.data.frame(lapply(likelihoodrest, function(x) (with(df, likelihoodfirst/x))))
  # rename the kvalue columns
  colnames(kvalue) <- cols
  
  # print 1 to summary column if all k values for this hypothesis are greater than 3
  summarycolname <<-paste(first_hypothesis, "Hyp", sep="")
  summarycol <- as.data.frame(ifelse(Reduce('&', lapply(cols, function(x) kvalue[x]>3)), 1, 0))
  colnames(summarycol) <- summarycolname
  kvalue <- cbind(kvalue, summarycol)
  
  # add the kvalue columns to the dataframe 
  kdata <- cbind(df, kvalue)
  
  assign("kdata", kdata, .GlobalEnv)
  detach()
}



