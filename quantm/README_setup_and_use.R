###### setup #####
# read in the data / setwd() etc
current <- "~/Desktop"
dataloc <- paste0(current,"/quantm1-data-transformed.csv")

qdata <- read.csv(dataloc)
setwd(current)

## contrast coding for factors
qdata$subjCode <- ifelse(qdata$NPsubj=="existential",-.5,.5)
qdata$objCode <- ifelse(qdata$NPobj=="universal",-.5,.5)

###### function calls #####
# e.g. run quantm stats on one factor 
quantm_stats("TFT",qdata,c(0,1,2))
quantm_stats(c("RPD","FPRT"),qdata,c(0,1,2))
# e.g. run quantm stats on all factors
factors <- c("FPRT", "TFT", "RPD")
lapply(factors, function(x) quantm_stats(x, qdata, c(0,1,2)))



