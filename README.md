# theRpackages
cldl R packages for abstracting analyses and data visualization

# To install packages
enter these commands in RStudio: 

    # uncomment install line if you haven't installed before: 
    # install.packages("devtools")
    library("devtools")
    # replace filepath with path to parent directory of the package directory (inside the quotes)
    setwd("FILEPATH_HERE") 
    # replace packagename with the name of the package (directory name). e.g. cldl, Bayes, or quantm. 
    install("PACKAGENAME_HERE") 
    
once installed initially (and after any updates), when using R can load as normal library 
    
    library(cldl)
    
then call cldl functions as you would any other

====

# Packages

### cldl package (see CLDL_Package.md)
    * assorted commonly-used (generally applicable) functions for transforming dataframes, quick analysis things, etc. 
### quantm package (see QUANTM_Package.md)
    * quantm analysis abstractions
        * quantm stats
        * TODO: quantm graphing
### Bayes package (see BAYES_Package.md)
    * apply the complete Bayes analysis (from EVENTS and LGS)
        * functions to quickly calculate likelihoods for 1 factor or *multiple factors* 
        * functions to quickly calculate K-values for 1 factor or *multiple factors*
        * functions for producing Bayes Plots from the above 

====

# Other Files
* how to make a package.R
  * instructions for making your own package 
  * see also, theRpackage tutorial 
  
====

# TODO Packages: 
* PREFERENCE (Telic)
    * make TELIC graph code more general
    * ggsave store plots into 'plots' folder and transformed data into 'transformed data' folder
    * can stats R outputs be saved/exported directly instead of copy-pasted into file? (results are bound into a summary file and we can *print* it all but instead would like it to save to aux file)
* LME (GLEEBEST 2)
    * recreate LME 
    * abstract 
    * try with LGS3 for more difficult example

