
MANDIR="../man/man1"

all:	biblio.1 extract.1 format.1 qtex.1

biblio.1:	biblio1.sgml
	format -T man biblio1.sgml > $(MANDIR)/biblio.1

extract.1:	extract1.sgml
	format -T man extract1.sgml > $(MANDIR)/extract.1

format.1:	format1.sgml
	format -T man format1.sgml > $(MANDIR)/format.1

qtex.1:		qtex1.sgml
	format -T man qtex1.sgml > $(MANDIR)/qtex.1


