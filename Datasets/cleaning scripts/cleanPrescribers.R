# The cleaned script can be found in Datasets/clean/prescriber-info-cleaned.csv

# This script is designated to provide a CSV which we can use for modeling

# The data cleaning done:
  # Remove all categorical variables, ie State, Gender, etc.
  # Remove all opiates.
  # Select the top 10 most frequently prescribed non-opiates
  # Each column is a binary variable - either prescribed the drug or did not

# The resulting CSV contains the following columns
  # BRIMONIDINE.TARTRATE  
  # DIPHENOXYLATE.ATROPINE 
  # DORZOLAMIDE.TIMOLOL    
  # IPRATROPIUM.BROMIDE   
  # LITHIUM.CARBONATE      
  # ONDANSETRON.ODT        
  # ONGLYZA             
  # PHENOBARBITAL         
  # SEROQUEL.XR            
  # ZIPRASIDONE.HCL        
  # Opioid.Prescriber <- The class we are trying to predict
           

# Clear workspace
rm(list=ls())

#Read the prescriber info and save into data frame
prescriberInfo <- data.frame(read.csv("../raw/prescriber-info.csv", stringsAsFactors=FALSE))

#Read opioids from file
opioids <- read.csv("../raw/opioids.csv")
opioids <- as.character(opioids[,1]) # First column contains the names of the opiates
opioids <- gsub("\ |-",".",opioids) # replace hyphens and spaces with periods to match the dataset

#Remove all opioids, col count = 245/256
prescriberInfo <- prescriberInfo[, !names(prescriberInfo) %in% opioids]

#Remove useless columns, col count = 242/256
header <- c("State", "Specialty", "Gender", "NPI", "Credentials")
prescriberInfo <- prescriberInfo[, !names(prescriberInfo) %in% header]

#Select drugs with highest frequency
filterNumerical = c("Gender", "Specialty", "NPI", "Credentials", "State", "Speciality", "Opioid.Prescriber")
nonOpiates <- prescriberInfo[, !names(prescriberInfo) %in% filterNumerical]
colSums(nonOpiates)

##Take the mean and remove unnecessary opiates
temp <- data.frame(a=character(), b=numeric(), stringsAsFactors = FALSE)
for (col in names(nonOpiates)) 
{
  temp[nrow(temp)+1, ] <- c(col, as.numeric(sum(nonOpiates[col] > 0) / nrow(nonOpiates)))
}
temp$b <- as.numeric(as.character(temp$b))

temp <- temp[order(temp$b), ]
temp <- temp[1:10,]

#for (col in names(temp)) {
#  prescriberInfo[col] <- ifelse(col, as.numeric(prescriberInfo[col])==0, 0, 1)
#}

garbageNames <- names(nonOpiates)[!(names(nonOpiates) %in% temp$a)]
prescriberInfo <- prescriberInfo[, !names(prescriberInfo) %in% garbageNames]

##Write a cleaned CSV
write.csv(prescriberInfo, "../clean/prescriber-info-cleaned.csv", row.names=FALSE)