
PREROFF=preroff

all:	extract.1 format.1 qtex.1 fax.1

extract.1:	extract.1.sgml
	format -T man extract.1.sgml | $(PREROFF) > extract.1

format.1:	format.1.sgml
	format -T man format.1.sgml | $(PREROFF) > format.1

qtex.1:	qtex.1.sgml
	format -T man qtex.1.sgml | $(PREROFF) > qtex.1

fax.1: fax.1.sgml
	format -T man fax.1.sgml | $(PREROFF) > fax.1

