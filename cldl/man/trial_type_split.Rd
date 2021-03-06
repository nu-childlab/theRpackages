% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trial_type_split.R
\name{trial_type_split}
\alias{trial_type_split}
\title{A CLDL Function}
\usage{
trial_type_split(df, type_list = c("text", "single-stim", "survey-text"))
}
\arguments{
\item{df}{a dataframe in the global environment, or a filepath (string) to a csv}

\item{type_list}{specifies a list of trial_type values (as strings) to split/output datasets by; or defaults to c("text", "single-"stim", "survey-text")}
}
\value{
(1) writes .csvs to Data_preprocessed directory (creates or locates) for the datasets split by trial_type (2) returns those dataframes to the global environment
}
\description{
This function splits a dataframe or csv by trial_type and outputs separate dataframes/csvs according to type
}
\examples{
trial_type_split(data)
trial_type_split("~/Desktop/totalData.csv")
trial_type_split(data2, c("text", "single-stim"))
trial_type_split(dataIllu, c("survey-text", "survey-likert"))

}
\keyword{post-processing}
\keyword{split}
\keyword{survey}
\keyword{trial_type}
\keyword{type}

