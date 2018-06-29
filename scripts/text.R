tiff = list.files(pattern = "\\.tiff$", full = TRUE, recursive = TRUE)
base = gsub("_[0-9]+\\.tiff", "", tiff)
txtFiles = split(gsub("\\.tiff$", ".txt", tiff), base)
txt = tapply(tiff, base, function(x) unlist(lapply(gsub("\\.tiff$", ".txt", x), readLines, warn = FALSE)))


caps = lapply(txt, function(x) grep("^([0-9.]+ )? [A-Z ]+$", x, value = TRUE))

# LITERATURE CITED
sects = sapply(txt, function(x) any(grepl("^((([0-9.]+ )? [A-Z ]+)|Discussion|Introduction|Materials and Methods|References)$", x, ignore.case = TRUE)))

#w = sapply(sects, length) == 0

Open(paste0(names(txt)[!sects], ".pdf"))


# Some of the !sects  have an ABSTRACT: and Key words and then no sections
w = sapply(txt[!sects], function(x) all(c(any(grepl("ABSTRACT:", x)), any(grepl("Key words", x)))))

sapply(txt[!sects], head)
lapply(txt[!sects][w], 
