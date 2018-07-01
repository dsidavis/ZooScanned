# Scanned Articles

We know a lot about the different formats from the regular PDF documents.
These apply to the scanned documnents also, so we want to incorporate that
knowledge.


## Title
Consider getting the *title* of a document.
+ Typically the title will span the entire width of the page.
+ It will have a larger font the rest of most of the text.
+ Its font may be bold.
+ It may be centered or left-aligned.
+ It may have mutiple lines.
+ We need to separate the title from the authors list.


We can look at the distribution of word heights
```
a = readRDS("Lagos Bat Virus/Tignor-1974_000.rds")
boxplot(a$top - a$bottom)
```




## Columns

Firstly, some of the papers we identify as scanned actually contain
a cover page that is not scanned. Furthermore, these cover pages tend to  be
a) single column, b) sparse in words.
Also, many papers (scanned or not) have a front page with a title and abstract
that span the width of the page and then columns come further down.
Depending on the number of lines in the abstract, this can cause difficulties
reliably detecting the columns.
We can find the BioOne cover page with
```
length(grep("BioOne", one[[33]]$text, val = TRUE, ignore.case = TRUE)) > 0
```

Many documents will have one or two columns. Fewer will have three.
Within multi-column articles, there will be text that spans these columns.
These make it difficult to identify the column start and ends.
If a column has few lines, it is hard to identify a few lines as column.

Columns are identified by several different characteristics
+ there are many lines that start at the same left position
+ there is an atypically large gap between words on the line 
+ there are several lines that start at the same left position AND the 
  lines are indented an (approximately) equal amount on either side
  being centered. These are, e.g., abstracts.
+ columns tend to equally divide the page
  
If we plot the distribution of the left locations of the recognized words,
we can see the 
```
a = readRDS("Tignor-1974_000.rds")
plot(density(a$left, charSize(a)))
```
We see three peaks in the density, two with approximately the same height.
These two are the starts of the two columns.
The third and slightly smaller peak corresponds to the start of the lines 
in the abstract.
Note also that the peak for the second column has fewer observations
just before the peak. This corresponds to the blank space between 
the two columns.
We might think there should be no observations in this interval.
However, there are some words in the abstract that start within this  interval.



Finding the columns is made complicated when the first line in a paragraph is indented
as this reduces the number of words at the same left location.



Day-1996:  The title, abstract, etc. are all left aligned and at the same location as the first
column.  As a result, the first column has many more words at the start position.
Therefore, the second column doesn't have enough words to be sufficiently close in count.
Note also the lines in the two columns do not line up.


Some pages have information such as "Download from http://...." running vertically
down the side of the page in text rotated 90 degrees.
Since these are rotated, the characters tend to be recognized as short word garbage.
As a result, this can appear as many items that make up an additional column.


```
b = readRDS("Swanepoel-1993_001.rds")
plot(density(b$left, charSize(b)))
```


### Gaps within Lines
If we could arrange the words into lines (see byLine()),
then we can compute the gap between adjacent  words.
We can compare the typical inter-word space as we go and
that should help us identify a gap of about 2.5 to 3 times the typical
spacing which identifies a column.

The function getLines() seems to do well on assembling the lines.



### Columns and Section Titles
If we can identify section titles, we can see if they are within a column.

```
ar = readRDS("./Western equine encephalitis/Artsob-1986_000.rds")
grep("INTRODUCTION", ar$text)
```
