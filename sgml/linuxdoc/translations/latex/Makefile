#
# Makefile for sgml powertool scripts and executables
#

#put your translation name here
TRANSLATION=latex

DESTDIR=$(INSTALLDIR)/sgml/$(DTDNAME)/translations/$(TRANSLATION)

# Modify this line if you do not use some of these scripts
FILES=general mapping
SCRIPTS=translate
TEXFILES=$(wildcard tex/*)

.PHONY: all install clean

all:

install:
	-mkdir $(DESTDIR)
	-mkdir $(DESTDIR)/tex
	for file in $(FILES); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 644 $(DESTDIR)/$$file ;\
	done
	for file in $(SCRIPTS); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 755 $(DESTDIR)/$$file ;\
	done
	for file in $(TEXFILES); do \
		if [ ! "$$file" = "tex/CVS" ]; then \
	        $(CP) $$file $(DESTDIR)/$$file ;\
	        chmod 644 $(DESTDIR)/$$file ;\
		fi \
	done

clean:



