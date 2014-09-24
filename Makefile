# Makefile for "Complex networks, complex processes"

# ----- Sources -----

# IPython notebooks in book order
HEADER = complex-networks-complex-processes.ipynb
NOTEBOOKS =  \
	preface.ipynb \
	introduction.ipynb \
	concepts.ipynb \
	er-networks.ipynb \
	powerlaw.ipynb \
	generating-networks.ipynb \
	spectral.ipynb \
	epidemic-spreading.ipynb \
	percolation.ipynb \
	parallel.ipynb \
	software.ipynb
BIB_NOTEBOOK_TEMPLATE = bibliography-template.ipynb

# Additional source files
IMAGES = cc-at-nc-sa.png \
	qr.png \
	konigsberg-bridges.png
BIB = complex-networks.bib

# Remote destination
# (assumes the necessary keys are already installed)
REMOTE_USER = root
REMOTE_HOST = away.simondobson.org
REMOTE_DIR = /var/www/simondobson.org/complex-networks-complex-processes

# Timestamping
TIMESTAMP = `date "+%Y-%m-%d %H:%M"`
UPLOADED = UPLOADED.txt


# ----- Commands and options -----

# IPython functions
IPYTHON = ipython
SERVER = $(IPYTHON) notebook
CONVERT = $(IPYTHON) nbconvert

# Other tools
RSYNC = rsync -av
BIBTEX = bib2x --nodoi -t --barebones --html --visiblekeys
PANDOC = pandoc
PDFLATEX = pdflatex --interaction batchmode
RM = rm -fr
MKDIR = mkdir -p
CP = cp -r
MV = mv
SED = sed -E
ZIP = zip
TAIL = tail

# Bibliography in a notebook
BIBHTML = $(BIB:.bib=.html)
BIB_NOTEBOOK = bibliography.ipynb

# Web HTML output
HTML_BUILD = build/www
HTML_TEMPLATE = full
HTML_OPTIONS = --template $(HTML_TEMPLATE) 
HTML_STYLESHEET = custom.css
HTML_PLUGINS = JSAnimation
HTML_NOTEBOOKS = $(HEADER:.ipynb=.html) $(NOTEBOOKS:.ipynb=.html) $(BIB_NOTEBOOK:.ipynb=.html)
HTML_FILES = $(HTML_NOTEBOOKS)
HTML_EXTRAS = \
	$(HTML_STYLESHEET) \
	$(HTML_PLUGINS) \
	$(IMAGES) \
	$(UPLOADED)
WWW_POSTPROCESS = ./www-postprocess.py

# Zip'ped notebook output
ZIP_FILE = complex-networks-complex-processes.zip
ZIP_FILES = \
	$(HEADER) \
	$(NOTEBOOKS) \
	$(BIB_NOTEBOOK) $(BIB) \
	$(IMAGES) $(HTML_PLUGINS) \
	$(UPLOADED)

# PDF output
PDF_BUILD = build/pdf
PDF_TEMPLATE = complex-networks-complex-processes
PDF_OPTIONS = --template $(PDF_TEMPLATE)
PDF = complex-networks-complex-processes.pdf
PDF_SKELETON = complex-networks-complex-processes.tex
PDF_FRONTMATTER = front.tex
PDF_BACKMATTER = back.tex
PDF_NOTEBOOKS = $(NOTEBOOKS:.ipynb=.tex) $(BIB_NOTEBOOK:.ipynb=.tex)
PDF_FILES = $(PDF_SKELETON) $(PDF_NOTEBOOKS) bibliography.tex
PDF_EXTRAS = \
	$(UPLOADED) \
	$(PDF_FRONTMATTER) $(PDF_BACKMATTER) \
	$(IMAGES)


# ----- Top-level targets -----

# Build all the distributions
all: zip www pdf

# Upload all versions of the book to web server
upload: upload-zip upload-www upload-pdf

# Clean up the build
clean: clean-uploaded clean-bib clean-zip clean-www clean-pdf
	$(RM) $(HTML_NOTEBOOKS)
	$(RM) $(NOTEBOOKS:.ipynb=_files) 


