#!/usr/local/bin/perl
#
# genertoc - generate Table of Contents for linuxdoc text.
# Stick this before the call to sgmlsasp.
#
# Thomas Koenig, 1995-12-01
# This code is in the public domain.

# build toc header
push(@toc,"(HLINE\n");
push(@toc,")HLINE\n");
push(@toc,"(P\n");
push(@toc,"-Table of Contents:\n");
push(@toc,")P\n");

while (<>) {
    push(@lines,$_);
    if (/^\(SECT(.*)/) {
	@header = @header[0..$1];
	$header[$1]++;
    }
    if (/^\(HEADING/) {
	$_ = <>;
	push(@lines,$_);
	s/^-//;
	$_ = "-" . join(".",@header) . " " . $_;
	s/\\n/ /g;
	s/\(\\[0-9][0-9][0-9]\)/\\\1/g;
	# put a . and a tab after each number
	s/ /.\t/;
	push(@toc,"(P\n" , $_, ")P\n");
    }
}

push(@toc,"(HLINE\n");
push(@toc,")HLINE\n");

for (@lines) {
    print;
    if (/^\(TOC/) {
	print @toc;
    }
}
