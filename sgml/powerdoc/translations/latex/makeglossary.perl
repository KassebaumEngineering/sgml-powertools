#!/usr/local/bin/perl
#
# This post-processing script splits out acronym and glossary entries
# from the latex translation into the appropriate acronym and glossary 
# latex database file.
#

$GDFFILE=shift @ARGV ;
open(GDFFILEHANDLE, ">$GDFFILE.gdf");

$index = 0;
while($line = <STDIN>){
    if( $line eq "<*gdf>\n" ){
	    $index = 1;
	} elsif( $line eq "</gdf>\n" ){
	    $index = 0;
	} else {
	    if( $index == 0 ){
		    printf STDOUT $line;
		} else {
		    printf GDFFILEHANDLE $line;
		}
	}
}

close GDFFILEHANDLE;
