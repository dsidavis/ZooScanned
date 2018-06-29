
tiff = list.files(pattern = "\\.tiff$", full = TRUE, recursive = TRUE)
base = gsub("_[0-9]+\\.tiff", "", tiff)
txtFiles = split(gsub("\\.tiff$", ".txt", tiff), base)

source("ZooScanned/R/fromText.R")
tmp = lapply(txtFiles[sects], getDocElements)

