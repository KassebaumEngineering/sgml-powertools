#
# Makefile for sgml powertool scripts and executables
#

#put your translation name here
TRANSLATION=max

DESTDIR=$(INSTALLDIR)/sgml/$(DTDNAME)/translations/$(TRANSLATION)

# Modify this line if you do not use some of these scripts
FILES=general mapping  
SCRIPTS=translate

.PHONY: all install clean

all:

install:
	-mkdir $(DESTDIR)
	for file in $(FILES); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 644 $(DESTDIR)/$$file  ;\
	done
	for file in $(SCRIPTS); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 755 $(DESTDIR)/$$file  ;\
	done

clean:



