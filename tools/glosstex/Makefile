# -*- Makefile -*-
# automatically generated from Makefile.m4

# ======================================================================
# you may need to set some of these
# ======================================================================


include Release

CFLAGS += -Wall -ansi -pedantic

DEBUG = 

ifdef DEBUG
 CFLAGS += -g
 LDFLAGS += -g
endif




M4 = m4

LATEX = latex
MAKEINDEX = makeindex
GLOSSTEX = glosstex$(EXE)
MV = mv
RM = rm -f

# ======================================================================
# you shouldn't need to touch anything below
# ======================================================================

TEXAUX = *.aux *.lof *.lot *.log *.toc *.glo 
GLOSSTEXAUX = *.gxs *.gxg
MAKEINDEXAUX = *.glg *.glx

MAKEFILES=\
	Makefile\
	Makefile.os2\
	Makefile.unx\

O=\
	database.o\
	error.o\
	labels.o\
	list.o\
	main.o\
	version.o\

DTX=\
	glosstex.sty\
	glosstex.std\
	glosstex.mst\
	glosstex.gdf

C=$(O:%.o=%.c)

all: glosstex$(EXE)

glosstex: $(O)
	$(CC) $(LDFLAGS) $(O) $(LOADLIBS) -o $@

 # OSTYPE

doc: glosstex$(EXE) glosstex.dvi

glosstex.dvi: $(DTX) glosstex.dtx

%.dvi: %.dtx
	$(LATEX) $<
	$(GLOSSTEX) $*.aux $*.gdf
	$(MAKEINDEX) $*.gxs -o $*.glx -t $*.glg -s glosstex.mst
	$(LATEX) $<
	$(GLOSSTEX) $*.aux $*.gdf
	$(MAKEINDEX) $*.gxs -o $*.glx -t $*.glg -s glosstex.mst
	$(LATEX) $<

$(DTX): glosstex.dtx glosstex.ins
	latex glosstex.ins

clean:
	$(RM) $(O) $(TEXAUX) $(MAKEINDEXAUX) $(GLOSSTEXAUX) $(DTX) *~

proper: clean
	$(RM) .depend glosstex glosstex.dvi

Makefiles: Makefile $(MAKEFILES)

Makefile: Makefile.m4
	$(M4) -P -DMASTER $< > $@

Makefile.os2: Makefile.m4
	$(M4) -P -DOSTYPE=OS2 $< > $@

Makefile.unx: Makefile.m4
	$(M4) -P -DOSTYPE=UNX $< > $@

dist: 
	pushd ~/tmp;\
	$(RM) -r glosstex;\
	popd;\
	pushd ..;\
	cp -r glosstex ~/tmp/glosstex;\
	cd ~/tmp/glosstex;\
	$(RM) -r test CVS;\
	$(MAKE) -d -f Makefile dep;\
	$(MAKE) -d -f Makefile.unx doc clean;\
	popd;


dep:
	$(CPP) -MM $(INCDIR) $(C) > .depend

lint:
	lint $(C) 

version.c : Release
	$(MV) $@ $@.in
	sed < $@.in > $@ -e 's/version .*\\n/version $(RELEASE)\\n/'
	$(RM) $@.in

glosstex.dtx : Release
	$(MV) $@ $@.in
	sed < $@.in > $@\
	-e 's/\\def\\fileversion{.*}/\\def\\fileversion{$(RELEASE)}/'\
	-e 's/\\def\\filedate{.*}/\\def\\filedate{'`date '+%Y\/%m\/%d'`'}/'
	$(RM) $@.in

install:
	cp glosstex /usr/local/bin
	chmod 755 /usr/local/bin/glosstex 

ifeq (.depend, $(wildcard .depend))
include .depend
endif
 # MASTER

# eof
