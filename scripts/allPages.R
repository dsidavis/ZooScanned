tiff = list.files(pattern = "\\.tiff$", full = TRUE, recursive = TRUE)
rds = gsub("\\.tiff$", ".rds", tiff)
ocrs = structure(lapply(rds, readRDS), names = gsub("\\.rds", "", rds))
ocrs = lapply(ocrs, function(x) {class(x) = c("OCRResults", "data.frame"); x })

# Combine all the data frames into one, first putting the file name on each row
tmp = mapply(function(x,  f) { x$file = f; x}, ocrs, names(ocrs), SIMPLIFY = FALSE)
o = do.call(rbind, tmp)


# Find the capitalized words that are more than 3 characters
source("ZooScanned/R/scanFuns.R")
k = allCaps(o$text)
caps = o$text[k]
caps3 = caps[nchar(caps) > 3]
sort(table(caps3), decreasing = TRUE)[1:100]

