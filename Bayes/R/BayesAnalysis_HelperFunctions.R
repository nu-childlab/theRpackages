#' A CLDL Function
#'
#' This function generates data in "Yep format": compares the hypothesis-predictions in the levels file to subject responses and writes "yep" columns to data to indicate if response was hypothesis-consistent
#' @param df the dataframe
#' @param levels the csv containing levels (must contain "[hypothesis]px" column for every hypothesis)
#' @param hypotheses a list of the hypotheses (must each have a "px" column in the levels file)
#' 
#' @return returns 'data' dataframe to Global Env., containing the Yep value columns (value "correct" by hypothesis)
#'
#' @examples 
#' makeYeps_fromLevels(data, levels, hyps)
#' 
#' @export

makeYeps_fromLevels <- function(df, levels, hypotheses) {
 
  df["stimulus"] <- factor(unlist(df["stimulus"])) # double brackets to access as vector not df
  # merge data and levels
  datam <- merge(levels,df)
  ## keypress 70 = G = 'yes' = 1, 74 = F = 'no' = 0
  ## a number -1 keypresses, not good (n=14)
  datas <- subset(datam, key_press > 0)  
  # assign numeric response value
  datas$value <- ifelse(datas$key_press==70,1,0)
  

  #function to calculate value "correct" by hypothesis columns 
  correctByHypothesis <- function(hypotheses, df) {
    yepnames <- lapply(hypotheses, function(x) paste(x,"Yep", sep=""))
    pxnames <- lapply(hypotheses, function(x) paste(x, "px", sep=""))
    assignCorrect <- function(px, yepname, df) {
      yepcolumn <- as.data.frame(ifelse(df["value"]==1 & df[px]==1, 1, ifelse(df["value"]==0 & df[px]==0, 1,0)))
    }
    #mini dataframe with all of the yep columns (value "correct" by hypothesis)
    yepcols <- as.data.frame(mapply(function(x,y) assignCorrect(x,y,df), unlist(pxnames), unlist(yepnames)))
    #rename with yepcolnames
    colnames(yepcols) <- yepnames
    #return as 'data' to global environment
    data <<- cbind(df, yepcols)
  }
  
  #if random/Random in hypotheses, set it aside for special case yep calculation
  random<-hypotheses[(grep("random", hypotheses, ignore.case=TRUE))]
  if(length(grep("random", hyps, ignore.case=TRUE))!=0){
    hypotheses2 <- hypotheses[!(hypotheses==random)]
    correctByHypothesis(hypotheses2, datas)
  } else {
    correctByHypothesis(hypotheses, datas)
  }

  
  #declutter unneeded cols for Bayes Analysis Purposes
  extracols <- c("key_press", "trial_type", "trial_index", "trial_index_global", "time_elapsed", "internal_chunk_id", "responses")
  data <- data[,!names(data) %in% extracols]
  
  #add random/RandomYep column if applicable 
  if(length(grep("random", hyps, ignore.case=TRUE))!=0){
    randcolname <- paste(hyps[grep("random", hyps, ignore.case=TRUE)], "Yep", sep="")
    randcol <- as.data.frame(data$value)
    colnames(randcol) <- randcolname
    data <- cbind(data, randcol)
  }
  
  assign("yepdata", data, .GlobalEnv)
  
}




#' A CLDL Function
#'
#' This function generates the recast formula from its list of id.vars (primarily called from within other package fxns)
#' @param list the character vector (that will be the id.vars parameter in our recast function)
#' @return returns id.vars as a formula formatted for use in the recast function 
#' @keywords recast list formula
#'
#' @examples 
#' list_to_recastformula(c("subject", "alignment", "mixing"))
#'
#' @export


list_to_recastformula <- function(list) {
  list <- paste(list, collapse = " + ") # concatenate list into 1 string with +'s
  list <- paste(list, ".", sep=" ~") # concatenate with the .~
  formula <- as.formula(list, env=parent.frame()) # turn into a formula 
  return(formula) # return the formula
}



#' A CLDL Function
#'
#' This function adds, for each hypothesis, a "nope" columns (hypothesis-inconsistent response = 1) based on "yep" columns (hypothesis-consistent response =1), for use in the likelihoods in our Bayes Analysis
#' @param df the dataset; each hypothesis requires a column with subject response consistent with hypothesis = 1, else 0; labeled [hypothesis]Yep
#' @param hypotheses the list of hypotheses (list of strings)
#' @return returns complete dataset including nopes to global environment
#' @keywords Bayes likelihood yep nope 
#'
#' @examples 
#' makeNopes_fromYeps(yepdata, c("strong", "weak", "X1biggest", "X2biggest"))
#'
#' @export


