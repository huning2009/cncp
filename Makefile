# Makefile for "Complex networks, complex processes"
#
# Copyright (C) 2014-2019 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Share Alike 4.0 
# International License (https://creativecommons.org/licenses/by-sa/4.0/).
#

# ----- Sources -----

# Notebooks in book order
HEADER = index.ipynb
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
	concepts-components.ipynb \
	concepts-processes.ipynb \
	concepts-stochastic.ipynb \
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
	software-epydemic.ipynb \
	epidemic-simulation.ipynb \
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
	excess-degree.ipynb \
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
BIB = cncp.bib

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
	disease-types.svg \
	synchronous-dynamics-uml.svg \
	stochastic-dynamics-uml.svg
IMAGES = \
        $(RAW_IMAGES) \
        $(SVG_IMAGES)
PNG_IMAGES = $(RAW_IMAGES) $(SVG_IMAGES:.svg=.png)

# JSAnimation plug-in we use for the notebooks
JSANIMATION_DIST = https://github.com/jakevdp/JSAnimation/archive/master.zip
JSANIMATION_ZIP = jsanimation.zip
JSANIMATION_DIR = JSAnimation-master

# Bibliography
BIB_HTML = complex-networks-bib.html
BIB_TEX = complex-networks-bib.tex
BIB_NOTEBOOK_TEMPLATE = bibliography-template.ipynb
BIB_NOTEBOOK = bibliography.ipynb


# ----- Tools -----

# Base commands
PYTHON = python3
IPYTHON = ipython
JUPYTER = jupyter
PIP = pip
VIRTUALENV = python3 -m venv
ACTIVATE = . $(VENV)/bin/activate
TR = tr
CAT = cat
SED = sed
RM = rm -fr
CP = cp
CHDIR = cd
ZIP = zip -r
INKSCAPE = inkscape
CONVERT = convert

# Root directory
ROOT = $(shell pwd)

# Requirements for running the book and for the 
VENV = venv3
REQUIREMENTS = requirements.txt
PY_REQUIREMENTS = $(shell $(CAT) $(REQUIREMENTS) | $(SED) 's/.*/"&"/g' | $(PASTE) -s -d, -)

# Constructed commands
RUN_SERVER = PYTHONPATH=. $(JUPYTER) notebook --port 1626
NON_REQUIREMENTS = $(SED) $(patsubst %, -e '/^%*/d', $(PY_NON_REQUIREMENTS))


# ----- Top-level targets -----

# Default prints a help message
help:
	@make usage

# Run the notebook server
live: env
	$(ACTIVATE)  && $(RUN_SERVER)

# Build a development venv from the known-good requirements in the repo
.PHONY: env
env: $(VENV)

$(VENV):
	$(VIRTUALENV) $(VENV)
	$(CP) $(REQUIREMENTS) $(VENV)/requirements.txt
	$(ACTIVATE) && $(CHDIR) $(VENV) && $(PIP) install -r requirements.txt

# Clean up everything, including the computational environment (which is expensive to rebuild)
clean: clean-bib
	$(RM) $(VENV)


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


# ----- Construction rules -----

.SUFFIXES: .svg .pdf .png .ipynb .html

.svg.pdf:
	$(INKSCAPE) $*.svg --export-pdf=$*.pdf

.svg.png:
	$(CONVERT) $*.svg $*.png


# ----- Usage -----

define HELP_MESSAGE
Editing:
   make live         run the notebook server

Maintenance:
   make env          create a known-good development virtual environment
   make newenv       update the development venv's requirements
   make clean        clean-up the build

endef
export HELP_MESSAGE

usage:
	@echo "$$HELP_MESSAGE"


