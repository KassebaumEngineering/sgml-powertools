#
# Makefile for sgml powertool scripts and executables
#

#put your dtd name here
DTDNAME=linuxdoc
export DTDNAME

DESTDIR=$(INSTALLDIR)/sgml/$(DTDNAME)

DTDFILES=$(wildcard dtd/*)
DOCFILES=$(wildcard doc/*)
MANFILES=$(wildcard man/*)

.PHONY: all install install-doc clean

all:
	$(MAKE) -C translations
	if [ ! "$(MANFILES)" = "" ]; then \
	    for file in "$(MANFILES)"; do \
			if [ ! "$$file" = "man/CVS" ]; then \
                rm -f $(SGMLPOWERTOOLS_HOME)/$$file ;\
                ln -s $(SGMLPOWERTOOLS_HOME)/sgml/$(DTDNAME)/$$file $(SGMLPOWERTOOLS_HOME)/$$file ;\
			fi \
	    done \
	fi
	rm -f $(SGMLPOWERTOOLS_HOME)/doc/$(DTDNAME)
	ln -s $(SGMLPOWERTOOLS_HOME)/sgml/$(DTDNAME)/doc $(SGMLPOWERTOOLS_HOME)/doc/$(DTDNAME)

install:
	-mkdir $(DESTDIR)
	-mkdir $(DESTDIR)/translations
	-mkdir $(DESTDIR)/dtd
	for file in $(DTDFILES); do \
		if [ ! "$$file" = "dtd/CVS" ]; then \
	        $(CP) $$file $(DESTDIR)/$$file ;\
	        chmod 644 $(DESTDIR)/$$file ;\
		fi \
	done
	$(MAKE) -C translations install

install-doc:
	-mkdir $(DESTDIR)
	-mkdir $(DESTDIR)/doc
	for file in $(DOCFILES); do \
		if [ ! "$$file" = "doc/CVS" ]; then \
	        $(CP) $$file $(DESTDIR)/$$file ;\
	        chmod 644 $(DESTDIR)/$$file ;\
		fi \
	done

clean:
	$(MAKE) -C translations clean
	if [ ! "$(MANFILES)" = "" ]; then \
		for file in "$(MANFILES)"; do \
		    if [ ! "$$file" = "man/CVS" ]; then \
			    rm -f $(SGMLPOWERTOOLS_HOME)/$$file ;\
			fi \
		done \
	fi
	rm -f $(SGMLPOWERTOOLS_HOME)/doc/$(DTDNAME)
