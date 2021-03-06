% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BayesAnalysis_HelperFunctions.R
\name{allKValues}
\alias{allKValues}
\title{A CLDL Function}
\usage{
allKValues(df, list_of_hypotheses)
}
\arguments{
\item{df}{the dataframe, with likelihoods already calculated for each hypothesis [and listed in columns named likelihoood[hypothesis]]}

\item{list_of_hypotheses}{the list of hypotheses to calculate K Values over}
}
\value{
returns dataframe 'kdata' with K values for each hypothesis compared to all others
}
\description{
This function calculates the K values for all hypotheses for use in our Bayes Analysis
}
\examples{
allKValues(data3, c("strong", "weak", "average"))
allKValues(data3, c("strong", "weak", "average", "X1biggest", "X2biggest"))

}
\keyword{Bayes}
\keyword{KValue}