# ----- Bibliography in a notebook -----

# Build the notebook
bib: $(BIB_NOTEBOOK)

# Populate the bibliography template notebook
$(BIB_NOTEBOOK): $(BIB) $(BIBHTML) $(BIB_NOTEBOOK_TEMPLATE)
	$(SED) -e 's/"/\\"/g' -e 's/.*/"&"/g' <$(BIBHTML) >tmp1.html
	$(TAIL) +1 tmp1.html | ($(SED) -e 's/.*/&,/g' ; $(TAIL) -1 tmp1.html) >tmp2.html
	$(SED) -e '/%%BIBLIOGRAPHY%%/r tmp2.html' -e '/%%BIBLIOGRAPHY%%/d'  <$(BIB_NOTEBOOK_TEMPLATE) >$(BIB_NOTEBOOK)
	$(RM) tmp1.html tmp2.html

# Clean the generated notebook
clean-bib:
	$(RM) $(BIB_NOTEBOOK) $(BIBHTML)


# ----- Creation timestamp -----

# Generate a timestamp file
$(UPLOADED):
	echo "Last updated $(TIMESTAMP)" >$(UPLOADED)

# Clean the timestamp file
clean-uploaded:
	$(RM) $(UPLOADED)


# ----- Notebook (ZIP) distribution -----

# Package notebooks as a ZIP file
zip: $(ZIP_FILES)
	$(ZIP) $(ZIP_FILE) $(ZIP_FILES)

# Upload ZIP file of notebooks
upload-zip: zip
	$(RSYNC) \
	$(ZIP_FILE) \
	$(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_DIR)

# Clean up the ZIP'ped notebooks
clean-zip:
	$(RM) $(ZIP_FILE)


# ----- Interactive HTML (www) distribution -----

# Pre-process notebooks to HTML
gen-www: $(HTML_FILES)

# Build HTML (web) versions of notebooks
www: gen-www
	$(MKDIR) $(HTML_BUILD)
	$(foreach fn, $(HTML_NOTEBOOKS), $(WWW_POSTPROCESS) $(fn) $(HTML_BUILD);)
	$(CP) $(HTML_EXTRAS) $(HTML_BUILD)

# Upload HTML version of book
upload-www: www
	cd $(HTML_BUILD) && \
	$(RSYNC) \
	$(UPLOADED) \
	$(HTML_FILES) $(HTML_EXTRAS) \
	$(EXTRA_FILES) \
	$(HTML_STYLESHEET) $(HTML_PLUGINS) \
	$(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_DIR)

# Clean up the HTML book
clean-www:
	$(RM) $(HTML_BUILD)


# ----- PDF distribution -----

# PDF post-processing
gen-pdf: $(PDF_FILES) $(UPLOADED)
	$(MKDIR) $(PDF_BUILD)
	$(foreach dn, $(PDF_NOTEBOOKS:.tex=_files), if [ -d $(dn) ]; then $(CP) $(dn) $(PDF_BUILD); fi;)
	$(CP) $(PDF_FILES) $(PDF_EXTRAS) $(PDF_BUILD)

# Generate PDF file via LaTeX
pdf: gen-pdf
	cd $(PDF_BUILD) && \
	$(PDFLATEX) $(PDF_SKELETON) ; \
	$(PDFLATEX) $(PDF_SKELETON)

# Upload PDF version of book
upload-pdf: pdf
	cd $(EPUB_BUILD) && \
	$(RSYNC) \
	$(PDF) \
	$(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_DIR)

# Clean up the PDF build
clean-pdf:
	$(RM) $(PDF_NOTEBOOKS)
	$(RM) $(PDF_BUILD)


# ----- Construction rules -----

.SUFFIXES: .ipynb .bib .html .tex .md

.ipynb.html:
	$(CONVERT) --to html $(HTML_OPTIONS) $<

.ipynb.tex:
	$(CONVERT) --to latex $(PDF_OPTIONS) $<

.ipynb.md:
	$(CONVERT) --to markdown $<

.bib.html:
	$(BIBTEX) $(BIB) >$(BIBHTML)

