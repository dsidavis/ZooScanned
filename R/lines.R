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


findGapInLines =
function(x)
{
   t(sapply(x, findGapInLine))
}

findGapInLine =    
function(x)    
{
    x = x[order(x$left), ]
    d = x$left[-1] - x$right[-nrow(x)] 
#browser()    
    c(median = median(d), max = max(d))
}

getColumns =
function(x, threshold = charWidth(x), propOfMax = .6, pctOfWords = .015)
{
    pos = seq(min(x$left) - 2, max(x$right) + 2, by = threshold)
    tt = table(cut(x$left, pos))

    numWords = if(pctOfWords > 1) pctOfWords else pctOfWords*nrow(x)
    
    w = which(tt > propOfMax*max(tt) & tt > numWords)
browser()
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
function(df, d = density((df$top+df$bottom)/2, bw), bw = 20, asText = FALSE)
{

    ll2 = split(df, cut((df$top + df$bottom)/2, c(0, d$x[findPeaks(d$y, FALSE)], max(df$top))))
    if(asText)
        sapply(ll2, function(x) paste(x$text, collapse = " "))
    else
        ll2
}
