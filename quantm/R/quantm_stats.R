#' A CLDL Quantm Function
#'
#' This function creates dataframe and log/raw resids for 1 factor 
#' @param factor the factor as a STRING, corresponds to a named column in the dataframe
#' @param df the dataframe, contains a column named 
#' 
#' @return returns 2 dataframes to the global environment; one with log resid and one with raw resid 
#'
#' @examples 
#' quantm_resid("FPRT", qdata)
#' quantm_resid("RPD", qdata)
#' 
#' @export

quantm_resid <- function(factor, df) { 
  factor_name_lower <- sapply(factor, tolower) # get factor as lowercase string
  raw_name <- paste(factor_name_lower, "Raw",sep="") # create the name of the new dataset 
  # create dataframe for factor
  df2 <- df[df[factor]>0,] # create dataframe 
  df3 <- df2 # save for raw calculation
  
  # for log resid
  df2["log"] <- log(df2[factor]) # create column of log measures
  df2 <- df2[df2$log < (mean(df2$log) + 2.5*sd(df2$log)),] # trim outliers
  df2["resid"] <- resid(lm(log~wlen, data = df2))
  assign(factor_name_lower, df2, .GlobalEnv) # save to global environment 
  
  # for raw resid
  df3 <- df3[df3[[factor]] < (mean(df3[[factor]]) + 2.5*sd(df3[[factor]])),] # trim outliers
  df3["resid"] <- resid(lm(get(factor)~wlen, data = df3))
  assign(raw_name, df3, .GlobalEnv) # save to  global environment 
}


#' A CLDL Quantm Function
#'
#' This function generates maximal models and writes model comparisons to a file for 1 DATAFRAME
#' @param measure the measure for the lmer, as STRING (likely "resid")
#' @param df the dataframe, contains a column named spill, subjCode, objCode, NPSubj, NPObj, and subject
#' 
#' @return writes model comparison ouput to external file 
#'
#' @examples 
#' quantm_mm("resid", fprtRaw)
#' quantm_mm("resid", rpd)
#' lapply(c(fprtRaw,fprt), function(x) quantm_mm("resid",x))
#' 
#' @export

quantm_mm <- function(measure, df, spill_values) { #measure as string
  output_file <- paste("quantm_stats_",df,".txt",sep="")
  df <- get(df) # can't pass get(x) to the lapply with for fxn call because it names the output files "get(x)". 
  
  # define quantm lmer fxn
  quantm_lmer <- function(measure, df, spill_value) {
    sdata <- subset(df, df["spill"]==spill_value) # subset data according to spill 
    m <- lmer(get(measure) ~ subjCode * objCode + (1 + subjCode * objCode || subject) + (1 + subjCode * objCode || item),
              data = sdata, 
              REML = FALSE, 
              control = lmerControl(optimizer = "bobyqa"))
    m_name <- paste("m", spill_value, sep="")
    assign(m_name, m, .GlobalEnv)
    
    write("\n\n", file=output_file, append = TRUE) # linebreak in file
    capture.output(toupper(paste("lmer:",m_name)), file=output_file, append = TRUE) # label section in file
    capture.output(display(m), file=output_file, append=TRUE) # write to file
  }
  # define quantm anova fxn for model comparisons
  quantm_anova <- function(m) {
    write("\n\n", file=output_file, append = TRUE) # linebreak in file
    capture.output(toupper(paste("anova:",m)), file=output_file, append = TRUE) # label section in file
    
    capture.output(anova(get(m),update(get(m),.~.-subjCode))[6:8[1[1]]], file=output_file, append=TRUE)
    capture.output(anova(get(m),update(get(m),.~.-objCode))[6:8[1[1]]], file=output_file, append=TRUE)
    capture.output(anova(get(m),update(get(m),.~.-subjCode:objCode))[6:8[1[1]]], file=output_file, append=TRUE)
  }
  # define quantm means fxn
  quantm_means <- function(measure, df, spill_value) {
    write("\n\n", file=output_file, append = TRUE) # linebreak in file
    capture.output(toupper(paste("means for spill=",spill_value)), file=output_file, append = TRUE) # label section in file
    
    sdata <- subset(df, df["spill"]==spill_value) # subset data according to spill 
    capture.output(round(with(sdata, tapply(get(measure), NPsubj, mean)), 2), file=output_file, append = TRUE)
    capture.output(round(with(sdata, tapply(get(measure), NPobj, mean)), 2), file=output_file, append = TRUE)
    capture.output(round(with(sdata, tapply(get(measure), list(NPsubj, NPobj), mean)), 2), file=output_file, append = TRUE)
  }
  
  # run quantm_lmer fxn
  lapply(spill_values, function(x) quantm_lmer(measure,df,x))
  # run quantm anova fxn
  mvals <- lapply(spill_values, function(x) paste("m",x,sep=""))
  lapply(mvals, function(x) quantm_anova(x))
  # run quantm means fxn
  lapply(spill_values, function(x) quantm_means(measure, df, x))
}

#' A CLDL Quantm Function
#'
#' This function combines calls to quantm_resid and quantm_mm to run all stats on 1 factor (this fxn calls mm on both log and raw datasets separately for the factor)
#' @param factor the factor as STRING, must correspond to a column in the dataframe
#' @param df the dataframe, contains a column named with the factor, spill, subjCode, objCode, NPsubj, NPobj, and subject
#' 
#' @return writes model comparison ouput to external files for factorRaw and factor(log)
#'
#' @examples 
#' quantm_stats("FPRT", qdata, c(0,1,2))
#' lapply(c("FPRT", "RPD", "TFT"), function(x) quantm_stats(x, qdata, c(0,1,2)))
#' 
#' @export


quantm_stats <- function(factor, df, spill_values) {
  library(lme4)
  library(arm)
  
  factor_name_lower <- sapply(factor, tolower) # get factor as lowercase string
  raw_name <- paste(factor_name_lower, "Raw",sep="") # create the name of the new dataset 
  # run fxn 1 on 1 factor and fxn 2 on its raw & log datasets
  quantm_resid(factor, df)
  lapply(c(raw_name, factor_name_lower), function(x) quantm_mm("resid", x, spill_values))
}