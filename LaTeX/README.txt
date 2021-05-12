The final report template contains the following files:

fyp.tex         :	The main file.
config.tex      :	Contains configurations of the report. The student should enter their details at the top of this file.
prelude.tex     :	All material before the start of Chapter 1.
acknowledge.tex :	Acknowledgements go here.
summary.tex     :	The summary/abstract that will go at the very start.
appendix.tex    :	The appendix/appendices go here.
refs.bib        :	The bibliography as a bibtex file.
chapters/*.tex  :	The folder containing each of the chapters as a separate .tex file.
logo_black.png  :	The University of Leeds logo

Feel free to modify any and all files as necessary, as long as you remain within the required
specifications given on Minerva.

In particular:
- "fyp.tex" will need to be modified if you add any new chapters.
- "refs.bib" should be edited to include all references that are cited in the main report.

How to compile these files depends on your LaTeX installation. For the school Linux machines:
> latex fyp
> bibtex fyp
> latex fyp
> latex fyp
This will create a file called fyp.dvi which can be converted to postscript or pdf format using dvips or dvipdf,
respectively. The command pdflatex can be used to convert the file FYP.tex directly to pdf. Your choice may depend
on the format of the images included in your report.

To remove the blank page before a new chapter:
1. Open fyp.tex file
2. Locate the line containing "\documentclass[11pt,a4paper,twoside]{book}"
3. Replace it with the following line "\documentclass[11pt,a4paper,oneside]{book}"
4. Save and re-compile.


Original version Sam Wilson 12th March 2015
Updated Sam Wilson 7th May 2015.
Updated David Head 21st Sept. 2017.
Updated David Head 24th Sept. 2018.

