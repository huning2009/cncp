# Makefile for "Complex networks, complex processes"

# ----- Sources -----

# IPython notebooks in book order
HEADER = complex-networks-complex-processes.ipynb
NOTEBOOKS =  \
	introduction.ipynb \
	concepts.ipynb \
	er-networks.ipynb \
	powerlaw.ipynb \
	generating-networks.ipynb \
	spectral.ipynb \
	epidemic-spreading.ipynb \
	percolation.ipynb \
	software.ipynb
BIB_NOTEBOOK_TEMPLATE = bibliography-template.ipynb

# Additional source files
IMAGES = cc-at-nc-sa.png \
	qr.png \
	konigsberg-bridges.png
BIB = complex-networks.bib
DC_METADATA = metadata.xml

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
HTML_OPTIONS =
HTML_STYLESHEET = custom.css
HTML_PLUGINS = JSAnimation
HTML_NOTEBOOKS = $(HEADER:.ipynb=.html) $(NOTEBOOKS:.ipynb=.html) $(BIB_NOTEBOOK:.ipynb=.html)
HTML_FILES = $(HTML_NOTEBOOKS)
HTML_NOTEBOOK_EXTRAS = $(NOTEBOOKS:.ipynb=_files)
HTML_EXTRAS = $(HTML_STYLESHEET) $(HTML_PLUGINS) $(IMAGES)
WWW_POSTPROCESS = ./www-postprocess.py

# Zip'ped notebook output
ZIP_FILE = complex-networks-complex-processes.zip
ZIP_FILES = $(HEADER) $(NOTEBOOKS) $(BIB_NOTEBOOK) $(BIB) $(IMAGES) $(HTML_PLUGINS)

# EPUB output
EPUB_BUILD = build/ebook
EPUB_VERSION = epub3
EPUB = complex-networks-complex-processes.epub
EPUB_OPTIONS = -N --toc --toc-depth=2 
EPUB_INTERMEDIATE = complex-networks-complex-processes-intermediate.html
EPUB_COVER = cover.png
EPUB_STYLESHEET = epub.css
EPUB_FRONTMATTER = front.html
EPUB_BACKMATTER = back.html
# EPUB_NOTEBOOKS = $(NOTEBOOKS:.ipynb=.html) $(BIB_NOTEBOOK:.ipynb=.html)
EPUB_NOTEBOOKS = er-networks.html $(BIB_NOTEBOOK:.ipynb=.html)
EPUB_FILES = $(EPUB_NOTEBOOKS)
EPUB_EXTRAS = $(EPUB_FRONTMATTER) $(EPUB_BACKMATTER) $(IMAGES) $(EPUB_STYLESHEET) $(EPUB_COVER) $(DC_METADATA)
EPUB_POSTPROCESS = ./epub-postprocess.py

# PDF output
PDF_BUILD = build/pdf
PDF = complex-networks-complex-processes.pdf
PDF_OPTIONS = --chapters -N --listings +RTS -K512M -RTS
PDF_FRONTMATTER = front.tex
# PDF_NOTEBOOKS = $(NOTEBOOKS:.ipynb=.html) $(BIB_NOTEBOOK:.ipynb=.html)
PDF_NOTEBOOKS = er-networks.tex
PDF_FILES = $(PDF_NOTEBOOKS)
PDF_EXTRAS = $(IMAGES)
PDF_POSTPROCESS = ./pdf-postprocess.py


# ----- Top-level targets -----
# (Build and upload only the working distributions)

# Build all the distributions
all: zip www

# Upload all versions of the book to web server
upload: upload-zip upload-www

# Clean up the build
clean: clean-bib clean-zip clean-www clean-epub clean-pdf
	$(RM) $(HTML_NOTEBOOKS)


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
	$(RM) ttt1.html ttt2.html


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
gen-www: $(HTML_FILES) $(HTML_EXTRAS)

