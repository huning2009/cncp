# Makefile for compute VM 
# 
# Copyright (C) 2015 Simon Dobson
# 
# Licensed under the Creative Commons Attribution-Noncommercial-Share
# Alike 3.0 Unported License (https://creativecommons.org/licenses/by-nc-sa/3.0/).
#

BOX = cncp-compute.box

# Build tools
VAGRANT = vagrant
RM = rm -fr


# ----- Top-level targets -----

# Help by default
help:
	@make usage

# Build and package the VM
all: up package

# Build and provision the VM
up:
	$(VAGRANT) up

# Package the VM
package:
	$(RM) $(BOX)
	$(VAGRANT) package --output $(BOX)

# Clean-up the build
clean:
	$(VAGRANT) destroy -f
	$(RM) $(BOX)


# ----- Usage -----

define HELP_MESSAGE
Building the compute server VM:
   make all       build and package the VM as a Vagrant Box
   make up        build and provision the compute VM
   make package   package the VM as a Vagrant Box
   make clean     tear-down the VM and delete the box
endef
export HELP_MESSAGE

usage:
	@echo "$$HELP_MESSAGE"
