#
# Makefile for sgml powertool scripts and executables
#

#put your dtd name here
DTDNAME=newdoc  
export DTDNAME

DESTDIR=$(INSTALLDIR)/sgml/$(DTDNAME)

DTDFILES=$(wildcard dtd/*.dtd)
DOCFILES=$(wildcard doc/*)
MANFILES=$(wildcard man/*)

.PHONY: all install install-doc clean

all:
	$(MAKE) -C translations
	if [ ! "$(MANFILES)" = "" ]; then \
	    for file in "$(MANFILES)"; do \
			rm -f $(SGMLPOWERTOOLS_HOME)/$$file ;\
		    ln -s $(SGMLPOWERTOOLS_HOME)/sgml/$(DTDNAME)/$$file $(SGMLPOWERTOOLS_HOME)/$$file ;\
	    done \
	fi
	rm -f $(SGMLPOWERTOOLS_HOME)/doc/$(DTDNAME)
	ln -s $(SGMLPOWERTOOLS_HOME)/sgml/$(DTDNAME)/doc $(SGMLPOWERTOOLS_HOME)/doc/$(DTDNAME)

install:
	-mkdir $(DESTDIR)
	-mkdir $(DESTDIR)/translations
	-mkdir $(DESTDIR)/dtd
	$(MAKE) -C translations install
	for file in $(DTDFILES); do \
	    $(CP) $(file) $(DESTDIR)/$$file ;\
	    chmod 644 $(DESTDIR)/$$file ;\
	done

install-doc:
	-mkdir $(DESTDIR)
	-mkdir $(DESTDIR)/doc
	for file in $(DOCFILES); do \
	    $(CP) $(file) $(DESTDIR)/$$file ;\
	    chmod 644 $(DESTDIR)/$$file ;\
	done

clean:
	$(MAKE) -C translations clean
	if [ ! "$(MANFILES)" = "" ]; then \
		for file in "$(MANFILES)"; do \
			rm -f $(SGMLPOWERTOOLS_HOME)/$$file ;\
		done \
	fi
	rm -f $(SGMLPOWERTOOLS_HOME)/doc/$(DTDNAME)
