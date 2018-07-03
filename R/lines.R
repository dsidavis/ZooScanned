byLine =
    #
    # q = .65  works forn Sentsui-1985
    #
function(a, lineskip = quantile(a$top - a$bottom, q), q = .65, asText = FALSE) 
{    
    k = seq(min(a$bottom) - 3, max(a$top) + 3, by = lineskip)    
    ll = split(a, cut((a$top + a$bottom)/2, k))
    ll = ll[ sapply(ll, nrow) > 0 ]
    if(asText)
       unname(sapply(ll, function(x) paste(x$text, collapse = " ")))
    else
       ll
}    

showLines =
function(ll, h = 6000)
{        
    d = sapply(ll, function(x) c(min(x$bottom), max(x$top)))
    abline(h = h - as.numeric(d), col = c("red", "blue"))
}


findHGapInLines =
function(x, drop = TRUE)
{
    if(drop)
        x = x[sapply(x, nrow) > 1]
    
    structure(t(sapply(x, findHGapInLine)), class = c("WithinLineGaps", "matrix"))
}

findHGapInLine =    
function(x)    
{
    if(nrow(x) == 0)
        return(c(median = NA, max = NA))
    else if(nrow(x) == 1)
        return(structure(rep(0, 2), names = c("median", "max")))        
#        return(structure(rep(x$right - x$left, 2), names = c("median", "max")))
    
    x = x[order(x$left), ]
    d = x$left[-1] - x$right[-nrow(x)] 
    c(median = median(d), max = max(d))
}

plot.WithinLineGaps =
function(x, ...)    
{
    plot(x[,2], nrow(x):1, axes = FALSE, ...)
    box()
    axis(1)
    v = 1:nrow(x) # pretty(1:nrow(x))
    axis(2, at = v, rev(v))
}


findMaxGaps =
function(x)
{
    structure(sapply(x, function(x) {
                 x = x[order(x$left), ]
                 d = x$left[-1] - x$right[-nrow(x)]
                 i = which.max(d)
                 x$right[-nrow(x)][i]
        }), names = as(x, "character"))
}


getNumColsByLine =
function(x, ll = as(x, "OCRLines"), threshold = 2.5*charWidth(x))
{
    tmp = sapply(ll, function(x) sum(isColGap(x, threshold)))
}

isColGap =
function(x, threshold)
   (x$left[-1] - x$right[-nrow(x)]) > threshold    


linesByCol =
function(ll, threshold = charWidth(ll)*2.5)
{
    sapply(ll, function(x) split(x$text, cumsum(c(FALSE,  isColGap(x, threshold)))))
}






getColumns =
function(x, threshold = charWidth(x), propOfMax = .6, pctOfWords = .015)
{
    pos = seq(min(x$left) - 2, max(x$right) + 2, by = threshold)
    tt = table(cut(x$left, pos))

    numWords = if(pctOfWords > 1) pctOfWords else pctOfWords*nrow(x)
    
    w = which(tt > propOfMax*max(tt) & tt > numWords)
#browser()
     # If two of the intervals are adjacent, just report the first of these.
    d = diff(w)
    if(any(d == 1)) {
        w = w
        w = w[ - (which(d == 1) + 1)]
    }

    tmp = split(x, cut(x$left, pos))[w]
    lineskip = 2.5*median(x$top - x$bottom)
    ok = sapply(tmp, function(x) median(diff(sort(x$top)))) < lineskip 
#browser()
    w = w[ ok ]
    
    cols = pos[-length(pos)][w]

    cols = cols[cols > 0]

    if(sum(x$left  < min(cols)) > 30) {
        # or min(cols) > 1500 or half the width
        # so only found the "second" column, missing one or more on the left.
        pos = seq(min(x$left) - 2, min(cols) + 2, by = threshold)
        tt = table(cut(x$left, pos))
        a = pos[-length(pos)][which.max(tt)]
        cols = c(a , cols)
    }
    cols
}


getNumColumns =
function(x, threshold = charWidth(x), propOfMax = .65, pctOfWords = .015)
{
    pos = seq(min(x$left) - 2, max(x$right) + 2, by = threshold)
    tt = table(cut(x$right, pos))

    numWords = if(pctOfWords > 1) pctOfWords else pctOfWords*nrow(x)
    w = tt > propOfMax*max(tt) & tt > numWords
    #    browser()
     # If two of the intervals are adjacent, just report the first of these.
    d = diff(which(w))
    if(any(d == 1)) {
        w = which(w)
        w = w[ - (which(d == 1) + 1)]
    }
    cols = pos[-length(pos)][w]

    cols = cols[cols > 0]
    cols
}

getColPos =
function(x)
{

}

charWidth =
function(x, q = .5)
    UseMethod("charWidth")

charWidth.OCRLines =
function(x, q = .5)
{
    charWidth(do.call(rbind, x), q)
}

charWidth.data.frame =
function(x, q = .5)    
    quantile((x$right - x$left)/nchar(x$text), q)

charHeight =
function(x, q = .5)
   quantile((x$top - x$bottom), q)    



isBioOne =
   # see the version in ReadPDF
function(x)
{
    length(grep("BioOne", x$text, val = TRUE, ignore.case = TRUE)) > 0
}



findPeaks =
function(vals, peaks = TRUE)
{        
  sapply(seq(along = vals), if(peaks) isPeak  else isTrough, vals) 
}

isPeak = function(i, vals) if(i == 1 || i == length(vals)) FALSE  else vals[i] > vals[i-1] && vals[i] > vals[i+1]
isTrough = function(i, vals) if(i == 1 || i == length(vals)) FALSE  else vals[i] <= vals[i-1] && vals[i] <= vals[i+1]

getLines =
    #
    #  bw = 19 seems to work for Artsob-1986. The original 20 was just made up.
    #  bw controls the smoothing of the density. The smaller the bandwidth, the more "wiggle" there is and we can pick up troughs.
    #
function(df, d = density((df$top+df$bottom)/2, bw), bw = 19, asText = FALSE)
{

    ll2 = split(df, cut((df$top + df$bottom)/2, c(0, d$x[findPeaks(d$y, FALSE)], max(df$top))))
    if(asText)
        sapply(ll2, function(x) paste(x$text, collapse = " "))
    else
        structure(ll2, class = "OCRLines")
}

setOldClass(c("OCRLines", "list"))
setAs("OCRLines", "character",
      function(from)
          unname(sapply(from, function(x) paste(x$text, collapse = " "))))


getInterlineSkip =
function(x)
{
    x = as(x, "OCRLines")
    sapply(seq(along = x)[-length(x)], function(i)  min(x[[i+1]]$bottom) - max(x[[i]]$top))
}

setAs("OCRResults", "OCRLines", function(from) getLines(from))


