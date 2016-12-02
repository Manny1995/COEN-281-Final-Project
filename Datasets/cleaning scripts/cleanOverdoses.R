
overdosesInfo <- data.frame(read.csv("../raw/overdoses.csv", stringsAsFactors=FALSE))

overdosesInfo$Population <- as.numeric(gsub(",","",overdosesInfo$Population))
overdosesInfo$Deaths <- as.numeric(gsub(",","",overdosesInfo$Deaths))

write.csv(overdosesInfo, "../clean/overdoses-cleaned.csv")