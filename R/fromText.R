# Functions to extract the sections from the text output of the OCR command line
# which handles columns for us.

# TODO
# 1. Fixup title - first section.
#         ./Guaroa Virus/Groot-1959
# 2. Deal with tables, i.e. extract them separately

# 4. [partial] Headers and footers (partially done, but not generally)
# 3. [heuristics in place to deal with this]  Figures and finding text from figures that is used as section titles.


# The cmdline OCR doesn't handle INTRODUCTION centered in one column and text in the next column. It joins them. See Neitzel-1991.
# See Swanepoel-1993 also for the INTRODUCTION.

# And the abstract is getting confused in Swanepoel-1993 because of the list of authors being matched as a section title since all capitals.

## FIGURES
# Ubico-1995 - section titles from Figure 1's image. e.g. CARIBBEAN SEA, HONDURAS
# Same with Rawlings-1996 from many figures/images
# Reissen-1195

# ./Crimean Congo Hemorrhagic Fever Virus/Zeller-1997" - one author on line by self under the others. Need to combine these.


# Check ./Ockelbo Virus/Shirako-1991 

getDocElements =
    # txt  - a character vector containing the text from all of the pages
    #  actually probably want a list of the pages contents so we can find the top and bottom
    # easily and remove headers and footers.
    # So use a tapply()
function(files, txt = lapply(seq(along = files), function(i) readText(files[i], i)), dropReferences = TRUE)  # Lines, warn = FALSE))
{
    # Clean the headers and footers
    pages = txt
    txt = removeHeaderFooters(txt)
    txt = unlist(txt)
    txt = discardBlankLines(txt)
    ti = findSectionTitles(txt)
    w =  isInFigure(txt, ti, pages)
    w = w[ order(as.integer(names(w))) ]

    ok = unlist(w)
    if(any(!ok)) {
        i = which(ti)
        if(any(grepl("MATERIALS|RESULTS" , txt[ti][!ok])))
            stop("dropping important: ",  paste(txt[ti][!ok], collapse = ", "))
        else {
            w = simpleWarning("dropping section titles")
            class(w) = c("DropSectionTitles", class(w))
            w$sections = txt[ti][!ok]
            message("Dropping ", paste(w$sections, collapse = ", "))
            warning(w)
#            warning("dropping ", paste(txt[ti][!ok], collapse = ", "))
        }
        ti[ i[!ok] ] = FALSE
    }
#browser()
    
    sections = split(txt, cumsum(ti))
    names(sections) = sapply(sections, function(x) mkSectionName(x[1]))

    # If a title is split across two lines (eg. Swanepoel-1993) we can patch it up here.
    w = sapply(sections, length) == 1
    if(any(w)) {
        i = which(w)
        tmp = mapply(c, sections[i], sections[i+1], SIMPLIFY = FALSE)
        sections[i+1] = tmp
        names(sections)[i+1] = paste(names(sections)[i], names(sections)[i+1])
        sections = sections[-i]
    }
   

    if(length(i <- grep("^abstract", names(sections), ignore.case = TRUE))) {
        tmp = fixColumns(sections[[i]])
        if(length(tmp) > 1) {
            # Combine it with the next section? or create a new section
            if(FALSE) {
                sections[[i+1]] = unlist(c(tmp[[2]], sections[[i+1]]))
                sections[[i]] = tmp[[1]]
            } else {
                names(tmp) = c(names(sections)[i], "")
                sections = c(sections[1:(i-1)], tmp, sections[(i+1):length(sections)])                
#                sections = c(sections[1:(i-1)], tmp[[1]], tmp[[2]], sections[(i+1):length(sections)])
#                names(sections) = c(v[1:i], "", v[(i+1):length(v)])
            }
        }
    }

    if(dropReferences) {
        w = tolower(names(sections)) %in% c("literature cited", "references", "references cited")
        if(any(w)) {
            i = which(w)
            if(i < length(sections))
                warning("removing sections after references: ", paste(names(sections)[(i+1): length(sections)], collapse = ", "))

            sections = sections[1:(i-1)]
        }
    }
    
    sections
}


findSectionTitles =
function(x)
{
    grepl("^(Abstract([.:]?)|Discussion|Introduction|Materials and Methods|References|(Literature|References) Cited|Conclusions?|Acknowledgments|Acknowlegements|Results|Summary|Study (area|design))$", x, ignore.case = TRUE) |
        grepl("ABSTRACT[ .:]|Key words[ :]", x, ignore.case = TRUE) |
        grepl("^([0-9.]+ )?[-A-Z,. ]+$", x) &
        !isSequenceOfNames(x) & !isGeneSeq(x) &
        nchar(x) > 3 &
        !grepl("^TABLE", x)
}

