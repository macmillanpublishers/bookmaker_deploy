# Macmillan's Bookmaker Toolchain

This repository houses the .bat files that configure each implementation of the Bookmaker tool - an automated process for converting manuscripts into PDF and EPUB formats.

Each script in the Bookmaker sequence performs a distinct set of actions that builds on the scripts that came before, and depends on any number of other scripts or tools. These scripts were written specifically for use at Macmillan, and thus many of the filenames, arguments, and paths are direct references to that internal workflow. The scripts are as follows:

[tmparchive](https://github.com/macmillanpublishers/bookmaker_tmparchive): Creates the temporary working directory for the file to be converted, and opens an alert to the user telling them the tool is in use.

*Dependencies: Pre-determined folder structure*

[htmlmaker](https://github.com/macmillanpublishers/bookmaker_htmlmaker): Converts the input .xml file to HTML using wordtohtml.xsl.

*Dependencies: tmparchive, Java JDK, Saxon, wordtohtml.xsl*

[filearchive](https://github.com/macmillanpublishers/bookmaker_filearchive): Creates the directory structure for the converted filesbookmaker_coverchecker: Verifies that a cover image has been submitted. If yes, copies the cover image file into the final archive. If no, creates an error file notifying the user that the cover is missing.

*Dependencies: tmparchive, htmlmaker*

[imagechecker](https://github.com/macmillanpublishers/bookmaker_imagechecker): Checks to see if any images are referenced in the HTML file, and if those image files exist in the submission folder. If images are present, copies them to the final archive; if missing, creates an error file noting which image files are missing.

*Dependencies: tmparchive, htmlmaker, filearchive*

[coverchecker](https://github.com/macmillanpublishers/bookmaker_coverchecker): Checks to see if a front cover image file exists in the submission folder. If the cover image is present, copies it to the final archive; if missing, creates an error file noting that the cover is missing.

*Dependencies: tmparchive, htmlmaker, filearchive*

[chapterheads](https://github.com/macmillanpublishers/bookmaker_chapterheads): Copies EPUB and PDF css into the final archive, while also counting how many chapters are in the book and adjusting the CSS to suppress chapter numbers if only one chapter is found.

*Dependencies: tmparchive, htmlmaker, filearchive*

[pdfmaker](https://github.com/macmillanpublishers/bookmaker_pdfmaker): Preps the HTML file and sends to the DocRaptor service for conversion to PDF.

*Dependencies: tmparchive, htmlmaker, filearchive, imagechecker, coverchecker, chapterheads, SSL cert file, DocRaptor cloud service, doc_raptor ruby gem, ftp*

[epubmaker](https://github.com/macmillanpublishers/bookmaker_epubmaker): Preps the HTML file and converts to EPUB using the HTMLBook scripts.

*Dependencies: tmparchive, htmlmaker, filearchive, imagechecker, coverchecker, chapterheads, Saxon, HTMLBook, zip.exe*

[cleanup](https://github.com/macmillanpublishers/bookmaker_cleanup): Removes all temporary working files and working dirs.

*Dependencies: tmparchive, htmlmaker, filearchive, imagechecker, coverchecker, chapterheads*

## Required Folder Structure

The Bookmaker toolchain requires a specific folder structure and sequence of parent folders in order to function correctly. The requirements are as follows:

* The folder in which the conversion takes place should be nested within 2 parent folders, as foolows: _MainParentFolder/SubParentFolder/ConversionFolder/_
* The *main parent folder* lists the name of the imprint or book series. This naming must exactly match the css and images subfolders within the pdfmaker, epubmaker, and covermaker repositories.
* The *sub parent folder* should list the variant for the book series. For example, "galley_files", etc. This second level allows us to create different conversion instructions for the same series, if needed.
* The *conversion folder* is the folder where files to be converted should be dropped. It should contain _only_ the file to be converted.

At the same level as the conversion folder, two sibling folders are required, following these exact naming conventions:

* *submitted_images*: This is where any images (including book front cover) should be placed before initiating the conversion.
* *done*: This is where completed conversion will be archived automatically by Bookmaker.

Additionally, the following directory structures are required:
* All supplemental resources (saxon, zip) should live in the same parent folder, at the same level (i.e., they should be siblings to each other).
* All bookmaker scripts (including WordXML-to-HTML, HTMLBook, and covermaker) should live within the same parent folder, at the same level.
* A folder must exist for storing log files. This can live anywhere.
* A temporary working directory should be created, where Bookmaker can perform the conversions before archiving the final files. This can live anywhere.

The above four paths are configurable within the Bookmaker scripts--look for the following block:

    # --------------------USER CONFIGURED PATHS START--------------------
    # These are static paths to folders on your system.
    # These paths will need to be updated to reflect your current 
    # directory structure.
    
    # set temp working dir based on current volume
    tmp_dir = "#{currvol}\\bookmaker_tmp"
    # set directory for logging output
    log_dir = "S:\\resources\\logs"
    # set directory where bookmkaer scripts live
    bookmaker_dir = "S:\\resources\\bookmaker_scripts"
    # set directory where other resources are installed
    # (for example, saxon, zip)
    resource_dir = "C:"
    # --------------------USER CONFIGURED PATHS END--------------------