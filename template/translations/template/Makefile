#
# Makefile for sgml powertool scripts and executables
#

#put your translation name here
TRANSLATION=template  

DESTDIR=$(INSTALLDIR)/sgml/$(DTDNAME)/translations/$(TRANSLATION)

# Modify this line if you do not use some of these scripts
FILES=general mapping
SCRIPTS=translate

.PHONY: all install clean

all:

install:
	-mkdir $(DESTDIR)
	for file in $(FILES); do \
	    $(INSTALL) $$file $(DESTDIR) ;\
	    chmod 644 $(DESTDIR)/$$file ;\
	done
	for file in $(SCRIPTS); do \
	    $(INSTALL) $$file $(DESTDIR) ;\
	    chmod 755 $(DESTDIR)/$$file ;\
	done

clean:
	;