# Build HTML (web) versions of notebooks
www: gen-www
	$(MKDIR) $(HTML_BUILD)
	$(foreach fn, $(HTML_NOTEBOOKS), $(WWW_POSTPROCESS) $(fn) $(HTML_BUILD);)
	$(CP) $(HTML_EXTRAS) $(HTML_BUILD)

# Upload HTML version of book
upload-www: www
	cd $(HTML_BUILD) && \
	echo "Last updated $(TIMESTAMP)" >$(UPLOADED) && \
	$(RSYNC) \
	$(UPLOADED) \
	$(HTML_FILES) $(HTML_NOTEBOOK_EXTRAS) $(HTML_EXTRAS) \
	$(EXTRA_FILES) \
	$(HTML_STYLESHEET) $(HTML_PLUGINS) \
	$(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_DIR)

# Clean up the HTML book
clean-www:
	$(RM) $(HTML_BUILD)


# ----- E-book (EPUB) distribution -----
# Separate post-processing from EPUB generation so we can
# tweak the bundling proces without pre-processing every time

# EPUB HTML post-processing (quite expensive)
postprocess-epub: $(EPUB_FILES) $(EPUB_EXTRAS)
	$(MKDIR) $(EPUB_BUILD)
	$(foreach fn, $(EPUB_NOTEBOOKS), $(EPUB_POSTPROCESS) $(fn) $(EPUB_BUILD);)
	$(CP) $(BIBHTML) $(EPUB_EXTRAS) $(EPUB_BUILD)

# EPUB generation
# (First generate a single HTML file, then process this to EPUB)
gen-epub:
	cd $(EPUB_BUILD) && \
	$(PANDOC) \
	-o $(EPUB_INTERMEDIATE) \
	-R \
	--ascii \
	$(EPUB_FRONTMATTER) \
	$(EPUB_FILES) \
	$(EPUB_BACKMATTER) && \
	$(PANDOC) \
	-t $(EPUB_VERSION) \
	$(EPUB_OPTIONS) \
	--mathml \
	--epub-metadata=$(DC_METADATA) \
	--epub-stylesheet=$(EPUB_STYLESHEET) \
	--epub-cover-image=$(EPUB_COVER) \
	-o $(EPUB) \
	$(EPUB_INTERMEDIATE)

# Build e-book from notebooks
epub: postprocess-epub gen-epub

# Upload e-book
upload-epub: epub
	cd $(EPUB_BUILD) && \
	$(RSYNC) \
	$(EPUB) \
	$(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_DIR)

# Clean up the EPUB book
clean-epub:
	$(RM) $(EPUB_BUILD)


# ----- PDF distribution -----

# PDF HTML post-processing (quite expensive)
postprocess-pdf: $(PDF_FILES)
	$(MKDIR) $(PDF_BUILD)
	# $(foreach fn, $(PDF_NOTEBOOKS), $(PDF_POSTPROCESS) $(fn) $(PDF_BUILD);)
	$(CP) $(PDF_NOTEBOOKS) $(PDF_EXTRAS) $(PDF_BUILD)

# Build PDF of book from notebooks
gen-pdf:
	cd $(PDF_BUILD) && \
	$(PANDOC) \
	--to latex \
	$(PDF_OPTIONS) \
	-o $(PDF) \
	$(PDF_FILES)

# Build HTML (web) versions of notebooks
pdf: postprocess-pdf gen-pdf

# Upload PDF version of book
upload-pdf: pdf
	cd $(EPUB_BUILD) && \
	$(RSYNC) \
	$(PDF) \
	$(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_DIR)

# Clean up the PDF build
clean-pdf:
	$(RM) $(PDF_BUILD)


# ----- Construction rules -----

.SUFFIXES: .ipynb .bib .html .tex

.ipynb.html:
	$(CONVERT) --to html --template $(HTML_TEMPLATE) $(HTML_OPTIONS) $<

.ipynb.tex:
	$(CONVERT) --to latex $<

.bib.html:
	$(BIBTEX) $(BIB) >$(BIBHTML)