isGeneSeq =
function(x, threshold = .9)
{
  nchar(x) > 30 & length(gregexpr("[ACGTUYR]", x)) > nchar(x)*threshold
}

isSequenceOfNames =
function(x)
{
  grepl("([A-Z ]+, ([A-Z]\\.)+)+", x)
}

discardBlankLines =
function(x)
{
    x = XML:::trim(x)
    w = which(x == "")
    w = w[ grepl("^[a-z]", x[w + 1]) ]
    x[-w]
}

mkSectionName =
function(x)
{
    if(grepl("^(abstract|key words)", x, ignore.case = TRUE))
        gsub("^(abstract|key words).*", "\\1", x, ignore.case = TRUE)
    else
        x
}


removeHeaderFooters =
function(x)
{
#   v = data.frame(values = unlist(x), page = rep(seq(along = x), sapply(x, length)), stringsAsFactors = FALSE)
    #   tmp = split(v, v$values)

    lapply(x, removeHeader)
}

removeHeader =
function(x)
{        
    i = grepl("^([0-9]+ +)?[A-Z ]+ (ET AL\\.|AND OTHERS)( +[0-9]+)?$", x)
    if(any(i))
      x =  x[- which(i)[1]]

    x = grep("journal of wildlife diseases|institut pasteur/|vet\\. pathol\\. [0-9]+:[0-9]+-[0-9]+|short communication|virology [0-9]+|copyright ©|downloaded from http|oxford university press|veterinary microbiology|veterinary record|press\\.com by calif dig lib|transactions of the royal society|journal of|onderstepoort journal of|wildlife disease association|am\\. j\\. trop\\. med\\. hyg\\.", x, invert = TRUE, value = TRUE, ignore.case = TRUE)
    
    x
}


fixColumns =
    #
    # This is for handling the sections that do not have a new section title to divide them
    # but for which we have, e.g. an abstract that spans 2 columns and then start the next implict section with a column.
    #
function(sect)
{
    #    tmp = sapply(sects, spansCols)
    spansCols(sect)
    # function(x) length(x) > 5 & sum(nchar(x) > 60) > 4 & sum(nchar(x) < 48) > 4) 
#  sapply(sects, splitC
}

spansCols =
function(x)
{
#   x = x[x!= ""]
#   w = nchar(x) > 60
    #   rle(w)

    pars = split(x, cumsum(x == ""))
    len = sapply(pars, function(x) quantile(nchar(x), .85))
    w = sum(len > 75) > 0 & sum(len < 60) > 1

    if(w) {
        r = rle(len > 75 | sapply(pars, length) == 1)
        i= seq_len(r$lengths[1])
        list(unlist(lapply(pars[ i ], c, "")), unlist(lapply(pars[-i], c, "")))
    } else
        list(x)
        
#    length(x) > 5 & sum(nchar(x) > 60) > 4 & sum(nchar(x) < 48) > 4    
}



readText =
function(f, pageNum = NA)
{
    ll = readLines(f, warn = FALSE)
    names(ll) = rep(pageNum, length(ll))
    ll = XML:::trim(ll)
    i = which(ll != "")[1]
    ll[i:length(ll)]
}


isInFigure =
function(txt, ti, pages)
{
   byp = split(data.frame(text = txt, isTitle = ti, page = names(ti), stringsAsFactors = FALSE), names(ti))
   sapply(byp, isInFigure2)
}

isInFigure2 =
function(df)    
{
    q = quantile( nchar(df$text), .8 )

    df$isFigure = grepl("^ *Figure [0-9]+", df$text, ignore.case = TRUE)
    if(!any(df$isFigure))
       return(df$isTitle[df$isTitle])

    if(q < 55)
        cols = split(df, 1:nrow(df) >= (nrow(df)/2))
    else
        cols = list(df)

    unlist( sapply(cols, function(x) { if(any(x$isFigure)) {
                                           i = which(x$isTitle)
                                           j = which(x$isFigure)
                                           structure(i >= min(j), names = x$text[x$isTitle])
                                       } else
                                           x$isTitle[x$isTitle]
                                     }))
}
