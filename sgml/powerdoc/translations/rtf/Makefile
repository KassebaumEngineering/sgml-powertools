#
# Makefile for sgml powertool scripts and executables
#

#put your translation name here
TRANSLATION=rtf

DESTDIR=$(INSTALLDIR)/sgml/$(DTDNAME)/translations/$(TRANSLATION)

# Modify this line if you do not use some of these scripts
FILES=general mapping prertf.sed  
SCRIPTS=translate makeglossary.perl
TOOLS=rtf-fix/rtf2rtf

INSTALLFILES=$(addprefix $(DESTDIR)/, $(FILES))

.PHONY: all install clean rtf-fix

all: rtf-fix

rtf-fix:
	$(MAKE) -C rtf-fix

install:
	-mkdir $(DESTDIR)
	-mkdir $(DESTDIR)/rtf-fix
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

clean:
	$(MAKE) -C rtf-fix clean


