
# author : Tom Gordon
# date   : 28 July 92

# AWK script for generating an SGML address list from a AWK database
# which presumably has been sorted.  The format of the AWK database
# is presumed to have the following format.  Records are separated by
# new lines.  Fields are separated by tabs.   The fields are arranged 
# in a sequence of (tag, value) pairs.  There may be multiple "line" 
# tags.   

BEGIN { FS="\t"
        print "<!doctype addrlst public \"-//GMD//DTD addrlst//EN\">"
	print "<addrlst>"
	printf "\n" }

      { # intialize the array
	r["alias"] = ""
        r["title"] = ""
        r["name"] = ""
        r["lines"] = ""
	r["pobox"] = ""
	r["street"] = ""
	r["city"] = ""
	r["country"] = ""
        r["tel"] = ""
	r["telex"] = ""
        r["fax"] = ""
	r["email"] = ""
	r["lists"] = ""  
	r["date"] = ""
        r["notes"] = ""

        for (i = 1; i < (NF-1); i += 2) {  # load the array
	        if ($i == "line") {  # pack all lines into the lines field
		  if (r["lines"] == "") {
		    r["lines"] = $(i+1) 
		  } else {
		    r["lines"] = r["lines"] "\\" $(i+1)
		  }
		} else {
		  r[$i] = $(i+1)
		}
	      }
	print "<entry>"
	printf ("<alias>\t\t%s\n", r["alias"])
       	if (r["title"] != "") { printf ("<title>\t\t%s\n", r["title"]) }
	printf ("<name>\t\t%s\n", r["name"])

       	if (r["lines"] != "") { 
	        n = split(r["lines"], a, "\\")
	        for (i = 1; i <= n; i++) {
	       		printf ("<line>\t\t%s\n", a[i]) 
		}
	}

        if (r["pobox"] != "") { printf ("<pobox>\t\t%s\n", r["pobox"]) }
       	if (r["street"] != "") { printf ("<street>\t%s\n", r["street"]) }
       	if (r["city"] != "") { printf ("<city>\t\t%s\n", r["city"]) }
       	if (r["country"] != "") { printf ("<country>\t%s\n", r["country"]) }
       	if (r["tel"] != "") { printf ("<tel>\t\t%s\n", r["tel"]) }
       	if (r["telex"] != "") { printf ("<telex>\t\t%s\n", r["telex"]) }
       	if (r["fax"] != "") { printf ("<fax>\t\t%s\n", r["fax"]) }
       	if (r["email"] != "") { printf ("<email>\t\t%s\n", r["email"]) }
       	if (r["lists"] != "") { printf ("<lists>\t\t%s\n", r["lists"]) }
       	if (r["date"] != "") { printf ("<date>\t\t%s\n", r["date"]) }
       	if (r["notes"] != "") { printf ("<notes>\t\t%s\n", r["notes"]) }
	printf "\n"
      }
END   { print "</addrlst>" }

