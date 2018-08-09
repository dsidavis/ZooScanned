findTables =
function(base, pages = getPagesImages(base, ext), ext = "tiff")
{
  lapply(pages, findPageTables)
}

getPagesImages =
    # Change pdf file name to names of individual page images.
function(base, ext = "tiff")    
  list.files(dirname(base), pattern = gsub("\\.pdf$", sprintf("_[0-9]+.%s", ext), basename(base)), full = TRUE)    


findPageTables =
function(img, pix = pixConvertTo8(pixRead(img)),
         bin = pixThresholdToBinary(pix, 150),
         bbox = GetBoxes(bin),
         angle = pixFindSkew(bin),
         rotated = pixRotateAMGray(pix, angle[1]*pi/180, 255))
{
    i = findTableWord(bbox)
#browser()    
    hlines = getLines(rotated, 51, 3)
    #XXX For now, assume only one value in i !! Need to process each separately, but first up to the next, etc.
    w = sapply(hlines, function(x) x[1, "y0"] > bbox[i, "bottom"])
    if(!any(w)) {
       return(NULL)
    }
    # get the table declaration, the title, the lines of text between the lines
    # Then try to figure out if there are footnotes below the table that should be incorporated.

    ys = sapply(hlines, function(x) x[1, "y0"])
    title = bbox[ bbox$bottom >= bbox[i, "bottom"] - 10 & bbox$top < min(ys), ]
    body = bbox[ bbox$bottom >= min(ys) & bbox$top < max(ys), ]    

    list(title = title, body = body)
}


findTableWord =
    #
    # returns the row number of bb corresponding to a Table "declaration" (not reference)
    #
function(bb)
{
    i = grep("table|tabela", bb$text, ignore.case = TRUE)
    # See if this is "followed by" a number with a closing ).
    # so that this is a reference to a table.
    # Followed by here means next row in the data frame.  Really we need
    # next position on the page, i.e., x, y with and height.
    # Works for Iverson for now.
    w = !grepl("\\(", bb$text[i]) & !grepl("\\)", bb$text[i+1])
    
    i[w]
}
