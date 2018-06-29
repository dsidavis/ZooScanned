# Process all of the tiff files via Rtesseract to get the OCR results
# And then run the tesseract command-line tool to get the text in columns, etc.

# This is run on the DSI compute server which has 72 cores.

tiff = list.files(pattern = "\\.tiff", full = TRUE, recursive = TRUE)
library(parallel)
library(Rtesseract)
system.time({xx = mclapply(tiff, function(f) {print(f); saveRDS(GetBoxes(f), gsub("\\.tiff$", ".rds", f))}, mc.cores = 40)})


system.time({xx = mclapply(tiff, function(f) {print(f); system(sprintf("tesseract '%s' '%s'", f, gsub("\\.tiff$", "", f)))}, mc.cores = 40)})
