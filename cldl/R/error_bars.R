#' A CLDL Function
#'
#' This function adds error bars to a ggplot using the summarySE function 
#' @param df the dataframe (as an object) - use the 'original' dataframe not a recast version, because the summarySE function will recast it
#' @param plot the existing ggplot of the data (as an object)
#' @param measure_var the name of a column (as a string) that contains the variable to be summarized
#' @param group_vars a list containing names of columns (as strings) that contain grouping variables
#' @return returns (1) a png to a 'plots' directory in the current working directory (you should setwd before calling) (2) the new plot to the global environment
#' @keywords error ggplot error_bars standard_error SE summarySE
#'
#' @examples 
#' add_err_bars(data2, gleebest_bar, "numResp", c("cond"))
#' 
#' @export

add_err_bars <- function(df, plot, measure_var, group_vars) {
  library(ggplot2)
  
  # calculations for error bars (cookbook-r.com/Manipulating_data/Summarizing_data/)
  # first define summarySE function (the fxn currently used by CLDL for error bars)
  summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE, conf.interval=.95, .drop=TRUE) {
    library(plyr)
    
    # new version of length which can handle missing data(NA): if na.rm==T, don't count them
    length2 <- function(x, na.rm=FALSE){
      if (na.rm) sum(!is.na(x))
      else		length(x)
    }
    
    # this does the summary. for each group's data frame, return a vector with N, mean, and sd
    datac <- ddply(data, groupvars, .drop=.drop, .fun=function(xx, col) {
      c(N = length2(xx[[col]], na.rm=na.rm), mean=mean (xx[[col]], na.rm=na.rm), sd = sd (xx[[col]], na.rm=na.rm))
    }, measurevar)
    
    # rename the mean column
    # specify plyr package else dplyr causes errors here
    datac <- plyr::rename(datac, c("mean" = measurevar))
    
    # calculate se from mean and N
    datac$se <- datac$sd/sqrt(datac$N)
    
    # Confidence interval multiplier for standard error
    # Caculate t-statistic for confidenc interval:
    # e.g. if conf. interval is .95, use.975 (above/below) and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$CI <-datac$se * ciMult
    
    return(datac)
  }
  
  df2 <- summarySE(df, measurevar = measure_var, groupvars = group_vars)
  # save measure_var to global env; get() fxn in next line only searches global env. (odd behvaior, can't currently fix this) 
  measurevarSE <<- measure_var
  plot_errBars <- plot + geom_errorbar(data=df2, aes(ymin=get(measurevarSE)-se, ymax=get(measurevarSE)+se), width=.2)
  
  # view plot from global env
  print(plot_errBars)
  
  # plot naming for ggsave and for global env
  currPlotName <- deparse(substitute(plot))
  newPlotName <- paste0(currPlotName, "_errBars")
  filename <- paste0(newPlotName, ".png")
  
  # create or locate 'plots' folder in the pwd
  currDir <- getwd()
  subDir <- "plots"
  dir.create(file.path(currDir, subDir), showWarnings = FALSE) # create plots dir if !exists
  filepath <- paste(currDir, subDir, sep="/")

  # save plots to 'plots' folder and return to global env
  assign(newPlotName, plot_errBars, .GlobalEnv)
  ggsave(filename, path=filepath)
}