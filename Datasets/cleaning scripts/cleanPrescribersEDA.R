library(dplyr)
library(magrittr)
library(ggplot2)
library(maps)
library(data.table)
library(lme4)
library(caret)


limit.rows <- 25000
oldCategoricalInfo <- data.frame(fread("../raw/prescriber-info.csv",nrows=limit.rows))
categoricalInfo <- data.frame(fread("../raw/prescriber-info.csv",nrows=limit.rows))

overdoses <- data.frame(fread("../clean/overdoses-cleaned.csv",nrows=limit.rows))

opioids <- read.csv("../raw/opioids.csv")
opioids <- as.character(opioids[,1]) # First column contains the names of the opiates
opioids <- gsub("\ |-",".",opioids) # replace hyphens and spaces with periods to match the dataset

headers <- c("Gender", "State", "Specialty", "Opioid.Prescriber")

categoricalInfo <- categoricalInfo[, names(categoricalInfo) %in% headers]


categoricalInfo %>%
  group_by(Specialty) %>%
  dplyr::summarise(specialty = n()) %>%
  arrange(specialty) %>% 
  data.frame() %>% 
  head(n=25)

rare.abbrev <- categoricalInfo %>%
  group_by(State) %>%
  dplyr::summarise(state.counts = n()) %>%
  arrange(state.counts) %>%
  filter(state.counts < 10) %>%
  select(State)

# Insert a new level into the factor, then remove the old names 
levels(categoricalInfo$State) <- c(levels(categoricalInfo$State),"other")
categoricalInfo$State[categoricalInfo$State %in% rare.abbrev$State] <- "other"

#categoricalInfo$State <- droplevels(categoricalInfo$State)



# Get the common specialties, we won't change those
common.specialties <- categoricalInfo %>%
  group_by(Specialty) %>%
  dplyr::summarise(specialty.counts = n()) %>%
  arrange(desc(specialty.counts)) %>% 
  filter(specialty.counts > 50) %>%
  select(Specialty)

levels(categoricalInfo$State) <- c(levels(categoricalInfo$State),"other")
categoricalInfo$State[categoricalInfo$State %in% rare.abbrev$State] <- "other"
#categoricalInfo$State <- droplevels(categoricalInfo$State)

#common.specialties <- levels(droplevels(common.specialties$Specialty))


# Default to "other", then fill in. I'll make special levels for surgeons and collapse any category containing the word pain
new.specialties <- factor(x=rep("other",nrow(categoricalInfo)),levels=c(common.specialties,"Surgeon","other","Pain.Management", "General"))
new.specialties[categoricalInfo$Specialty %in% common.specialties] <- categoricalInfo$Specialty[categoricalInfo$Specialty %in% common.specialties]

new.specialties[grepl("nurse",categoricalInfo$Specialty,ignore.case=TRUE)] <- "General"
new.specialties[grepl("practice",categoricalInfo$Specialty,ignore.case=TRUE)] <- "General"
new.specialties[grepl("family",categoricalInfo$Specialty,ignore.case=TRUE)] <- "General"
new.specialties[grepl("dentist",categoricalInfo$Specialty,ignore.case=TRUE)] <- "General"
new.specialties[grepl("physician",categoricalInfo$Specialty,ignore.case=TRUE)] <- "General"

new.specialties[grepl("surg",categoricalInfo$Specialty,ignore.case=TRUE)] <- "Surgeon"

new.specialties[grepl("pain",categoricalInfo$Specialty,ignore.case=TRUE)] <- "Pain.Management"
new.specialties <- droplevels(new.specialties)
categoricalInfo$Specialty <- new.specialties


categoricalInfo$NumGender <- as.numeric(factor(categoricalInfo$Gender))
categoricalInfo$NumState <- as.numeric(factor(categoricalInfo$State))
categoricalInfo$NumSpeciality <- as.numeric(factor(categoricalInfo$Specialty))


names(overdoses)[which(names(overdoses) == "State")] <- "State.Name"
names(overdoses)[which(names(overdoses) == "Abbrev")] <- "State"

total <- merge(categoricalInfo, overdoses, by="State")

total
total$Specialty <- droplevels(total$Specialty)

names(total)[which(names(total) == "V1")] <- "StateNumber"

write.csv(prescriberInfo, "../clean/aggregatedInfo-clean.csv")
