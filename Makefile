# Makefile for "Complex networks, complex processes"
#
# Copyright (C) 2014-2017 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

# Root directory
ROOT = $(shell pwd)


# ----- Sources -----

# IPython notebooks in book order
HEADER = complex-networks-complex-processes.ipynb
NOTEBOOKS =  \
	preface.ipynb \
	introduction.ipynb \
	\
	part-getting-started.ipynb \
	getting-started.ipynb \
	concepts.ipynb \
	concepts-networks.ipynb \
	concepts-geometry.ipynb \
	concepts-paths.ipynb \
	concepts-degree.ipynb \
	concepts-processes.ipynb \
	\
	part-networks-processes.ipynb \
	er-networks.ipynb \
	er-networks-components.ipynb \
	er-networks-maths.ipynb \
	powerlaw.ipynb \
	percolation.ipynb \
	epidemic-spreading.ipynb \
	epidemic-compartmented.ipynb \
	epidemic-network.ipynb \
	epidemic-synchronous.ipynb \
	epidemic-gillespie.ipynb \
	\
	part-scale.ipynb \
	parallel.ipynb \
	parallel-ipython.ipynb \
	parallel-simple.ipynb \
	parallel-client.ipynb \
	parallel-async.ipynb \
	\
	part-topics.ipynb \
	configuration.ipynb \
	generating-functions.ipynb \
	spectral.ipynb \
	geodata.ipynb \
	\
	part-tools.ipynb \
	software-venv.ipynb \
	software-epyc.ipynb \
	software.ipynb \
	simulate.ipynb \
	\
	acknowledgements.ipynb \
	about.ipynb

# Additional source files
BIB = complex-networks.bib

# Image files
RAW_IMAGES = \
	cc-at-nc-sa.png \
	qr.png \
	konigsberg-bridges.png \
	sd.jpg
SVG_IMAGES = \
	concepts-paths.svg \
	ipython-parallelism.svg \
	ipython-local-parallelism.svg \
	ipython-local-parallelism-one.svg \
	ipython-mechanics.svg \
	ipython-remote-client-parallelism.svg \
	disease-periods.svg \
	disease-types.svg

# Source code that comes along with the book
SOURCES_DIR = src
SOURCES_CODE = \
	$(SOURCES_DIR)/setup.py \
	$(SOURCES_DIR)/cncp/__init__.py \
	$(SOURCES_DIR)/cncp/lattice.py \
	$(SOURCES_DIR)/cncp/ernetworks.py \
	$(SOURCES_DIR)/cncp/networkdynamics.py \
	$(SOURCES_DIR)/cncp/synchronousdynamics.py \
	$(SOURCES_DIR)/cncp/sirsynchronousdynamics.py \
	$(SOURCES_DIR)/cncp/sissynchronousdynamics.py \
	$(SOURCES_DIR)/cncp/stochasticdynamics.py \
	$(SOURCES_DIR)/cncp/sirstochasticdynamics.py \
	$(SOURCES_DIR)/cncp/sisstochasticdynamics.py
SOURCES_TESTS = \
	$(SOURCES_DIR)/test/__init__.py \
	$(SOURCES_DIR)/test/__main__.py \
	$(SOURCES_DIR)/test/sir.py \
	$(SOURCES_DIR)/test/sirsynchronous.py \
	$(SOURCES_DIR)/test/sirstochastic.py
TESTSUITE = test
SOURCES = $(SOURCES_CODE) $(SOURCES_TESTS)

# Python packages in reproducible virtual environments
# Computational environment, for running simulations
PY_COMPUTATIONAL = \
	ipython \
	cython \
	pyzmq \
	ipyparallel \
	numpy \
	scipy \
	mpmath \
	networkx \
	dill \
	pycrypto \
	paramiko \
	epyc
# Interactive environment, for running notebooks and building the book
PY_INTERACTIVE = \
	$(PY_COMPUTATIONAL) \
	jupyter \
	pandas \
	matplotlib \
	seaborn \
	jsonschema \
	tornado \
	pygments \
	jinja2 \
	beautifulsoup4 \
	mistune \
	pexpect \
	sphinx

