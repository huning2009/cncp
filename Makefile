# Makefile for "Complex networks, complex processes"

# ----- Sources -----

# IPython notebooks in book order
HEADER = complex-networks-complex-processes.ipynb
NOTEBOOKS =  \
	preface.ipynb \
	introduction.ipynb \
	concepts.ipynb \
	er-networks.ipynb \
	percolation.ipynb \
	simulate.ipynb \
	powerlaw.ipynb \
	generating-networks.ipynb \
	spectral.ipynb \
	epidemic-spreading.ipynb \
	geodata.ipynb \
	parallel.ipynb \
	software.ipynb
BIB_NOTEBOOK_TEMPLATE = bibliography-template.ipynb

# Additional source files
IMAGES = \
	cc-at-nc-sa.png \
	qr.png \
	konigsberg-bridges.png \
	ipython-parallelism.pdf \
	ipython-parallelism.svg \
	ipython-parallelism.png \
	ipython-local-parallelism.pdf \
	ipython-local-parallelism.svg \
	ipython-local-parallelism.png
BIB = complex-networks.bib

# Python packages
PY_COMPUTATIONAL = \
	ipython \
	pyzmq \
	numpy \
	scipy \
	networkx
PY_INTERACTIVE = \
	$(PY_COMPUTATIONAL) \
	matplotlib \
	seaborn \
	tornado \
	jinja2

# Remote destinations
# (assumes the necessary keys are already installed)
REMOTE_USER = root
REMOTE_HOST = away.simondobson.org
REMOTE_DIR = /var/www/simondobson.org/complex-networks-complex-processes/content

# Timestamping
TIMESTAMP = `date "+%Y-%m-%d %H:%M"`
UPLOADED = UPLOADED.txt


# ----- Commands and options -----

# IPython functions
IPYTHON = ipython
SERVER = $(IPYTHON) notebook --port 1626
CONVERT = $(IPYTHON) nbconvert

# Other tools
PERL = perl
PYTHON = python
PIP = pip
VIRTUALENV = virtualenv
ACTIVATE = . bin/activate
RSYNC = rsync -av
BIB2X = $(PERL) ./bib2x --nodoi --visiblekeys --flat --sort
PANDOC = pandoc
PDFLATEX = pdflatex --interaction batchmode
BIBTEX = bibtex
MAKE = make
RM = rm -fr
MKDIR = mkdir -p
CHDIR = cd
CP = cp -r
MV = mv
SED = sed -E
ZIP = zip
TAIL = tail

# Bibliography
BIB_HTML = $(BIB:.bib=.html)
BIB_TEX = $(BIB:.bib=.tex)
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
WWW_POSTPROCESS = $(PYTHON) ./www-postprocess.py

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
PDF_NOTEBOOKS = $(NOTEBOOKS:.ipynb=.tex)
PDF_FILES = $(PDF_SKELETON) $(PDF_NOTEBOOKS) $(BIB_TEX)
PDF_EXTRAS = \
	$(UPLOADED) \
	$(BIB) \
	$(PDF_FRONTMATTER) $(PDF_BACKMATTER) \
	$(IMAGES)

# Computational environments
ENV_COMPUTATIONAL = cncp-compute
ENV_INTERACTIVE = cncp
ENV_REQUIREMENTS = requirements.txt


# ----- Top-level targets -----

# Build all the distributions of the book
all: zip www pdf

# Upload all versions of the book to web server
upload: upload-zip upload-www upload-pdf
	make clean-uploaded

# Build reproducible computational environments
environments: env-computational env-interactive

# Clean up the build
clean: clean-uploaded clean-bib clean-zip clean-www clean-pdf clean-environment
	$(RM) $(HTML_NOTEBOOKS)
	$(RM) $(NOTEBOOKS:.ipynb=_files) 

# Run the notebook
live: env-interactive
	($(CHDIR) $(ENV_INTERACTIVE) && $(ACTIVATE)) ; $(SERVER) &


# ----- Bibliography in a notebook -----

# Populate the bibliography template notebook
$(BIB_NOTEBOOK): $(BIB) $(BIB_HTML) $(BIB_NOTEBOOK_TEMPLATE)
	$(SED) -e 's/"/\\"/g' -e 's/.*/"&"/g' <$(BIB_HTML) >tmp1.html
	$(TAIL) -n +1 tmp1.html | ($(SED) -e 's/.*/&,/g' ; $(TAIL) -n 1 tmp1.html) >tmp2.html
	$(SED) -e '/%%BIBLIOGRAPHY%%/r tmp2.html' -e '/%%BIBLIOGRAPHY%%/d'  <$(BIB_NOTEBOOK_TEMPLATE) >$(BIB_NOTEBOOK)
	$(RM) tmp1.html tmp2.html

# Clean the generated notebook and LaTeX file
clean-bib:
	$(RM) $(BIB_NOTEBOOK) $(BIB_HTML) $(BIB_TEX)


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
	$(PDFLATEX) $(PDF_SKELETON:.tex=) ; \
	$(PDFLATEX) $(PDF_SKELETON:.tex=) ; \
	exit 0

# Upload PDF version of book
upload-pdf: pdf
	cd $(PDF_BUILD) && \
	$(RSYNC) \
	$(PDF) \
	$(REMOTE_USER)@$(REMOTE_HOST):$(REMOTE_DIR)

# Clean up the PDF build
clean-pdf:
	$(RM) $(PDF_NOTEBOOKS)
	$(RM) $(PDF_BUILD)


# ----- Computational environments -----

# Computation-only software
env-computational: $(ENV_COMPUTATIONAL)

# Interactive software
env-interactive: $(ENV_INTERACTIVE)

# Only re-build computational environment if the directory is missing
$(ENV_COMPUTATIONAL):
	$(VIRTUALENV) $(ENV_COMPUTATIONAL)
	$(CHDIR) $(ENV_COMPUTATIONAL) && $(ACTIVATE) && ($(foreach p, $(PY_COMPUTATIONAL), $(PIP) install $(p);)) && $(PIP) freeze >$(ENV_REQUIREMENTS)

# Only re-build interactive environment if the directory is missing
$(ENV_INTERACTIVE):
	$(VIRTUALENV) $(ENV_INTERACTIVE)
	$(CHDIR) $(ENV_INTERACTIVE) && $(ACTIVATE) && ($(foreach p, $(PY_INTERACTIVE), $(PIP) install $(p);)) && $(PIP) freeze >$(ENV_REQUIREMENTS)

# Clean-up the generated environments
clean-environment:
	$(RM) $(ENV_COMPUTATIONAL) $(ENV_INTERACTIVE)


# ----- Construction rules -----

.SUFFIXES: .ipynb .bib .html .tex .md

.ipynb.html:
	$(CONVERT) --to html $(HTML_OPTIONS) $<

.ipynb.tex:
	$(CONVERT) --to latex $(PDF_OPTIONS) $<

.ipynb.md:
	$(CONVERT) --to markdown $<

.bib.html:
	$(BIB2X) --html --barebones $(BIB) >$(BIB_HTML)

.bib.tex:
	$(BIB2X) --latex $(BIB) >$(BIB_TEX)

