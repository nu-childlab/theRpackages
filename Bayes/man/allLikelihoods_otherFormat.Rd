% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Bayes_Alternative_Functions.R
\name{allLikelihoods_otherFormat}
\alias{allLikelihoods_otherFormat}
\title{A CLDL Function}
\usage{
allLikelihoods_otherFormat(data, list_id_vars, list_of_hypotheses)
}
\arguments{
\item{data}{the dataset; each hypothesis requires a column where hypothesis-consistent response = 1 else 0, and a column for inconsistent = 1, for each hypothesis}

\item{list_id_vars}{the list of independent variables for the recast function (list of strings)}

\item{list_of_hypotheses}{the list of hypotheses. each requires a list of the same name in R with the corresponding hyp-consistent and hyp-inconsistent column names}
}
\value{
returns dataframe for each hypotehsis with likelihoods by ID variables, and 1 merged df with all hypotheses
}
\description{
This function calculates the likelihoods of a hypothesis for use in our Bayes Analysis
}
\examples{
strong <- c("strongYep", "strongflop"); weak <- c("weakYep", "weakflop"); allLikelihoods_otherFormat(data, c("subject", "block"), c("strong", "weak"))


}
\keyword{Bayes}
\keyword{likelihood}

