


allKValues <- function(df, list_of_hypotheses) {
  #get the different combinations of hypotheses
  chunk_list <- function(list, index) {
    first <- list[index]
    rest <- list[-index] # negative means list without item at that index
    result <- (c(first, rest))
    return(result)
  }
  indices <- c(1:length(list_of_hypotheses))
  chunks <- lapply(indices, function(x) chunk_list(list_of_hypotheses,x))
  
  # use those to calculate k values with each hypothesis as the numerator
  # different function than the cldl standalone calculateKValue 
  # because they have to be recursively appended together first so they aren't writing over each other when each is appended to the original dataframe
  calculateKValue <- function(df, first_hypothesis, rest_hypotheses) {
    attach(df)
    # construct columnnames as strings
    cols <<- lapply(rest_hypotheses, function(x) paste("K",first_hypothesis,x,sep=""))
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
    #bind those to a dataframe called "kdata" (so that all kvalue calls bind onto the same )
    return(kvalue)
    detach()
  }
  getKValuefromChunk <- function(df, chunk) {
    first <- chunk[1]
    rest <- chunk[-1]
    result <- calculateKValue(df, first, rest)
    return(result)
  }
  kvalues <- as.data.frame(lapply(indices, function(x) getKValuefromChunk(df, chunks[[x]])))
  
  #bind the kvalues to the dataframe and return to global environment
  kdata <<- as.data.frame(cbind(df, kvalues))
}

allKValues(data2, c("strong", "weak", "average"))

#the problem is that they're writing over eachother when they cbind to the same dataframe :( )






rearrangeSummarize <- function(df, list_id_vars, list_of_hypotheses) {
  # pull only the columns we are interested in into a new dataframe so it's not so crazy to look at and graph
  hypcolnames <<- sapply(list_of_hypotheses, function(x) paste(x,"Hyp",sep=""))
  subsetcols <- c(list_id_vars, hypcolnames)
  data3 <- df[,unlist(subsetcols)]

  #create column combining id_vars besides subject into "block" 
  subject_id_var <- "subject"
  rest_id_vars <- unlist(lapply(list_id_vars, function(x) if(!(x %in% subject_id_var)) x))
  attach(data3)
  block <- Reduce(function(x,y) paste(get(x),get(y),sep="_"), rest_id_vars)
  block <- as.factor(block)
  data3 <- cbind(data3, block)

  # add winner column, print which hypothesis wins for each subject
  # step 1: get row numbers corresponding to each hyp's 'winners'
  hyprownumbers <<- lapply(hypcolnames, function(x) which(data3[x] == 1))
  indices <<- c(1:length(hyprownumbers))
  # for some reason this doesn't work with an lapply but works with a for loop :( 
  for(i in 1:length(hyprownumbers)) {
    data3[unlist(hyprownumbers[i]), "Winner"] <- labels(hyprownumbers[i])
  }
  data3$Winner <- as.factor(data3$Winner)
  assign("data3", data3, .GlobalEnv)

  # sum hypothesis responses
  # so it collapses *across subjects* for each combo of idvars (instead of listing each subject for each combo)
  data4 <<- plyr::ddply(data3, "block", plyr::numcolwise(sum))
  # melt data (wide format to long format) so its easier to graph Bayes for mixing/alignments
  data4.long <<- reshape2::melt(data4)
  detach()
}

# working for restructuring
# strongRowNumbers <- which(summary_df$strongHyp == 1)
# summary_df[strongRowNumbers, "winner"] <- "strong"
# summary_df[unlist(hyprownumberws[2]), "winner"] <- labels(hyprownumberws[2])
# hyprownumbers <- sapply(hypcolnames, function(x) which(summary_df[x] == 1))
# summary_df[unlist(hyprownumbers[1]), "winner"] <- labels(hyprownumbers[1])




BayesPlot <- function(df.long, list_id_vars, by_proportion=FALSE, number_of_subjects=NULL) {
  library(ggplot2)
  
  colors <- c("#982395", "#F05B47", "#FFA200", "#28BE9B", "#74AAF7", "#7F7F7F")
  
  # get x label
  subject_id_var <- "subject"
  rest_id_vars <- unlist(lapply(list_id_vars, function(x) if(!(x %in% subject_id_var)) x))
  xlabel <- Reduce(function(x,y) paste(x,y,sep=" + "), rest_id_vars)
  
  if(by_proportion==FALSE){
    bayes_plot <- ggplot(df.long,aes(x=block,value,fill=variable))+geom_bar(stat="identity",position="dodge") + theme_bw() + xlab(xlabel) + ylab("Number of Subjects") + labs(fill="Hypothesis") + scale_fill_manual(values=colors)
    assign("bayes_plot", bayes_plot, .GlobalEnv)
    bayes_plot
  }
  
  if(by_proportion==TRUE){
    if(is.null(number_of_subjects)){
      print("error: include total number of subjects to calculate proportions as 'number_of_subjects'")
    } else {
      # graph by proportion instead of by counts?
      df.long["proportion"] <- (df.long["value"])/number_of_subjects #number of subjects
      bayes_proportion <- ggplot(df.long,aes(x=block,proportion,fill=variable))+geom_bar(stat="identity",position="dodge") + theme_bw() + xlab(xlabel) + ylab("Proportion of Subjects") + labs(fill="Hypothesis") + scale_fill_manual(values=colors)
      bayes_proportion <- bayes_proportion + ylim(0, 1.0)
      assign("bayes_proportion", bayes_proportion, .GlobalEnv)
      bayes_proportion
    }
  }
  
}




#BAYES PACKAGE
data <- read.csv("~/Desktop/lgs2-labeled.csv")
library(cldl)
hypotheses <- c("strong", "weak", "average", "X1biggest", "X2biggest")
makeNopes_fromYeps(data, hypotheses)
allLikelihoods_yepFormat(data, c("subject", "mixing", "alignment"), hypotheses)
allKValues(data2, hypotheses)
rearrangeSummarize(kdata, c("subject", "mixing", "alignment"), hypotheses)
BayesPlot(data4.long, c("subject", "mixing", "alignment"), TRUE, 30)
BayesPlot(data4.long, c("subject", "mixing", "alignment"))

 #TODO
#rearrange/summarize
  #random == 1: print 'error'
#include 'randomHyp'
#write up the entire thing in a bigger fxn