
tiff = list.files(pattern = "\\.tiff$", full = TRUE, recursive = TRUE)
base = gsub("_[0-9]+\\.tiff", "", tiff)
txtFiles = split(gsub("\\.tiff$", ".txt", tiff), base)
txt = tapply(tiff, base, function(x) unlist(lapply(gsub("\\.tiff$", ".txt", x), readLines, warn = FALSE)))

sects = sapply(txt, function(x) any(grepl("^((([0-9.]+ )? [A-Z ]+)|Discussion|Introduction|Materials and Methods|References)$", x, ignore.case = TRUE)))


source("ZooScanned/R/fromText.R")
#tmp = lapply(txtFiles[sects], getDocElements)
tmp = lapply(txtFiles, function(f) try(getDocElements(f)))

# Now look at the results and explore the number of sections found in each, ....
