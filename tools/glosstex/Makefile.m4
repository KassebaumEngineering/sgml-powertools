# -*- Makefile -*-
m4_ifelse(1, 1,
# automatically generated from Makefile.m4
,
# $Id: Makefile.m4,v 1.1.1.1 1997/08/22 04:02:14 jak Exp $

# GlossTeX, a tool for the automatic preparation of glossaries.
# Copyright (C) 1997 Volkan Yavuz
  
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
  
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
  
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

# Volkan Yavuz, yavuzv@rumms.uni-mannheim.de
)
# ======================================================================
# you may need to set some of these
# ======================================================================

m4_changequote([,])
m4_ifdef([MASTER],
include Release
)
CFLAGS += -Wall -ansi -pedantic

m4_ifdef([MASTER],
DEBUG = 

ifdef DEBUG
 CFLAGS += -g
 LDFLAGS += -g
endif
)

m4_ifelse(OSTYPE, [OS2],
 CC = gcc
 SHELL = sh
 EXE = .exe
 EMXBIND = emxbind
)

m4_ifdef([MASTER],
M4 = m4
)
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

m4_ifdef([MASTER],
MAKEFILES=\
	Makefile\
	Makefile.os2\
	Makefile.unx\
)
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

m4_ifelse(OSTYPE, [OS2],
glosstex$(EXE): glosstex
	$(EMXBIND) $<
	$(EMXBIND) -s $<
	$(RM) glosstex
) # OSTYPE

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

m4_ifdef([MASTER],
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
) # MASTER

# eof
