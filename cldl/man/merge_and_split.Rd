% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/merge_and_split.R
\name{merge_and_split}
\alias{merge_and_split}
\title{A CLDL Function}
\usage{
merge_and_split(folder_path, type_list = c("text", "single-stim",
  "survey-text"))
}
\arguments{
\item{folder_path}{folder_path path to folder containing individual .csv files, requires they have the same columns}

\item{type_list}{specifies a list of trial_type values (as strings) to split/output datasets by; or defaults to c("text", "single-"stim", "survey-text")}
}
\value{
(1) writes .csvs to Data_preprocessed directory (creates or locates) for the datasets split by trial_type (2) returns those dataframes to the global environment
}
\description{
This function combines calls to multimerge_vertical_csv and trial_type_split to merge a directory of .csvs and split the concatenated dataset into separate dataframes by trial_type
}
\examples{
merge_and_split("~/Desktop/lgs2est")
merge_and_split("~/Desktop/lgs2est", c("survey-text", "single-stim"))

}
\keyword{concatenate}
\keyword{merge}
\keyword{post-processing}
\keyword{separate}
\keyword{split}
\keyword{survey}
\keyword{trial_type}
\keyword{type}

