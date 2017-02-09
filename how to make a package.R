# Casey Colby
# How to make an R package!
# 8/1/2016 

#######################################

# Loading and Installing Required Packages 
# devtools, roxygen2

#######################################

# if you've never installed these packages, uncomment the 3 install lines below 

# install.packages("devtools") 
library(devtools)
#devtools::install_github("klutometis/roxygen")
#install.packages("roxygen2")
library(roxygen2)

###########################################

# Creating the a directory for the package

###########################################


# set working directory to where you want to keep it
setwd("/Users/caseycolby/Desktop")
# create a new folder with the name you want for the package
create("cldl")


####################################

# Creating a Function in the Package

####################################

# create new .R file (using R script or text editor)
# save it in [your package folder] > R 
# paste the code for the function into this file


#########################################

# Adding the req'd Comments/Documentation 

#########################################

# fill in the comments below and paste at the TOP of the function's file: 
# EACH LINE OF THE COMMENTS SECTION STARTS WITH: #' 
# replace with your own package name, description of fxn, however many parameters you have in the fxn, etc.! 

  #' A [package name or organization] function. 
  #'
  #' [write a brief description about what the function does].
  #' @param [argument name] [write a description of argument]
  #' @param [argument name] [write a description of argument]
  #' @param [argument name] [write a description of argument]
  #' @return [write a description of what fxn returns] 
  #' @keywords [keywords separated by spaces]
  #' 
  #' @examples 
  #' [example call to function]
  #' [example call to function]
  #' [another example call to function]
  #' [example, the more examples the better for your users!]
  #' 
  #' @export
  
########

# Sample comments for cldl function: 
  #'   A CLDL Function 
  #'   
  #'   This function allows you to merge datasetsand export the product.
  #'   @param folder_path path to folder containing individual datasets
  #'   @return None
  #'   @keywords merge 
  #'   
  #'   @examples 
  #'  merge_multiple("/Users/cec804/Desktop/themostData_6-29-16")
  #'  
  #'   @export
  #' 


##############################

# Processing the documentation 

##############################

# save your file
# run this code (R creates and adds the required .Rd files to your directory): 
library(devtools)
setwd("./cldl") # setwd so you're IN the cldl folder, or include whatever filepath you need to get there
document()


#################################

# Installing package 

#################################

# at last, install your package! 
# run the install from parent working directory (setwd to the folder where your package folder lives)
setwd("~/Desktop") # or wherever the parent directory is for the cldl package folder
install("cldl")
# now you can load it like a normal library when you use R! 
library(cldl)
# now type your functions in the console like you would any other!! 






###############################################

# Updating the package functions/documentation

###############################################

# if you make edits to functions (or add functions)
# be sure to save the .R file in the [packagename] > R folder

# step1: load the necessary library
library(devtools)

# step2: if you edited/added any documentation:
setwd("~/Desktop/cldl") # or wherever cldl is located
document() 

# step3: re-install the updated package
setwd("..")
install("cldl")
# Good to go! you can load the package and use its functions like any other library! 

