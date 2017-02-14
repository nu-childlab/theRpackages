data2 <- read.csv("~/Desktop/gleebest2-data-reshaped.csv")
#########################################################
library(dplyr)
library(ggplot2)
library(reshape2)

# barplot
# summarize data to get proportion NUMBER response by condition
datarecast <- recast(data2, id.var = c("cond"), measure.var = "numResp", formula = cond ~., fun.aggregate = mean)
# rename last column to "quantityResp"
colnames(datarecast)[length(datarecast)] = "numResp"

# gray bargraph
colors <- c("#F05B47", "#FFA200", "#982395",  "#28BE9B", "#74AAF7", "#7F7F7F")
gleebest_bar <- ggplot(data=datarecast, aes(x=cond, y=numResp, fill=cond)) + geom_bar(stat = "identity") + theme_bw() + scale_fill_manual(values=colors) + theme(legend.position="none")
gleebest_bar <- gleebest_bar + theme(axis.text=element_text(size=20), axis.title=element_text(size=24, face="bold"), axis.title.y=element_text(vjust=1.5), axis.title.x=element_text(vjust=-0.5))

# add axis labels 
gleebest_bar <- gleebest_bar + xlab("condition") + ylab("proportion correct")
# change y axis limit 
gleebest_bar <- gleebest_bar + ylim(0, 1.0)
# add chance line 
gleebest_bar$layers <- c(geom_abline(intercept = 0.5, slope = 0, linetype = "dotted", color = "#74AAF7", size=1.0), gleebest_bar$layers)
# view in plots
gleebest_bar