# Packages that shouldn't be saved as requirements (because they're
# OS-specific, in this case OS X, and screw up Linux compute servers)
PY_NON_REQUIREMENTS = \
	appnope

# JSAnimation plug-in we use for the notebooks
JSANIMATION_DIST = https://github.com/jakevdp/JSAnimation/archive/master.zip
JSANIMATION_ZIP = jsanimation.zip
JSANIMATION_DIR = JSAnimation-master


# ----- Commands and options -----

# IPython and notebook functions
IPYTHON = ipython
PYTHON = python
JUPYTER = jupyter
SERVER = PYTHONPATH=$(SOURCES_DIR) $(JUPYTER) notebook --port 1626
NBCONVERT = $(JUPYTER) nbconvert
TEST = PYTHONPATH=$(SOURCES_DIR) $(IPYTHON) -m $(TESTSUITE)

# Other tools
PERL = perl
PYTHON = python
PIP = pip
VIRTUALENV = virtualenv
ACTIVATE = . bin/activate
RSYNC = rsync -av
BIB2X = $(PERL) ./bib2x --nodoi --visiblekeys --flat --sort
PANDOC = pandoc
INKSCAPE = inkscape
CONVERT = convert
PDFLATEX = pdflatex --interaction batchmode
BIBTEX = bibtex
MAKE = make
RM = rm -fr
MKDIR = mkdir -p
SH = sh
CHDIR = cd
TR = tr
CP = cp -r
MV = mv
CAT = cat
SED = sed -E
ZIP = zip
UNZIP = unzip
TAIL = tail
XARGS = xargs
WGET = wget

# Images in different formats
IMAGES = \
	$(RAW_IMAGES) \
	$(SVG_IMAGES)

# Bibliography
BIB_HTML = complex-networks-bib.html
BIB_TEX = complex-networks-bib.tex
BIB_NOTEBOOK_TEMPLATE = bibliography-template.ipynb
BIB_NOTEBOOK = bibliography.ipynb

# HTML build
HTML_TEMPLATE = basic
HTML_NBCONVERT = $(JUPYTER) nbconvert --to html --template $(HTML_TEMPLATE) 
HTML_HEADER = $(HEADER:.ipynb=.html)
HTML_NOTEBOOKS = $(NOTEBOOKS:.ipynb=.html)
HTML_IMAGES = $(RAW_IMAGES) $(SVG_IMAGES:.svg=.png)
HTML_FILES = $(HTML_HEADER) $(HTML_NOTEBOOKS) $(BIB_HTML)
HTML_ALL = $(HTML_FILES) $(HTML_IMAGES)


# Computational environments and requirements
ENV_COMPUTATIONAL = cncp-compute
ENV_INTERACTIVE = cncp
REQ_COMPUTATIONAL = cncp-compute-requirements.txt
REQ_INTERACTIVE = cncp-requirements.txt
NON_REQUIREMENTS = $(SED) $(patsubst %, -e '/^%*/d', $(PY_NON_REQUIREMENTS))


# ----- Top-level targets -----

# Default prints a help message, since it's all a bit complicated
help:
	@make usage

# Re-build the bibliography from the BibTeX source file
bib: $(BIB_NOTEBOOK)

# Build reproducible computational environments
env: env-computational env-interactive

# Update the dependencies for the computational environments
update: clean-env newenv-computational newenv-interactive

# Clean up the build
clean: clean-bib clean-zip clean-html clean-env

# Run the notebook
live: env-interactive
	($(CHDIR) $(ENV_INTERACTIVE) && $(ACTIVATE) && $(CHDIR) .. && $(SERVER))

# Run the source code test suite
test: env-computational
	($(CHDIR) $(ENV_COMPUTATIONAL) && $(ACTIVATE) && $(CHDIR) .. && $(TEST))


# ----- Bibliography in a notebook -----

$(BIB_HTML): $(BIB)
	$(BIB2X) --html --barebones $(BIB) >$(BIB_HTML)

$(BIB_TEX): $(BIB)
	$(BIB2X) --latex $(BIB) >$(BIB_TEX)

