The goal is to extract the elements of a journal article that has been scanned
rather than is a regular PDF document.
This is the same information we are extracting from regular PDF articles using
[ReadPDF](https://github.com/dsidavis/ReadPDF) and
[Zoonotics-shared](https://github.com/mespe/Zoonotics-shared).  We want to reuse much
of the knowledge and even the code from that.

## Files

+ The original PDF files of the scanned articls are [here](http://dsi.ucdavis.edu/Data/Zoonotics/scannedNewPDFs_pdf.tar.gz)
+ The tiff files from the original scanned PDF documents are [here](http://dsi.ucdavis.edu/Data/Zoonotics/scannedNewPDFs_tiff.tar.gz)
+ The results from running OCR via [Rtesseract]() on each image are available
  [here](http://dsi.ucdavis.edu/Data/Zoonotics/scannedNewPDFs_rds.tar.gz)
+ The resulting text files from running OCR via the command-line tesseract are [here](http://dsi.ucdavis.edu/Data/Zoonotics/scannedNewPDFs_txt.tar.gz)

So you don't need to work directly with the PDFs or the tiffs as we have already done the OCR
to get the text and the R data.frames.

Working with the R data.frames (the rds files) will be easier with the [Rtesseract]() package.


## Workflow

+ We start from a PDF a scanned document.
+ We convert this to a sequence of images, one per page in the PDF document (using the Makefile in 
   the Rtesseract package that calls ImageMagick's convert command-line utility.)
+ We run Rtesseract::GetBoxes() on each TIFF image to get the data.frame of top, left, right,
   bottom, text, confidence values for each word tesseract finds.
+ We run the command-line tesseract program to generate the lines of text that are separated into 


# Tasks
+ Look at 5 - 15 (or more) documents and try to identify patterns and strategies to programmatically
  identify 
     + article title, 
	 + section titles, 
	 + author names and affiliations, 
     + columns, 
	 + tables
	 + journal name
	 + page numbers
	 + footers and headers generally,
+ Build a training set of results we want to get for 5 - 15 documents (or more).



