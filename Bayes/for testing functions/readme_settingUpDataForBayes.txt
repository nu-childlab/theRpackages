Setting up your data for use with the cldl bayes formula functions 

Option 1: Yep Format (yep/nope columns)
	Dataframe must contain 2 columns per hypothesis named in the following format: 
		(1) "[hypothesis]Yep" - 1 corresponds to hypothesis Consistent ("yep") subject repsonse, 0 else
		(2) "[hypothesis]Nope" - 1 corresponds to hypothesis-inconsistent ("nope") subject response, 0 else

	Use the allLikelihoods_yepFormat() function and input a list of hypotheses e.g. c("strong", "weak", "average")
	This function knows to look for the yep/nope columns for each hypothesis



Option 2: Other Format
	If dataframe hypothesis-consistent and hypothesis-inconsistent columns follow other naming convention/format: 
	(and you don't want to rename them using yep/nope format)

	each hypothesis in the input list needs a list stored in R of the same name, containing (in order):
		(1) column name for hypothesis-consistent responses 
		(2) column name for hypothesis-inconsistent responses
		e.g. strong<- c("consistentWithStrongHyp", "strongflop")

	Use the allLikelihoods_otherFormat() function 
	