# Since I have all txt files downloaded, and I currently don't have enough space to unzip all tiff files
# I think I can find all txt files directly by this line, is that right?
txt = list.files(pattern = "_[0-9]+\\.txt$", full = TRUE, recursive = TRUE)

base = gsub("_[0-9]+\\.txt", "", txt)
txtFiles = split(txt, base)

txt2 = tapply(txt, base, function(x) unlist(lapply(gsub("\\.txt$", ".txt", x), readLines, warn = FALSE)))

# 
# sects = sapply(txt2, function(x) any(grepl("^((([0-9.]+ )? [A-Z ]+)|Discussion|Introduction|Materials and Methods|References)$", x, ignore.case = TRUE)))

source("ZooScanned/R/fromText.R")
tmp = lapply(txtFiles, getDocElements)
# getDocElements drops lots of stuffs and has Errir in !ok

tmp