makeNopes_fromYeps <- function(df, hypotheses) {
  
  #obtain/construct column names 
  make_yepname <- function(hypothesis) {
    paste(hypothesis,"Yep",sep="")
  }
  make_nopename <- function(hypothesis) {
    paste(hypothesis,"Nope",sep="")
  }
  yepnames <- lapply(hypotheses, function(x) make_yepname(x))
  nopenames <- lapply(hypotheses, function(x) make_nopename(x))
  
  calculateNope <- function(df, hypothesis) {
    yep <- df[make_yepname(hypothesis)] #get the yep column numerical values
    ifelse(yep == 1, 0, 1) #replace 1s with 0s and vice versa to get nopes
  }
  #mini dataframe with all the nope columns: 
  nopes <- as.data.frame(lapply(hypotheses, function(x) calculateNope(df, x)))

  # rename the nope columns with nopenames 
  colnames(nopes) <- nopenames
  # add the nope columns to the dataframe 
  df <- cbind(df, nopes)

  df_name <- toString(df)
  assign("nopedata", df, .GlobalEnv)
}




#' A CLDL Function
#'
#' This function calculates the likelihoods of a hypothesis for use in our Bayes Analysis
#' @param data the dataset; each hypothesis requires a column with subject response consistent with hypothesis = 1, else 0; and a column for response inconsistent=1, else 0. 
#' @param list_id_vars the list of independent variables for the recast function (list of strings)
#' @param measure_var_yep colname of 1s/0s corresponding to hypothesis-CONSISTENT (yep) responses (as string)
#' @param measure_var_nope colname of 1s/0s corresponding to hypothesis-INCONSISTENT (nope) responses (as string)
#' @return returns complete dataset to global environment
#' @keywords Bayes likelihood 
#'
#' @examples 
#' calculateLikelihood(data, c("subject", "mixing", "alignment"), "strongYep", "strongNope", "Strong")
#' calculateLikelihood(data, c("subject", "mixing", "alignment"), "weakYep", "weakNope", "Weak")
#'
#' @export



calculateLikelihood <- function(data, list_id_vars, measure_var_yep, measure_var_nope, hypothesis) {
  # get id vars as recast formula
  formula1 <- list_to_recastformula(list_id_vars) 
  
  # new dataframe summing the number of hypothesis-CONSISTENT("yep") responses for each combo of idvars
  data2 <- reshape2::recast(data, id.var = list_id_vars, measure.var = measure_var_yep, formula = formula1, fun.aggregate = sum)
  # rename last column 
  colnames(data2)[length(data2)] = measure_var_yep
  # get a new dataframe summing the number of hypothesis-INCONSISTENT("nope") responses for each combo of idvars (need for error calculation)
  data3 <- reshape2::recast(data, id.var = list_id_vars, measure.var = measure_var_nope, formula = formula1, fun.aggregate = sum)
  # rename last column 
  colnames(data3)[length(data3)] = measure_var_nope
  # merge dataframes for yeps and nopes
  data2 <- merge(data2, data3, list_id_vars)
  
  
  # calculate liklihood that they're going by this hypothesis (by combo of id vars)
  # 1/10 : error rate 
    #so taking the hypothesis-inconsistent responses total to the 1/10 allows them to make a mistake 1/10th of the time and still be considered consistent with going by this hypothesis
  # generates very small likelihoods (we'll be dividing them by equally small likelihoods later)
  if(hypothesis=="random") {
    ####CHANGE THIS LINE IF CHANCE IS NOT 50%###
    data2$likelihood <- with(data2, 0.5^(randomYep + randomNope))
  } else {
    data2$likelihood <- with(data2, (9/10)^get(measure_var_yep) * (1/10)^get(measure_var_nope))
  }
  # rename last column 
  colnames(data2)[length(data2)] = paste("likelihood",hypothesis,sep="")
  
  #rename dataframe according to hypothesis and save it to the global environment
  newName <- paste(hypothesis,"data",sep="")
  assign(newName, data2, .GlobalEnv)
}




#' A CLDL Function
#'
#' This function calculates likelihoods for each hypothesis of a list, for use in our Bayes Analysis
#' @param data the dataframe, **MUST have columns for each hypothesis labeled in the format "[hypothesis]Yep", "[hypothesis]Nope"**
#' @param list_id_vars the list of independent variables for the recast function 
#' @param list_of_hypotheses the list of hypothesis names 
#' @return returns dataframe for each hypothesis with likelihoods by ID varibables, and 1 merged dataframe of all hypotheses
#' @keywords likelihood bayes hypothesis
#'
#' @examples 
#' allLikelihoods_yepFormat(data, c("subject", "mixing", "alignment"), c("strong", "weak", "average", "X1biggest"))
#'
#' @export

allLikelihoods_yepFormat <- function(data, list_id_vars, list_of_hypotheses) {
  
  # function to calculate likelihood for each hypothesis (with added feature of constructing the yep/nope colnames from the hypothesis name)
  getLikelihood <- function(data, list_id_vars, hypothesis) {
    cldl::calculateLikelihood(data, list_id_vars, paste(hypothesis,"Yep",sep=""), paste(hypothesis,"Nope",sep=""), hypothesis)
  }
  # calculate the likelihood for each hypothesis in the list
  lapply(list_of_hypotheses, function(x) getLikelihood(data, list_id_vars, x))
  # merge the list of dataframes once all are created
  listdf<- lapply(list_of_hypotheses, function(x) paste(x,"data",sep=""))
  ldata <<- Reduce(function(x,y) merge(x,y,by=list_id_vars), lapply(listdf, function(x) get(x)))
  
  #declutter
  rm(list=unlist(listdf), envir=.GlobalEnv)
}



