
#
# Makefile for sgml-powertools
#

SGMLPOWERTOOLS_HOME=$(shell pwd)
export SGMLPOWERTOOLS_HOME

PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
MANDIR=$(PREFIX)/man
INSTALLDIR=$(PREFIX)/share/sgml-powertools
export PREFIX
export BINDIR
export MANDIR
export INSTALLDIR

INSTALL=install
CP=cp -p
CC=gcc
export INSTALL
export CP
export CC

#SGML_DTDS=$(wildcard sgml/*)
SGML_DTDS=sgml/powerdoc sgml/linuxdoc sgml/biblio
EXES=$(wildcard bin/*)
SCRIPTS=$(wildcard scripts/*)

.PHONY: all install install-man install-doc tools sgml test clean

all: tools sgml

sgml:
	for dir in $(SGML_DTDS); do \
		if [ ! "$$dir" = "sgml/CVS" ]; then \
		    $(MAKE) -C $$dir ;\
		fi \
	done

tools:
	$(MAKE) -C tools/glosstex 
#	$(MAKE) -C tools/sgmls-1.1.91 config.h
#	$(MAKE) -C tools/sgmls-1.1.91

install:
	-mkdir $(INSTALLDIR)
	-mkdir $(INSTALLDIR)/bin
	-mkdir $(INSTALLDIR)/sgml
	-mkdir $(INSTALLDIR)/scripts
	for dir in $(SGML_DTDS); do \
		if [ ! "$$dir" = "sgml/CVS" ]; then \
	        $(MAKE) -C $$dir install ;\
		fi \
	done
	for file in $(EXES); do \
		if [ ! "$$file" = "bin/CVS" ]; then \
		    rm -f $(PREFIX)/$$file ;\
		    rm -f $(INSTALLDIR)/$$file ;\
		    sed -e "s!sgml_pt_home!$(INSTALLDIR)!1" < $$file > $(INSTALLDIR)/$$file ;\
		    chmod 755 $(INSTALLDIR)/$$file ;\
		    ln -s $(INSTALLDIR)/$$file $(BINDIR) ;\
		fi \
	done
	for file in $(SCRIPTS); do \
	    if [ ! "$$file" = "scripts/CVS" ]; then \
		    $(CP) $$file $(INSTALLDIR)/$$file  ;\
		    chmod 644 $(INSTALLDIR)/$$file ;\
	    fi \
	done
	-$(MAKE) -C tools/glosstex install
#	$(MAKE) -C tools/sgmls-1.1.91 install

install-man: sgml
	-mkdir $(INSTALLDIR)
	-mkdir $(INSTALLDIR)/man
	$(MAKE) -C man install
#	$(MAKE) -C tools/sgmls-1.1.91 install.man

doc:
	$(MAKE) -C doc
	$(MAKE) -C tools/glosstex doc

install-doc: doc
	-mkdir $(INSTALLDIR)
	-mkdir $(INSTALLDIR)/doc
	$(MAKE) -C doc install
	for dir in $(SGML_DTDS); do \
		if [ ! "$$dir" = "sgml/CVS" ]; then \
		    $(MAKE) -C $$dir install-doc ;\
		fi \
	done

#test:
#	$(MAKE) -C tools/sgmls-1.1.91 test

clean:
	for dir in $(SGML_DTDS); do \
		if [ ! "$$dir" = "sgml/CVS" ]; then \
		    $(MAKE) -C $$dir clean ;\
		fi \
	done
	-$(MAKE) -C tools/glosstex clean	 
#	-$(MAKE) -C tools/sgmls-1.1.91 clean
	
	

