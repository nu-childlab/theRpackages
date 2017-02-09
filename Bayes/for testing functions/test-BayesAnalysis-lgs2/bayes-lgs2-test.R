#if starting from LEVELS
  levels <- read.csv("~/Desktop/lgs2-levels-formerging.csv")
  names(levels)[names(levels)=="X1biggest"] <- "X1biggestpx"
  names(levels)[names(levels)=="X2biggest"] <- "X2biggestpx"
  data <- read.csv("~/Desktop/lgs2_data.csv")
  hyps <- c("strong", "weak", "average", "X1biggest", "X2biggest", "random")
  ids <- c("subject", "mixing", "alignment")
  library(cldl)
  BayesAnalysis(data, hyps, ids, levels = levels)

  
#if starting from YEPS
  data <- read.csv("~/Desktop/lgs2-labeled.csv")
  data$randomYep <- data$value 
  hyps <- c("strong", "weak", "average", "X1biggest", "X2biggest", "random")
  ids <- c("subject", "mixing", "alignment")
  library(cldl)
  BayesAnalysis(data, hyps, ids)
  #or for proportion graph
    BayesAnalysis(data, hyps, ids, proportion=TRUE, number_of_subjects=30)




    
    
    

#if updates to package, run 
setwd("~/Box\ Sync/ORG-SCHOOL-WCAS-LINGUISTICS-WELLWOOD-LAB/technical\ tools/R/packages")
library(devtools)
install("cldl")
