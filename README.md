# Macmillan's Bookmaker Toolchain

This repository houses the .bat files that configure each implementation of the Bookmaker tool--an automated process for converting manuscripts into PDF and EPUB formats.

Each script in the Bookmaker sequence performs a distinct set of actions that builds on the scripts that came before, and depends on any number of other scripts or tools. The actions are as follows:

[tmparchive](https://github.com/macmillanpublishers/bookmaker_tmparchive): Creates the temporary working directory for the file to be converted, and opens an alert to the user telling them the tool is in use.
Dependencies: Pre-determined folder structure

[htmlmaker](https://github.com/macmillanpublishers/bookmaker_htmlmaker): Converts the input .xml file to HTML using wordtohtml.xsl.
Dependencies: tmparchive, Java JDK, Saxon, wordtohtml.xsl

[filearchive](https://github.com/macmillanpublishers/bookmaker_filearchive): Creates the directory structure for the converted filesbookmaker_coverchecker: Verifies that a cover image has been submitted. If yes, copies the cover image file into the final archive. If no, creates an error file notifying the user that the cover is missing.
Dependencies: tmparchive, htmlmaker

[imagechecker](https://github.com/macmillanpublishers/bookmaker_imagechecker): Checks to see if any images are referenced in the HTML file, and if those image files exist in the submission folder. If images are present, copies them to the final archive; if missing, creates an error file noting which image files are missing.
Dependencies: tmparchive, htmlmaker, filearchive

[coverchecker](https://github.com/macmillanpublishers/bookmaker_coverchecker): Checks to see if a front cover image file exists in the submission folder. If the cover image is present, copies it to the final archive; if missing, creates an error file noting that the cover is missing.
Dependencies: tmparchive, htmlmaker, filearchive

[chapterheads](https://github.com/macmillanpublishers/bookmaker_chapterheads): Copies EPUB and PDF css into the final archive, while also counting how many chapters are in the book and adjusting the CSS to suppress chapter numbers if only one chapter is found.
Dependencies: pdf.css file originally stored in the bookmaker_pdfmaker/css/parent_project/ subfolder, epub.css file originally stored in the bookmaker_epubmaker/css/parent_project/ subfolder
Dependencies: tmparchive, htmlmaker, filearchive

[pdfmaker](https://github.com/macmillanpublishers/bookmaker_pdfmaker): Preps the HTML file and sends to the DocRaptor service for conversion to PDF.
Dependencies: tmparchive, htmlmaker, filearchive, imagechecker, coverchecker, chapterheads, SSL cert file, DocRaptor cloud service, doc_raptor ruby gem, ftp

[epubmaker](https://github.com/macmillanpublishers/bookmaker_epubmaker): Preps the HTML file and converts to EPUB using the HTMLBook scripts.
Dependencies: tmparchive, htmlmaker, filearchive, imagechecker, coverchecker, chapterheads, Saxon, HTMLBook, zip.exe

[cleanup](https://github.com/macmillanpublishers/bookmaker_cleanup): Removes all temporary working files and working dirs.
Dependencies: tmparchive, htmlmaker, filearchive, imagechecker, coverchecker, chapterheads