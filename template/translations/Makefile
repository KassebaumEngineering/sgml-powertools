#
# Makefile for sgml powertool scripts and executables
#

#list your translation names here
TRANSLATIONS=$(shell find * -type d -prune -print)

.PHONY: all install clean

all:
	for dir in $(TRANSLATIONS); do \
	    $(MAKE) -C $$dir ;\
	done

install:
	for dir in $(TRANSLATIONS); do \
	    $(MAKE) -C $$dir install ;\
	done

clean:
	for dir in $(TRANSLATIONS); do \
	    $(MAKE) -C $$dir clean ;\
	done

