# Makefile for HTML post-processors

CC=gcc
CFLAGS=-O
LEX=flex

all: fixref html2html

html2html.c: html2html.l
	$(LEX) -t html2html.l > html2html.c

fixref.c: fixref.l
	$(LEX) -t fixref.l > fixref.c

html2html: html2html.c
	$(CC) $(CFLAGS) -s -o html2html html2html.c -L/usr/local/lib -lfl

fixref: fixref.c
	$(CC) $(CFLAGS) -s -o fixref fixref.c -L/usr/local/lib -lfl

clean:
	rm -f fixref fixref.c html2html html2html.c
