
# author : Tom Gordon
# date   : 23 July 92

BEGIN { FS="\t"
	print "cat /vol/sgmlformat/rep/addrlst/labels/header" | "/bin/sh"
   	MATCHES = 0  }
      { # intialize the array
	r["lists"] = " "   # lists initialized to blank, to match ".*"
        r["title"] = ""
        r["name"] = ""
        r["address"] = ""
	# load the array
        for (i = 1; i < (NF-1); i += 2) {  r[$i] = $(i+1) }
	if (r["lists"] ~ /[ ,]PATTERN[ ,]/) {
        	MATCHES += 1
                if (MATCHES % 2 != 0) {
			print "\\intbl {\\f20\\fs20"
			printf ("\\par ") 
			if ( r["title"] != "") { printf("%s ",r["title"]) }
			print r["name"], r["address"]
		} else {
			printf ("\\par ")
			if ( r["title"] != "") { printf("%s ",r["title"]) }
			print r["name"], r["address"]
		        print "}\\pard \\intbl \\row \\pard" 	
	        } 
       	}
      }
END   { if (MATCHES % 2 != 0) {
		print "\\par \\cell "
		print "}\\pard \\intbl \\row \\pard"
 		print "}" 
        }
      }

