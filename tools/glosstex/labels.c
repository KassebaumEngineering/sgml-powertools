
/* -*- c -*- */

/*
   GlossTeX, a tool for the automatic preparation of glossaries.
   Copyright (C) 1997 Volkan Yavuz

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

   Volkan Yavuz, yavuzv@rumms.uni-mannheim.de
 */

/* $Id: labels.c,v 1.1.1.1 1997/08/22 04:02:17 jak Exp $ */

#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "glosstex.h"
#include "labels.h"
#include "list.h"
#include "error.h"

#define KEYWORDSIZE 10		/* \GLX@entry */
#define INPUTWORDSIZE 7		/* \@input */

static int get_label (char buf[],
		      char *label, char *pageref_mode,
		      char *list, char *list_mode, char *page);

void
read_labels (char *inname)
{
  FILE *infile;
  char buf[LINESIZE];
  unsigned int lineno = 0;

  if ((infile = fopen (inname, "r")) == NULL) {
    error ("input-file %s", inname);
    exit (EXIT_FAILURE);
  }
  printlog (PROGRESS, STDOUT, "(%s ", inname);

  while (fgets (buf, LINESIZE, infile) != 0) {
    if (buf[strlen (buf) - 1] == '\n')
      lineno++;

    if ((strncmp (buf, "\\GLX@entry", KEYWORDSIZE)) == 0) {

      s_label *label = (s_label *) malloc (sizeof (s_label));
      s_label *found_label = 0;
      assert (label != 0);

      label->label = (char *) malloc (WORDSIZE + 1);
      assert (label->label != 0);

      label->pageref_mode = (char *) malloc (WORDSIZE + 1);
      assert (label->pageref_mode != 0);

      label->list = (char *) malloc (WORDSIZE + 1);
      assert (label->list != 0);

      label->list_mode = (char *) malloc (WORDSIZE + 1);
      assert (label->list_mode != 0);

      label->page = (char *) malloc (WORDSIZE + 1);
      assert (label->page != 0);

      label->flag = UNRESOLVED;

      if (get_label (&buf[KEYWORDSIZE],
		     label->label, label->pageref_mode,
		     label->list, label->list_mode,
		     label->page) != 0) {
	printlog (PROGRESS, STDOUT, "x");
	printlog (WARNING, LOGFILE, "\n%s:%u parse error: %s",
		  inname, lineno, buf);
	count_label_parsing++;
	continue;
      }
      if ((found_label =
	 find_label (FIND_FIRST, labels, label->label, label->list)) == 0) {
	list_add (&labels, label);
	printlog (INFORMATION, LOGFILE, "\n%s:%u %s[%s](%s)%s@%s",
		  inname, lineno,
		  label->label, label->pageref_mode,
		  label->list, label->list_mode, label->page);
	count_label_success++;
	printlog (PROGRESS, STDOUT, "i");
      } else {
	if (((strcmp (found_label->pageref_mode, "n") == 0) &&
	     (strcmp (label->pageref_mode, "n") != 0)) ||
	    ((strcmp (found_label->list_mode, "n") == 0) &&
	     (strcmp (label->list_mode, "n") != 0))) {
	  printlog (INFORMATION, LOGFILE,
		    "\n%s:%u %s[%s](%s)%s@%s overrides %s[%s](%s)%s@%s",
		    inname, lineno,
		    label->label, label->pageref_mode,
		    label->list, label->list_mode, label->page,
		    found_label->label, found_label->pageref_mode,
	      found_label->list, found_label->list_mode, found_label->page);
	  printlog (PROGRESS, STDOUT, "o");
	  free (found_label->label);
	  free (found_label->pageref_mode);
	  free (found_label->list);
	  free (found_label->list_mode);
	  free (found_label->page);
	  found_label->label = label->label;
	  found_label->pageref_mode = label->pageref_mode;
	  found_label->list = label->list;
	  found_label->list_mode = label->list_mode;
	  found_label->page = label->page;
	  count_label_override++;
	  free (label);
	} else {
	  printlog (VERBOSE, LOGFILE, "\n%s:%u %s[%s](%s)%s@%s ignored",
		    inname, lineno,
		    label->label, label->pageref_mode,
		    label->list, label->list_mode, label->page);
	  printlog (PROGRESS, STDOUT, ".");
	  count_label_defined++;

	  free (label->label);
	  free (label->pageref_mode);
	  free (label->list);
	  free (label->list_mode);
	  free (label->page);
	  free (label);
	}
      }

    } else if ((strncmp (buf, "\\@input", INPUTWORDSIZE)) == 0) {
      char *new_file_name = (char *) malloc (WORDSIZE + 1);
      assert (new_file_name != 0);

      if (sscanf ((char *) (&buf[INPUTWORDSIZE]),
		  "{%128[^}]}\n", new_file_name) == 1)
	read_labels (new_file_name);
    }
  }
  printlog (PROGRESS, STDOUT, ")");
}

s_label *
find_label (enum e_find_mode find_mode,
	    s_list labels, char *label, char *list)
{
  static s_node *p;

  if (find_mode == FIND_FIRST)
    p = labels.root;
  else
    p != 0 ? p = p->next : 0;

  while (p != 0) {
    if ((strcmp (((s_label *) (p->ptr))->label, label) == 0) &&
	((list == 0) ? 1 == 1 :
	 (strcmp (((s_label *) (p->ptr))->list, list) == 0)))
      return ((s_label *) (p->ptr));	/* FIXME: lint */
    p = p->next;
  }
  return 0;			/* FIXME: lint */
}

unsigned int
show_unresolved_labels (s_list list, FILE * file)
{
  unsigned int i = 0;
  s_node *p = list.root;
  while (p != 0) {
    if ((((s_label *) (p->ptr))->flag) == UNRESOLVED) {
      printlog (WARNING, STDOUT | LOGFILE, "\n%s[%s](%s)%s@%s unresolved",
		((s_label *) (p->ptr))->label,
		((s_label *) (p->ptr))->pageref_mode,
		((s_label *) (p->ptr))->list,
		((s_label *) (p->ptr))->list_mode,
		((s_label *) (p->ptr))->page);
      ++i;
    }
    p = p->next;
  }
  return i;
}

static int
get_label (char buf[],
	   char *label, char *pageref_mode,
	   char *list, char *list_mode, char *page)
{
  int i = sscanf ((char *) (buf),
		  "{%128[^}]}{%128[^}]}{%128[^}]}{%128[^}]}{%128[^}]}\n",
		  label, pageref_mode, list, list_mode, page);

  return i != 5 ? 1 : 0;
}