# Populate the bibliography template notebook
$(BIB_NOTEBOOK): $(BIB) $(BIB_HTML) $(BIB_NOTEBOOK_TEMPLATE)
	$(SED) -e 's/"/\\"/g' -e 's/.*/"&"/g' <$(BIB_HTML) >tmp1.html
	$(TAIL) -n +1 tmp1.html | ($(SED) -e 's/.*/&,/g' ; $(TAIL) -n 1 tmp1.html) >tmp2.html
	$(SED) -e '/%%BIBLIOGRAPHY%%/r tmp2.html' -e '/%%BIBLIOGRAPHY%%/d'  <$(BIB_NOTEBOOK_TEMPLATE) >$(BIB_NOTEBOOK)
	$(RM) tmp1.html tmp2.html

# Clean the generated notebook and LaTeX file
clean-bib:
	$(RM) $(BIB_NOTEBOOK) $(BIB_HTML) $(BIB_TEX)


# ----- HTML files -----

html: $(HTML_FILES)

clean-html:
	$(RM) $(HTML_FILES)


# ----- Computational environments -----

# Computation-only software
env-computational: $(ENV_COMPUTATIONAL)

newenv-computational:
	echo $(PY_COMPUTATIONAL) | $(TR) ' ' '\n' >$(REQ_COMPUTATIONAL)
	make env-computational
	$(NON_REQUIREMENTS) $(ENV_COMPUTATIONAL)/requirements.txt >$(REQ_COMPUTATIONAL)

# Interactive software
env-interactive: $(ENV_INTERACTIVE) jsanimation

newenv-interactive:
	echo $(PY_INTERACTIVE) | $(TR) ' ' '\n' >$(REQ_INTERACTIVE)
	make env-interactive
	$(NON_REQUIREMENTS) $(ENV_INTERACTIVE)/requirements.txt >$(REQ_INTERACTIVE)

# Only re-build computational environment if the directory is missing
$(ENV_COMPUTATIONAL):
	$(VIRTUALENV) $(ENV_COMPUTATIONAL)
	$(CP) $(REQ_COMPUTATIONAL) $(ENV_COMPUTATIONAL)/requirements.txt
	$(CHDIR) $(ENV_COMPUTATIONAL) && $(ACTIVATE) && $(XARGS) $(PIP) install <requirements.txt && $(PIP) freeze >requirements.txt

# Only re-build interactive environment if the directory is missing
$(ENV_INTERACTIVE):
	$(VIRTUALENV) $(ENV_INTERACTIVE)
	$(CP) $(REQ_INTERACTIVE) $(ENV_INTERACTIVE)/requirements.txt
	$(CHDIR) $(ENV_INTERACTIVE) && $(ACTIVATE) && $(XARGS) $(PIP) install <requirements.txt && $(PIP) freeze >requirements.txt

# Download and install the JSAnimation plug-in
# See https://gist.github.com/gforsyth/188c32b6efe834337d8a
jsanimation:
	$(CHDIR) $(ENV_INTERACTIVE) && $(ACTIVATE) && $(WGET) -O $(JSANIMATION_ZIP) $(JSANIMATION_DIST) && $(UNZIP) $(JSANIMATION_ZIP) && $(CHDIR) $(JSANIMATION_DIR) &&$(PYTHON) setup.py install

# Clean-up the generated environments
clean-env:
	$(RM) $(ENV_COMPUTATIONAL) $(ENV_INTERACTIVE)


# ----- Construction rules -----

.SUFFIXES: .svg .pdf .png .ipynb .html

.svg.pdf:
	$(INKSCAPE) $*.svg --export-pdf=$*.pdf

.svg.png:
	$(CONVERT) $*.svg $*.png

.ipynb.html:
	$(CHDIR) $(ENV_INTERACTIVE) && $(ACTIVATE) && $(CHDIR) .. && $(HTML_NBCONVERT) $*.ipynb


# ----- Usage -----

define HELP_MESSAGE
Building the book:
   make html    build as linked HTML files for blog

Maintenance:
   make bib     re-build the bibliography
   make clean   clean-up for a clean build

Running the code:
   make env     build virtualenvs using repo requirements.txt
   make update  re-build and update virtualenvs to latest package versions
   make live    run a notebook server 
   make test    run the test suite for the source code

endef
export HELP_MESSAGE

usage:
	@echo "$$HELP_MESSAGE"
