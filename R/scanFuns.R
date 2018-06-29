
# Convert into separate images/pages
# Read images, read them back into a single data frame
#
# Get the number of columns
#    lines in one column that are staggered vertically from another.
# Find tables that span columns
# Section titles - all caps, on line by themselves.
#

combinePages =
function(boxes)
{
    ans = do.call(rbind, boxes)
    ans$page = rep(seq(along = boxes), sapply(boxes, nrow))
    class(ans) = c("MultiPageOCRResults", "data.frame")
    ans
}

SpeckRX = "^([[{}|_]+|LT|LL)$"
discardSpecks =
function(bbox, threshold = 50, speckRx = SpeckRX, maxNumChars = 3)
{
    w = isSpeck(bbox, threshold, speckRx, maxNumChars)
    bbox[!w,]
}

isSpeck =
function(bbox, threshold = 50, speckRx = SpeckRX, maxNumChars = 3)
{
   nchar(bbox$text) <= maxNumChars & bbox$confidence < threshold & grepl(speckRx, bbox$text) & !grepl("^[0-9]+$", bbox$text) 
}


allCaps =
function(x)
{
   x == toupper(x) & grepl("^[0-9.A-Z]+$", x) & !grepl("^[0-9.]+$", x)
}
