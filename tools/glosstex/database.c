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

/* $Id: database.c,v 1.1.1.1 1997/08/22 04:02:15 jak Exp $ */

#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "glosstex.h"
#include "database.h"
#include "error.h"
#include "list.h"
#include "labels.h"

static unsigned int lineno = 0;

static void process_file (FILE * infile, char *inname);
static void process_line (char *inname, char *line);
static void write_line (FILE * outfile,
			char *list, char *label, char *item, char *longform,
			char *line, char *list_mode, char *pageref_mode,
			char *page);
static int glo_parse_item (char *line, char *label,
			   char *item, char *longform, int *ptr);

void
read_databases (void)
{
  FILE *dbfile;
  s_node *filename = databases.root;

  while (filename != 0) {
    if ((dbfile = fopen (filename->ptr, "r")) == NULL) {
      error ("database %s", (char *) filename->ptr);
    } else {
      printlog (PROGRESS, STDOUT, "(%s ", (char *) filename->ptr);
      process_file (dbfile, (char *) filename->ptr);
      printlog (PROGRESS, STDOUT, ")");
    }
    filename = filename->next;
  }
}

static void
process_file (FILE * dbfile, char *inname)
{
  enum e_state {
    HEADER, BODY
  };

  int status;
  char buf[LINESIZE];
  enum e_state state = HEADER;
  char *line = 0;

  while (fgets (buf, LINESIZE, dbfile) != 0) {
    if (buf[strlen (buf) - 1] == '\n')
      lineno++;

    status = strncmp (buf, "@entry{", 7);
    if ((state == HEADER) && (status != 0)) {
      ;				/* ignore heading garbage */
    } else {
      state = BODY;
      if (status == 0) {	/* begin new entry */

	/* process current entry before starting new entry */
	if (line != 0) {
	  process_line (inname, line);
	  free (line);
	}
	line = (char *) malloc (strlen (buf) + 1);
	assert (line != 0);
	strcpy (line, buf);

	if (line[strlen (line) - 1] == '\n')
	  line[strlen (line) - 1] = ' ';

      } else if (strncmp (buf, "%", 1) == 0) {
	;			/* skip comments */
      } else {			/* add lines to current entry */
	size_t len = strlen (line);	/* LINT: null is ok here */
	line = (char *) realloc (line, len + strlen (buf) + 1);
	assert (line != 0);
	strcpy (&line[len], buf);
	if (line[strlen (line) - 1] == '\n')
	  line[strlen (line) - 1] = ' ';
      }
    }
  }

  /* process last pending line in file */
  if (line != 0) {
    process_line (inname, line);
    free (line);
  }
}

static void
process_line (char *inname, char *line)
{
  char label[LINESIZE];
  char item[LINESIZE];
  char longform[LINESIZE];
  size_t index;
  int ptr = 0;
  s_label *node;

  if (glo_parse_item (line, label, item, longform, &ptr) != 0) {
    printlog (PROGRESS, STDOUT, "x");
    printlog (WARNING, LOGFILE, "\n%s:%u parse error: %s",
	      inname, lineno, line);
    count_gdf_parsing++;
    return;
  }
  /* remove all trailing spaces */
  index = strlen (&line[ptr]);
  index--;

  while (line[ptr + index] == ' ') {
    line[ptr + index] = '\0';
    index--;
  }

  /* only process entry if a corresponding label is present
     and if it is not already resolved -> first definition wins */
  node = find_label (FIND_FIRST, labels, label, 0);

  if (node == 0) {
    node = find_label (FIND_FIRST, labels, "*", 0);

    if (node == 0) {
      printlog (PROGRESS, STDOUT, ".");
      printlog (DEBUG, LOGFILE, "\n%s:%u %s@%s(%s) not needed",
		inname, lineno, label, item, longform);
    } else {
      while (node != 0) {
	write_line (outfile,
		    node->list, label, item, longform, &line[ptr],
		    node->list_mode, node->pageref_mode, node->page);
	node->flag = RESOLVED;

	node = find_label (FIND_NEXT, labels, "*", 0);
      }
    }
  } else {

    while (node != 0) {
      switch ((enum e_label_flag) node->flag) {
      case UNRESOLVED:
	write_line (outfile,
		    node->list, label, item, longform, &line[ptr],
		    node->list_mode, node->pageref_mode, node->page);
	node->flag = RESOLVED;
	break;

      case RESOLVED:
	printlog (PROGRESS, STDOUT, "i");
	printlog (INFORMATION, LOGFILE,
		  "\n%s:%u %s already resolved",
		  inname, lineno, label);
	count_gdf_defined++;
	break;
      }
      node = find_label (FIND_NEXT, labels, label, 0);
    }
  }
}

