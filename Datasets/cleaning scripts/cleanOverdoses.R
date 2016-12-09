# This script cleans the data for the overdoeses information by removing commas from numerical values
# The cleaned script can be found in Datasets/clean/overdoses-cleaned.csv

# Clear workspace
rm(list=ls())

overdosesInfo <- data.frame(read.csv("../raw/overdoses.csv", stringsAsFactors=FALSE))

overdosesInfo$Population <- as.numeric(gsub(",","",overdosesInfo$Population))
overdosesInfo$Deaths <- as.numeric(gsub(",","",overdosesInfo$Deaths))

write.csv(overdosesInfo, "../clean/overdoses-cleaned.csv", row.names=FALSE)