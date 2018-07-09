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

all.length = sapply(tmp, length)
table(all.length)
plot(density(all.length))

ind.min = which(all.length %in% c(1, 2, 3))
ind.mid = which(all.length %in% c(9))
ind.max = which(all.length %in% c(18, 19, 22))

lapply(tmp[ind.min], names)
lapply(tmp[ind.mid], names)
lapply(tmp[ind.max], names)

# Min:
# scannedNewPDFs_txt/Isla Vista Virus/Song-1995 
# scannedNewPDFs_txt/Lagos Bat Virus/Shope-1982
# scannedNewPDFs_txt/Issyk-Kul/Lvov-1973

# Mid:
# scannedNewPDFs_txt/Black Creek Canal Virus/Rollin-1995
# scannedNewPDFs_txt/European Bat Lyssavirus 2/Whitby-2000

# max:
# scannedNewPDFs_txt/Crimean Congo Hemorrhagic Fever Virus/Swanepoel-1987
# scannedNewPDFs_txt/Western equine encephalitis/Iversson-1993
# scannedNewPDFs_txt/Jamestown Canyon Virus/Clark-1986
# scannedNewPDFs_txt/Jamestown Canyon Virus/Reisen-1995








