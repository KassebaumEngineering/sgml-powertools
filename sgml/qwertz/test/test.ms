.nr PS 11
.nr PI 3n
.ds CF \\n%
.ds CH \&
.ds dR $
.nr FF 1
.tr \&
.de hl
.br
\l'\\n(.lu-\\n(.iu'
..
.if n .nr PD 1v
.nr h 0
.nr il 1
.nr bi 0
.nr ll 0
.nr el 0
.de Pp
.ie \\n(ll>0 \{\
.ie \\n(bi=1 \{\
.nr bi 0
.if \\n(t\\n(ll=0 \{.IP \\(bu\}
.if \\n(t\\n(ll=1 \{.IP \\n+(e\\n(el.\}
.\}
.el .sp 
.\}
.el \{\
.ie \\nh=1 \{\
.LP
.nr h 0
.\}
.el .PP 
.\}
..
.ds f1 1
.ds f2 a
.ds f3 i
.ds f4 A
.nr def 0
.nr prop 0
.nr lemma 0
.nr coroll 0
.nr proof 0
.nr theorem 0
.ds [. [
.ds .] ]
.nr il 1
.TL
The \fRqwertz\fR SGML Document Types
.br
.ft R
.SM
(Version 1.1 Reference Manual)
.LG
.AU
Tom Gordon
.AI
The \fRqwertz\fR Project 
.br
Institute for Applied Information Technology (F3) 
.br
.br
German National Research Center 
.br
for Computer Science (GMD)
.bp
.NH \n(il 
.ds h Why Not Just Use LaTeX?
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.Pp
The \fRqwertz\fR document types are a set of Standard Generalized
Markup Language (SGML) document type definitions (DTDs) for articles,
reports, books, letters, notes, slides (or overhead transparencies),
bibliographies, and manual pages.  Except for manual pages, the
document types have been heavily influenced by the LaTeX document
types of the same names 
.[
Lamport86
.]
, so LaTeX users should
feel right at home.  Indeed, we presently translate most \fRqwertz\fR
documents into LaTeX for printing and the LaTeX produced is quite
readable by anyone familiar with LaTeX.
.Pp
...
.Pp
.bp
.NH \n(il 
.ds h The \fRqwertz\fR Document Type Definition
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.EH 'The \fRqwertz\fR Document Types'''
.OH '''The \fRqwertz\fR DTD'
.Pp
...
.Pp
We will be making use of several \fIparameter entities\fP in this
DTD:
.Pp
.DS L
.hl
.ft R
.eo
<!entity % emph 
        " em | it | bf | sf | sl | tt " >

<!entity % inline 
        " f | x | %emph; | sq | label | ref | 
          pageref | cite | ncite " >
.ec
.hl
.DE
.ft P
.LP
.Pp
...
.Pp
.NH 1+\n(il
.ds h General Purpose Entities and Elements
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.EH 'The \fRqwertz\fR Document Types'''
.OH '''General Purpose Entities'
.Pp
...
.Pp
When may it be necessary to use of an entity reference to produce
some character?  There are three cases to watch out for:
.Pp
.RS
.nr ll +1
.nr t\n(ll 2
.IP "\fBSGML Concrete Syntax Delimiters.\fP"
.nr bi 1
.Pp
Although the SGML standard allows alternative concrete syntaxes to
be defined, we use the so-called \fIreference concrete syntax\fP in
the \fRqwertz\fR document types.  ...
.Pp
.IP "\fBSGML Short Reference Delimiters.\fP"
.nr bi 1
.Pp
In SGML document types \fIshort reference maps\fP may be defined
which allow single characters to be interpreted as arbitrarily complex
sequences of characters, including SGML tags and entity references. ...
.Pp
.DS L
.ft R
.eo
" # % ' ( ) * + , - : ; = @ [ ] ^ _ { | } ~
.ec
.DE
.ft P
.LP
.Pp
For each of these characters, there is an SGML entity which may be
used to generate the ASCII character in the printed document, listed
in table ??. \fIUsually, it will not be necessary to use these
entities; the character can simply be typed and will be interpreted
literally.\fP However, ...
.Pp
.IP "\fBTeX Special Characters.\fP"
.nr bi 1
.Pp
Ideally, it should be possible to hide the conventions of the
underlying formatting system completely.  In fact, SGML parsers which
implement the full ISO standard have a feature which makes this
possible. ...
.Pp
.nr ll -1
.RE
.Pp
.NH 2+\n(il
.ds h Spacing, Dashes and Ellipsis
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.EH 'The \fRqwertz\fR Document Types'''
.OH '''Spacing, Dashes and Ellipsis'
.Pp
...
.Pp
There are also three different kinds of dashes: \fRhyphen\fR
which was already mentioned above, is to be used for intra-word dashes, as
in the word \*Qintra-word\*U.\**
.FS
However, the \fRhyphen\fR entity
was not actually necessary here, as the - character was not being used
in this context as a short reference.
.FE
.Pp
...
.Pp
.NH 2+\n(il
.ds h Foreign Characters
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.EH 'The \fRqwertz\fR Document Types'''
.OH '''Foreign Characters'
.Pp
There are a large set of entities for other Western European
languages.  Altogether, there are entities for almost all of the
foreign language characters in ISO 8859, the Latin 1 character set for
Western European languages.\**
.FS
Only the four
Icelandic characters are missing.
.FE
 ...
.Pp
.KF
.R
.TS
center, tab(|) ; 
ll|ll|ll|ll.
AElig|Æ|Aacute|Á|Acirc|Â|Ae|Ä
Ntilde|Ñ|Oacute|Ó|Ocirc|Ô|Oe|Ö
Ue|Ü|Ugrave|Ù|Uuml|Ü|Yacute|Ý
aacute|á|acirc|â|ae|ä|aelig|æ
oe|ö|ograve|ò|oslash|ø|otilde|õ
sz|ß|szlig|ß|thinsp||tilde|~
times|×|uacute|ú|ucirc|û|ue|ü
.TE
.sp
.ce
 (Some) General Purpose Characters
.KE
.Pp
...
.Pp
.NH 2+\n(il
.ds h Sentences, Paragraphs, Footnotes and Emphasis
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.EH 'The \fRqwertz\fR Document Types'''
.OH '''Sentences ... Emphasis'
.Pp
...
.Pp
Sentences or phrases within paragraphs can be emphasized in a
number of ways.  The \fRem\fR tag is used to choose the default form
of emphasis, which is usually \fIitalic\fP type, but depends on the
style of the background text.  If the background text is formatted in
italics type, as it usually is in definitions, for example, than
emphasized text will be formatted using a plain, roman typeface.
However, various forms of emphasis can be explicitly chosen.  These
include: \fBbold face\fR (\fRbf\fR), \fIitalics\fR (\fRit\fR),
\fRsans serif\fR (\fRsf\fR), \fIslanted\fR (\fRsl\fR), and
\fRtypewriter\fR (\fRtt\fR) styles.
.Pp
...
.Pp
Long quotes are formatted in LaTeX by indenting the left and
right margins.  For example, 
.[
Lamport86
.]
(pp. xiii):
.Pp
.RS
.nr LL \n(LL-\n(PI
.Pp
The LaTeX document preparation system is a special version of
Donald Knuth's TeX program.  TeX is a sophisticated program designed
to produce high-quality typesetting, especially for mathematical text.
...
.Pp
LaTeX represents a balance between functionality and ease of use.
Since I implemented most of it myself, there was also a continual
compromise between what I wanted to do and what I could do in a
reasonable amount of time.  ...
.nr LL \n(LL+\n(PI
.RE
.Pp
.NH 2+\n(il
.ds h Lists
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.EH 'The \fRqwertz\fR Document Types'''
.OH '''Lists'
.Pp
Three types of lists are supported, which differ according to the
type of label used to mark each item in the list.  Use \fRitemize\fR
to create a list in which each item is marked with some symbol such as
a dash or bullet. The \fRenum\fR tag is used to create an
enumeration, i.e. a list in which each item is labelled with a number
(or letter) indicating its rank or position in the list. Finally, use
\fRdescrip\fR to create a list in which each item is labelled by some
tag of your own choice. Lists of various types can nested.  For
example:
.Pp
...
.Pp
.nr ll +1
.nr t\n(ll 0
.nr bi 1
 A level one item.
.nr bi 1
 Here's level two:
.nr ll +1
.nr el +1
.nr t\n(ll 1
.nr e\n(el 0 1
.af e\n(el \*(f\n(el
.if \n(ll>1 .RS
.nr bi 1
 A level two item.
.nr bi 1
 Here's level three:
.nr ll +1
.nr el +1
.nr t\n(ll 1
.nr e\n(el 0 1
.af e\n(el \*(f\n(el
.if \n(ll>1 .RS
.nr bi 1
 A level three item.
.nr bi 1
 Here's level four:
.RS
.nr ll +1
.nr t\n(ll 2
.IP "\fBRed.\fP"
.nr bi 1
 Is the color of my true love's hair.
.IP "\fBBlue.\fP"
.nr bi 1
 Is a property of some movies.
.IP "\fBYellow.\fP"
.nr bi 1
 Characterizes some forms of journalism.
.nr ll -1
.RE
.nr bi 1
A last level three item
.if \n(ll>1 .RE
.br
.nr el -1
.nr ll -1
.nr bi 1
 A last level two item
.if \n(ll>1 .RE
.br
.nr el -1
.nr ll -1
.nr bi 1
A last level one item.
.nr ll -1
.Pp
...
.Pp
.NH 2+\n(il
.ds h Figures and Tables
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.Pp
Encapsulated PostScript graphics can be created using a variety of
different editors.  If you are using Unix with an X11-based graphical
user-interface, you may want to try \fRidraw\fR, which stores its
documents directly as Encapsulated PostScript files. Another
interesting X11-based drawing program is \fRtgif\fR.
.Pp
...
.Pp
Which would then appear as in figure ??.
.Pp
.if t .PSPIC issues.ps
.if n .sp 4
.sp
.ce
An \fRidraw\fR Drawing 
.Pp
.NH 2+\n(il
.ds h Literate Programming
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.Pp
The original motivation behind the development of these document
types was to create an environment for literate programming in an
arbitrary programming language similar to Donald Knuth's WEB system
for literate programming in Pascal 
.[
Knuth84
.]
\&.  ...
.Pp
When formatted, spaces and line breaks are preserved:
.Pp
.DS L
.ft R
.eo
main ()
{
        /* This is the famous hello world program */

        printf("hello world\n");
}
.ec
.DE
.ft P
.LP
.Pp
.NH 2+\n(il
.ds h Mathematical Formulas
\*h
.XS \n%
\*(SN \*h
.XE
.nr h 1
.Pp
The \fRqwertz\fR document types include elements for describing
mathematical formulas completely within SGML, similar to the system
described in 
.[
daphne89
.]
\&.  ...
.Pp
So, for example, example, 
.Pp
.DS L
          sum  from {i=1} to {n}x sub {i} =          int  from {0} to {1}f 
.DE

was typed as:
.DS L
.ft R
.eo
<dm>
        <sum><ll>i=1<ul>n<opd>x<inf>i</></sum> =
        <in><ll>0<ul>1<opd>f</in>
</dm>
.ec
.DE
.ft P
.LP
.Pp
...
.Pp
.[
$LIST$
.]
.bp
.rm LH
.rm RH
.TC
