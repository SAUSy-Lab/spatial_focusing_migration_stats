# batch computes spatial focusing migration statistics 
# using the package migration indices
# install.packages('migration.indices')
# cran: https://cran.r-project.org/web/packages/migration.indices/migration.indices.pdf
# github: https://github.com/daroczig/migration.indices/tree/master/R

# loading the libraries
library(migration.indices)
library(ggplot2)
setwd("~/path/to/folder")

# list of file names to input - should all have the same matrix structure and be n x n
file_names = c("A","B","etc")

# header of the output for aggregate stats
out_agg_stats <- matrix(c("name","total_flows_gini","out_gini","stand_out_gini","in_gini","stand_in_gini","exchange_gini","stand_exchange_gini","acv_all","acv_out","acv_in"), nrow=1)

# looping over the input files
for (file_name in file_names){
  
  path_name = paste("in_data/", file_name, ".csv", sep = "")
  print(path_name)
  # loading and setting up the matrix
  m <- read.csv(path_name, row.names = 1)
  m <- data.matrix(m, rownames.force = NA)
  diag(m) <- 0
  
  # transpose matrix onl if needed - rows should be out flows and columns should be in flows
  m <- t(m) 
  
  # inidividual level CV stats - i.e. for each 
  cvin <- as.data.frame(migration.cv.in(m))
  colnames(cvin)[1] <- paste("cvin_", file_name, sep = "")
  cvout <- as.data.frame(migration.cv.out(m))
  colnames(cvout)[1] <- paste("cvout_", file_name, sep = "")
  zcvin <- as.data.frame(scale(cvin))
  colnames(zcvin)[1] <- paste("zcvin_", file_name, sep = "")
  zcvout <- as.data.frame(scale(cvout))
  colnames(zcvout)[1] <- paste("zcvout_", file_name, sep = "")
  out_m <- merge(cvout,zcvout,by=0,all=TRUE)
  in_m <- merge(cvin,zcvin,by=0,all=TRUE)
  mer <- merge(in_m,out_m,by=0,all=TRUE)
  mer[2] <- NULL
  
  # write to csv files 
  cv_name <- paste("out_data_cv/cv_", file_name, ".csv", sep="")
  write.csv(mer, file=cv_name, row.names = FALSE, col.names = FALSE)
  
  # state level Gini
  giniin <- as.data.frame(migration.gini.in(m))
  colnames(giniin)[1] <- paste("gini_in_", file_name, sep = "")
  giniout <- as.data.frame(migration.gini.out(m))
  colnames(giniout)[1] <- paste("gini_out_", file_name, sep = "")
  gmer <- merge(giniin,giniout,by=0,all=TRUE)
  gini_name <- paste("out_data_gini/gini_", file_name, ".csv", sep="")
  write.csv(gmer, file=gini_name, row.names = FALSE, col.names = FALSE)
  
  # aggregate statistics !!! :)
  
  # to avoid null values
  m[m == 0] <- 0.0001
  diag(m) <- 0
  
  mg <- migration.gini(m, corrected = FALSE)
  
  # ACV stats
  migration.acv(m)
  migration.acv.out(m)
  migration.acv.in(m)
  
  # list of all aggregate stats
  agg_list <- matrix(c(file_name,mg[1],mg[3],mg[7],mg[4],mg[8],mg[2],mg[9],migration.acv(m),migration.acv.out(m),migration.acv.in(m)), nrow=1)
  # append rbind to out matrix
  out_agg_stats <- rbind(out_agg_stats, agg_list)
  
}

# writing aggregate stats to csv
write.csv(out_agg_stats, file="out_agg_stats.csv", row.names = FALSE, col.names = FALSE)


  
