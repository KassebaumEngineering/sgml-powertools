#
# Makefile for sgml powertool scripts and executables
#

#list your translation names here
TRANSLATIONS=$(shell find * -type d -prune -print)

.PHONY: all install clean

all:
	for dir in $(TRANSLATIONS); do \
		if [ ! "$$dir" = "CVS" ]; then \
	        $(MAKE) -C $$dir ;\
		fi \
	done

install:
	for dir in $(TRANSLATIONS); do \
		if [ ! "$$dir" = "CVS" ]; then \
	        $(MAKE) -C $$dir install ;\
		fi \
	done

clean:
	for dir in $(TRANSLATIONS); do \
		if [ ! "$$dir" = "CVS" ]; then \
	        $(MAKE) -C $$dir clean ;\
		fi \
	done

