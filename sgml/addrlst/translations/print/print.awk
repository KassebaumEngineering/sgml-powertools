
# author : Tom Gordon
# date   : 28 July 92

# AWK script for printing address lists.

BEGIN { FS="\t"
	print "\\documentstyle[dina4,twocolumn]{article}"
	print "\\begin{document}" }
      { # intialize the array
	r["lists"] = " "   # lists initialized to blank, to match ".*"
	r["alias"] = ""
        r["title"] = ""
        r["name"] = ""
        r["address"] = ""
	r["email"] = ""
        r["tel"] = ""
	r["telex"] = ""
        r["fax"] = ""
        r["notes"] = ""
        for (i = 1; i < (NF-1); i += 2) {  # load the array
		r[$i] = $(i+1)
	}
		# print the TeX code for entries in the chosen list
	if (r["lists"] ~ /[ ,]PATTERN[ ,]/) {
		printf "\n\n\\parbox{7cm}{\n"
		if ( r["title"] != "" ) { print r["title"], "\\\\" }
		print "{\\bf " r["name"] "}", "\\\\"
		print r["address"]
		if ( r["tel"] != "") {
			print "{\\bf tel: }", r["tel"], "\\\\"
		}
		if ( r["fax"] != "") {
			print "{\\bf fax: }", r["fax"], "\\\\"
		}
		if ( r["telex"] != "") {
			print "{\\bf telex: }", r["telex"], "\\\\"
		}
		if ( r["email"] != "") { 
			print "{\\bf email: }", r["email"], "\\\\"
		}
		if ( r["lists"] != "") { 
			print "{\\bf lists: }", r["lists"], "\\\\"
		}
		if ( r["notes"] != "") {
			print "{\\em ", r["notes"], "\\/} \\\\"
		}
		print "}"
       	}
      }
END   { print "\\end{document}" }

