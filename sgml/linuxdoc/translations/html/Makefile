#
# Makefile for sgml powertool scripts and executables
#

#put your translation name here
TRANSLATION=html

DESTDIR=$(INSTALLDIR)/sgml/$(DTDNAME)/translations/$(TRANSLATION)

# Modify this line if you do not use some of these scripts
FILES=general mapping deutsch prehtml.sed  
SCRIPTS=translate
ICONS=$(wildcard icons/*.gif)
TOOLS=html-fix/fixref html-fix/html2html

INSTALLFILES=$(addprefix $(DESTDIR)/, $(FILES))

.PHONY: all install clean html-fix

all: html-fix

html-fix:
	$(MAKE) -C html-fix

install:
	-mkdir $(DESTDIR)
	-mkdir $(DESTDIR)/html-fix
	-mkdir $(DESTDIR)/icons
	for file in $(FILES); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 644 $(DESTDIR)/$$file  ;\
	done
	for file in $(SCRIPTS); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 755 $(DESTDIR)/$$file  ;\
	done
	for file in $(TOOLS); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 755 $(DESTDIR)/$$file ;\
	done
	for file in $(ICONS); do \
	    $(CP) $$file $(DESTDIR)/$$file ;\
	    chmod 644 $(DESTDIR)/$$file ;\
	done

clean:
	$(MAKE) -C html-fix clean


