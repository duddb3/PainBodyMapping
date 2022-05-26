# PainBodyMapping
Code to convert hand-marked diagrams of pain into maps in a common space in order to perform statistical analyses

![PainMap_AllMaps](https://user-images.githubusercontent.com/98111478/170510629-06ba1bfa-01fa-4555-a5c7-354d27a0cbf5.png)


## Converting pdf to png
The pain maps are marked by the participant by hand using a red sharpie on a piece of paper containing the front and back 2D view of the body. The first step is converting the digitized pdf of this pain map into a .png image file with PDFtoPNG

## Processing the pain map
Currently the process is as follows:
  1.  Crop the image of the sheet to include only the section containing the pain map
  2.  Get the "pain" areas by taking all pixels where the ratio of the red-to-green channel is greater than 1. NOTE: this means the pain must be marked in _red_
  3.  Calculate the similarity transformation (rotation, translation, and scale) that maps the outline of the scanned image to the template image.
  4.  Apply that transformation to the pain areas extracted in step 2.
  5.  Fill holes in the pain map
  6.  Apply gaussian smoothing (15 pixel standard deviation = ~3cm FWHM)
  7.  Mask out pain demarcations that fall outside of the 2D body
