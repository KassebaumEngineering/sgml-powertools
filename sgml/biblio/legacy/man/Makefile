
PREROFF=/home/qwertz/format/bin/preroff

all:	biblio.1 qroff.1

biblio.1:	biblio.1.sgml
	format -T man biblio.1.sgml | $(PREROFF) > biblio.1

qroff.1: qroff.1.sgml
	format -T man qroff.1.sgml | $(PREROFF) > qroff.1