static void
write_line (FILE * outfile,
	    char *list, char *label, char *item, char *longform,
	    char *line, char *list_mode, char *pageref_mode, char *page)
{
  fprintf (outfile,
	   "\\GlossTeXEntry{%s%s@{%s}{%s}{%s}{%s}{%s}{%s}"
	   "{\\GlossTeXPage{%s}{%s}}|GlossTeXNull}{0}\n",
	   list, label, label, item, longform, line,
	   list, list_mode, pageref_mode, page);
  printlog (PROGRESS, STDOUT, "o");
  printlog (VERBOSE, LOGFILE, "\n%s:%u %s@%s(%s) used *",
	    inname, lineno, label, item, longform);
  count_gdf_success++;
}

/* #module    GloScan    "2-001"
   ***********************************************************************
   *                                                                     *
   * The software was developed at the Monsanto Company and is provided  *
   * "as-is".  Monsanto Company and the auther disclaim all warranties   *
   * on the software, including without limitation, all implied warran-  *
   * ties of merchantabilitiy and fitness.                               *
   *                                                                     *
   * This software does not contain any technical data or information    *
   * that is proprietary in nature.  It may be copied, modified, and     *
   * distributed on a non-profit basis and with the inclusion of this    *
   * notice.                                                             *
   *                                                                     *
   ***********************************************************************
 */

/* this has been slightly modified by volkan yavuz 1996/12/18 */

static int
glo_parse_item (char *line, char *label, char *item, char *longform, int *ptr)
{
  int i, brace;
  char x;

  /* Copy the label to the output string. */
  i = 0;
  brace = 1;
  *ptr = 7;
  while (1) {
    x = line[(*ptr)++];
    if (x == '\0')
      return 1;
    if (x == '{')
      if (line[*ptr - 2] != '\\')
	brace++;
    if (x == '}') {
      if (line[*ptr - 2] != '\\')
	brace--;
      if (brace <= 0)
	break;
    }
    if (x == ',')
      break;
    label[i++] = x;
  }
  label[i] = '\0';

  /* Find the beginning of the item string. */
  while (isspace (line[*ptr]) != 0)
    (*ptr)++;

  /* Copy the item to the output string. */
  i = 0;
  while (brace > 0) {
    x = line[(*ptr)++];
    if (x == '\0')
      return 1;
    if (x == '{')
      if (line[*ptr - 2] != '\\')
	brace++;
    if (x == '}') {
      if (line[*ptr - 2] != '\\')
	brace--;
      if (brace <= 0)
	break;
    }
    if (x == ',')
      break;
    item[i++] = x;
  }
  item[i] = '\0';

  /* Check to see if the item is missing. If it is, default to the label. */
  if (i == 0)
    (void) strcpy (item, label);	/* FIXME: lint code error */

  while (isspace (line[*ptr]) != 0)
    (*ptr)++;

  /* Copy the item to the output string. */
  i = 0;
  while (brace > 0) {
    x = line[(*ptr)++];
    if (x == '\0')
      return 1;
    if (x == '{')
      if (line[*ptr - 2] != '\\')
	brace++;
    if (x == '}') {
      if (line[*ptr - 2] != '\\')
	brace--;
      if (brace <= 0)
	break;
    }
    if (x == ',')
      break;
    longform[i++] = x;
  }
  longform[i] = '\0';

  return 0;			/* it's all ok */
}