#' A CLDL Function
#'
#' This function calculates the K values for all hypotheses for use in our Bayes Analysis
#' @param df the dataframe, with likelihoods already calculated for each hypothesis [and listed in columns named likelihoood[hypothesis]]
#' @param list_of_hypotheses the list of hypotheses to calculate K Values over
#' @return returns dataframe 'kdata' with K values for each hypothesis compared to all others 
#' @keywords Bayes KValue
#'
#' @examples 
#' allKValues(data3, c("strong", "weak", "average"))
#' allKValues(data3, c("strong", "weak", "average", "X1biggest", "X2biggest"))
#'
#' @export

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
    summarycolname <-paste(first_hypothesis, "Hyp", sep="")
    summarycol <- as.data.frame(ifelse(Reduce('&', lapply(cols, function(x) kvalue[x]>3)), 1, 0))
    colnames(summarycol) <- summarycolname
    kvalue <- cbind(kvalue, summarycol)
    
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



#' A CLDL Function
#'
#' This function rearranges and summarizes the kvalue data for easier plotting, for use in our Bayes Analysis
#' @param df the dataframe, with k values for each hypothesis and summary by hypothesis
#' @param list_id_vars the independent variables 
#' @param list_of_hypotheses the list of hypotheses 
#' @return returns dataframe 'data3' with only the columns of interest and a 'winner' column
#' @keywords Bayes KValue 
#'
#' @examples 
#' rearrangeSummarize(kdata, c("subject", "mixing", "alignment"), c("strong", "average", "X2biggest"))
#'
#' @export


rearrangeSummarize <- function(df, list_id_vars, list_of_hypotheses) {
  # pull only the columns we are interested in into a new dataframe so it's not so crazy to look at and graph
  hypcolnames <- sapply(list_of_hypotheses, function(x) paste(x,"Hyp",sep=""))
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
  hyprownumbers <- lapply(hypcolnames, function(x) which(data3[x] == 1))
  indices <- c(1:length(hyprownumbers))
  # step 2, update winner col with hypothesis winner based on row numbers
  # for some reason this doesn't work with an lapply but works with a for loop :( 
  for(i in 1:length(hyprownumbers)) {
    #if a non-zero vector:
    if(length(unlist(hyprownumbers[i]))!=0) {
      data3[unlist(hyprownumbers[i]), "Winner"] <- labels(hyprownumbers[i])
    }
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




#' A CLDL Function
#'
#' This function generates our Bayes Plot to conclude our analysis
#' @param df.long the long dataframe for plotting, with k values for each hypothesis and summary by hypothesis
#' @param list_id_vars the independent variables 
#' @param by_proportion defaults to FALSE and plots by number, if TRUE, plots by proportion
#' @param number_of_subjects defaults to NULL, required to calculate proportions if plotting by proportion
#' @return returns ggplot
#' @keywords Bayes 
#'
#' @examples 
#' BayesPlot(data4.long, c("subject", "mixing", "alignment"), TRUE, 30)
#' BayesPlot(data4.long, c("subject", "mixing", "alignment"), FALSE)
#' BayesPlot(data4.long, c("subject", "mixing", "alignment"))
#'
#' @export



BayesPlot <- function(df.long, list_id_vars, by_proportion=FALSE, number_of_subjects=NULL) {
  library(ggplot2)
  
  colors <- c("#982395", "#F05B47", "#FFA200", "#28BE9B", "#74AAF7", "#7F7F7F")
  
  # get x label
  subject_id_var <- "subject"
  rest_id_vars <<- unlist(lapply(list_id_vars, function(x) if(!(x %in% subject_id_var)) x))
  xlabel <- Reduce(function(x,y) paste(x,y,sep=" + "), rest_id_vars)
  
  if(by_proportion==FALSE){
    bayes_plot <- ggplot(df.long,aes(x=block,value,fill=variable))+geom_bar(stat="identity",position="dodge") + theme_bw() + xlab(xlabel) + ylab("Number of Subjects") + labs(fill="Hypothesis") + scale_fill_manual(values=colors)
    assign("bayes_plot", bayes_plot, .GlobalEnv)
  }

  if(by_proportion==TRUE){
    if(is.null(number_of_subjects)){
      print("error: include total number of subjects as 'number_of_subjects'")
    } else {
      # graph by proportion instead of by counts?
      df.long["proportion"] <- (df.long["value"])/number_of_subjects #number of subjects
      bayes_proportion <- ggplot(df.long,aes(x=block,proportion,fill=variable))+geom_bar(stat="identity",position="dodge") + theme_bw() + xlab(xlabel) + ylab("Proportion of Subjects") + labs(fill="Hypothesis") + scale_fill_manual(values=colors)
      bayes_proportion <- bayes_proportion + ylim(0, 1.0)
      assign("bayes_proportion", bayes_proportion, .GlobalEnv)
    }
  }

}
