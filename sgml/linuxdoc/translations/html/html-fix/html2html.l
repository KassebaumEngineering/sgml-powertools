/* -*- c -*- */

/* Modified on Sat, Aug 26 1995 
 *    by Leander Jedamus (jedamus@Worms.Fh-Rpl.DE). 
 *
 * Modified on Thu, Oct 26 1995 
 *   by Steve Tynor (tynor@atlanta.twr.com). 
 *      - Now splits by <chapt> and <sect> (or <sect> and <sect1> depending on
 *        whether this is a <report> or <article>) instead of just <sect>.
 *        "new" behavior (splitting on two sections is
 *        invoked via the "-2" option. (WARNING: be sure to invoke fixref with
 *        the same option else filecount will be inconsistent).
 *      - Puts the "Previous"/"Next" links at the top of each page in addition 
 *        to the bottom (easier to browse)
 *      - Puts the "Previous" link before the "Next" one.
 *      - Added "-fat" option to use ".htm" filename extension for DOS FAT
 *        legal names.
 *      - Improved error messages for bad labels, etc.
 *      - Reformatted slightly to use consistent indentation style (used what
 *        appeared to be the prevailing style :-))
 *      - <TITLE> now contains chapter/section names and is stripped of any
 *        markup codes.
 *      - <appendix> numbered from 'A'...
 * 
 * Modified on Thu, Oct 26 1995 
 *   by Steve Tynor (tynor@atlanta.twr.com). 
 *      - Fixed lack of error checking for failed fopen().
 * 
 * Modified on Thu, Oct 26 1995 
 *   by Steve Tynor (tynor@atlanta.twr.com). 
 *      - Browse links now use "<img>"
 *
 * Modified on Fri Dec 29 1995
 *   by Greg Hankins
 *      - fixed newline after URL problem (it's a hack), based on fix by
 *        Tom Lane <tgl@sss.pgh.pa.us>
 *
 * Modified on Thu Jan  4 1996
 *   by Greg Hankins
 *      - made chars unsigned, for ISO-8859-1, Tristan Debeaupuis
 *        <Tristan.Debeaupuis@hsc.fr.net>
 *
 * Modified on Sat Jan 20 1996
 *   by Tom Lane
 *      - Browse links use images or text according to "-img" option
 *      - eliminate zero-area anchors in headings and TOC
 *      - eliminate duplicate </HEAD><BODY>
 *      - eliminate empty <UL></UL> in TOC for sectionless chapter
 *      - fix newline after <ref> (same hack as for URLs)
 *
 *
 * Modified on Thu Feb 22 1996
 *  by Juergen Seeger
 *       - added international language support for names of links
 *       - added some ANSI strict stuff
 *       - added some #defines
 *
 */

%{

/* #include <malloc.h> */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* #define DEBUG */

FILE *out = stdout;

char *html_extension = "html"; /* Use Unix style ".html" by default */

int big_page_mode = 1; /* default is backwards compatible */

int use_imgs = 0; /* default is backwards compatible */

/* <report> style uses <chapt> as the top-level section; <article> uses
   <sect>.  We need to know whether a <sect> should be numbered as "n"
   or "n.m".  We assume <article> more unless we see a <chapt> */
int chapter_mode = 0;
int in_appendix = 0;

int in_section_list = 0;

#define MAX 256
#define BMAX 2048
#define LMAX 4096

unsigned char buf[BMAX], chaptname[MAX], sectname[MAX], titlename[MAX], labeltxt[MAX];
unsigned char firstname[MAX], outname[MAX];
unsigned char language[MAX];
unsigned char ssectname[MAX], Tmp1[LMAX], Tmp2[MAX], headname[MAX];
unsigned char urlname[MAX], Headbuf[LMAX], refname[MAX];

unsigned char Previous_Page[MAX], Next_Page[MAX], Table_of_Contents[MAX];;

int filenum = 1;
int filecount = 1;
int tmpfn;
int secnr = 0;
int ssecnr;
int current;
int skipnewline = 0;

extern char *yytext;
extern int yyleng;

#define CHAPTER 1
#define SECTION 2
#define SUBSECT 3
#define PART    4

/* decls */

struct lprec
  {
    unsigned char *label;
    int fileno;
    struct lprec *next;
  };

typedef struct lprec lprec;

void fatal_perror ( char *fmt, char *arg );
void choose_language( void );
int getstr( unsigned char *str, int n );
lprec *putlp( unsigned char *lbl, int fn );
lprec * getlp( unsigned char *lbl );
unsigned char *section_num( int secnr, int ssecnr );
void browse_links ( FILE *out, int this_filenum, int top );
void strip_markup( FILE *out, unsigned char *str);
void heading( FILE *out );
void start_chapter( unsigned char *sectname);
void start_section( unsigned char *ssectname);
/*       */

void choose_language( void )
  {
    FILE *f;
    unsigned char label[MAX], value[MAX];
    int vanz;
    
    /* take defaults */
    strcpy( Previous_Page , "Previous" );
    strcpy( Next_Page , "Next" );
    strcpy( Table_of_Contents , "Table of Contents" );

    if( language[0] != '\0' )
      { /* read file language */
	if( !( f = fopen( language,"r" )))
	  fatal_perror( "can't open language file \"%s\"\n", language);
    
	while( ( vanz = fscanf( f, "%s %s", label, value )) != EOF )
	  {
	    if( vanz != 2 )
	      fatal_perror( "wrong format in language file %s, line %i\n",
			    language );
	    
	    if( !strcmp( "PrevPage:", label ))
	      strncpy( Previous_Page, value, MAX );
	    else if ( !strcmp( "NextPage:", label ))
	      strncpy ( Next_Page, value, MAX );
	    else if ( !strcmp( "TOC:", label ))
	      strncpy ( Table_of_Contents, value, MAX );
	    else
	      fatal_perror( "Wrong label in language file: %s\n",
			    label );
	  }	    

	fclose(f);
      }
  }


void fatal_perror ( char *fmt, char *arg )
  {
    fprintf( stderr, "html2html: Fatal: " );
    fprintf( stderr, fmt, arg);
    perror( "\nReason");
    exit(1);
  }

int getstr( unsigned char *str, int n )
  {
    int i;
#ifdef DEBUG
    fprintf( stderr, "DEBUG: yytext: <<%s>>\n", yytext );
#endif
    if( strlen( yytext ) == n )
      return 0;
    strncpy( str, yytext+n, yyleng-n);
    str[ yyleng-n ] = 0;
    return 1;
  }

lprec *putlp();
lprec *getlp();

lprec *lp_table = (lprec *)0;
lprec *tmplp;

lprec *
putlp( unsigned char *lbl, int fn )
  {
    lprec *ptr;
    ptr = (lprec *) malloc (sizeof (lprec));
    ptr->label = (unsigned char *) malloc (strlen (lbl) +1 );
    strcpy( ptr->label, lbl );
    ptr->fileno = fn;
    ptr->next = (struct lprec *)lp_table;
    lp_table = ptr;
    return ptr;
  }

lprec *
getlp( unsigned char *lbl )
  {
    lprec *ptr;
    for (ptr = lp_table; ptr != (lprec *) 0;
	 ptr = (lprec *)ptr->next)
      if (strcmp (ptr->label,lbl) == 0)
	return ptr;
    return 0;
  }

static unsigned char section_num_buf[MAX];
unsigned char *section_num( int secnr, int ssecnr )
  {
    /* Idempotent - OK to call more than once as long as the args are the same */
    if (in_appendix)
      if (ssecnr > 0)
	sprintf (section_num_buf, "%c.%d", 'A'-1+secnr, ssecnr);
      else
	sprintf (section_num_buf, "%c", 'A'-1+secnr);
    else
      if (ssecnr > 0)
	sprintf (section_num_buf, "%d.%d", secnr, ssecnr);
      else
	sprintf (section_num_buf, "%d", secnr);
    return section_num_buf;
  }

void browse_links ( FILE *out, int this_filenum, int top )
  {
    if (!top) 
      {
	fprintf( out, "<HR>\n" );
      }

    if (out == stdout)
      {
	/* The bottom of the TOC will come in as "this_filenum == filecount".
	   We want the browse button to point "next" to the first page, not
	   "previous" to the last one! */
	this_filenum = 1;
      }

    /*
     * NOTE: For pages where a next or prev button isn't appropriate, include
     * the graphic anyway - just don't make it a link. That way, the mouse
     * position of each button is unchanged from page to page.
     */
    
    /* Use the passed this_filenum since filenum may already be incremented */
    if (this_filenum>=3)
      {
	sprintf(Tmp1,"%s-%d.%s",firstname, (this_filenum - 2), html_extension);
	fprintf(out, "<A HREF=\"%s\">%s</A>\n", Tmp1,
		use_imgs ?
		"<IMG SRC=\"prev.gif\" ALT=\"Previous\">" : 
		(char *) Previous_Page );
      }
    else
      {
	fprintf(out, "%s\n",
		use_imgs ?
		"<IMG SRC=\"prev.gif\" ALT=\"Previous\">" : 
		(char *) Previous_Page );
      }
    if (this_filenum<filecount)
      {
	sprintf(Tmp2,"%s-%d.%s",firstname, (this_filenum ), html_extension);
	fprintf(out, "<A HREF=\"%s\">%s</A>\n", Tmp2,
		use_imgs ?
		"<IMG SRC=\"next.gif\" ALT=\"Next\">" : 
		(char *) Next_Page );
      }
    else
      {
	fprintf(out, "%s\n",
		use_imgs ?
		"<IMG SRC=\"next.gif\" ALT=\"Next\">" : 
		(char *) Next_Page );
      }

    if (out != stdout)
      { /* No need for TOC pointer on the TOC page! */
	sprintf(Tmp2,"%s.%s",firstname, html_extension);
	fprintf(out, "<A HREF=\"%s#toc%s\">%s</A>\n", 
		Tmp2, section_num(secnr, 0),
		use_imgs ?
		"<IMG SRC=\"toc.gif\" ALT=\"Contents\">" : 
		(char *) Table_of_Contents );
      }
    else
      {
	fprintf(out, "%s\n", 
		use_imgs ?
		"<IMG SRC=\"toc.gif\" ALT=\"Contents\">" : 
		(char *) Table_of_Contents );
      }
    
    if (top) 
      fprintf( out, "<HR>\n" );     
  }

void strip_markup( FILE *out, unsigned char *str)
  {
    unsigned char *p = str;
    while (*p)
      {
	if (*p == '<')
	  {
	    /* Skip to the end of the formatting code */
	    while (*p && (*p != '>')) p++;
	  }
	else
	  {
	    fputc( *p, out );
	  }
	p++;
      }
  }

void heading( FILE *out )
  {
    /*
     * SDT: I'd like to include the following, but can't since we emit <TABLE>
     * markup for tables and that's not HTML 2.0 conformant:
     *
     * fprintf(out, "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n");
     */
    fprintf( out, "<HTML>\n<HEAD>\n<TITLE>");
    strip_markup( out, titlename );
    if (secnr > 0)
      {
	fprintf( out, ": ");
	strip_markup( out, sectname);
      }
    if (ssecnr > 0)
      {
	fprintf( out, ": ");
	strip_markup( out, ssectname);
      }
    fprintf( out, "</TITLE>\n" );
    fprintf( out, "</HEAD>\n<BODY>\n" );
    browse_links( out, filenum, 1 );
  }

void footing( FILE *out )
  {
    browse_links( out, filenum/*-1*/, 0);
    fprintf( out, "</BODY>\n</HTML>\n" );
  }

void start_chapter( unsigned char *sectname)
  {
    if( out != stdout ) 
      {
	footing( out );
	fclose( out );
      }

    current=SECTION;
    secnr++;
    ssecnr=0;
    sprintf( outname, "%s-%d.%s", firstname, filenum++, html_extension );
    out = fopen( outname, "w" );
    if (! out )
      {
	fatal_perror ("Could not open file \"%s\"", outname);
      }
    
    heading( out );
    sprintf( Headbuf, "<A NAME=\"s%s\">%s. %s</A>",
	    section_num (secnr, 0),
	    section_num (secnr, 0),
	    sectname );
    fprintf( stdout, "<P>\n<H2><A NAME=\"toc%s\">%s.</A> <A HREF=\"%s\">%s</A></H2>\n",
	    section_num (secnr, 0),
	    section_num (secnr, 0),
	    outname, sectname );
    in_section_list = 0;
  }

void start_section( unsigned char *ssectname)
  {
    current=SUBSECT;
    ssecnr++;

    if (! big_page_mode)
      {
	if( out != stdout ) 
	  {
	    footing( out );
	    fclose( out );
	  }
	
	sprintf( outname, "%s-%d.%s", firstname, filenum++, html_extension );
	out = fopen( outname, "w" );
	if (! out )
	  {
	    fatal_perror ("Could not open file \"%s\"", outname);
	  }
	heading( out );
	/*
	 * Since only one section is on any page, don't use # so that when we
	 * jump to this page, we see the browse links at the top of the page. 
	 */
	sprintf( Headbuf, "%s %s",
		section_num (secnr, ssecnr), ssectname );
	if (! in_section_list)
	  {
	    fprintf( stdout, "<UL>\n" );
	    in_section_list = 1;
	  }
	fprintf( stdout, "<LI><A HREF=\"%s\">%s %s</A>\n",
		outname, section_num(secnr, ssecnr), ssectname );
      }
    else
      {
	/*
	 * Since many sections are on one page, we need to use # 
	 */
	sprintf( Headbuf, "<A NAME=\"ss%s\">%s %s</A>",
		section_num(secnr, ssecnr),
		section_num(secnr, ssecnr),
		ssectname );
	if (! in_section_list)
	  {
	    fprintf( stdout, "<UL>\n" );
	    in_section_list = 1;
	  }
	fprintf( stdout, "<LI><A HREF=\"%s#ss%s\">%s %s</A>\n",
		outname,
		section_num(secnr, ssecnr),
		section_num(secnr, ssecnr),
		ssectname );
      }
  }

%}

%s SECT

%%

^"<@@appendix>".*$		{ in_appendix = 1; secnr=0; ssecnr=0; }

^"<@@url>".*$		{

  skipnewline=1;
  getstr( urlname, 7 ); 
  sprintf( Headbuf, "<A HREF=\"%s\">", urlname);
}

^"<@@urlnam>".*$	{
  sprintf( Tmp1, "%s</A>", urlname);
  strcat (Headbuf, Tmp1);
}

^"<@@endurl>".*$	{

  skipnewline= -1; /* swallow 1 newline after endurl */
  fprintf( out, "%s", Headbuf);
  strcpy (Headbuf,"");
}

^"<@@title>".*$ 	{

  strcpy( titlename, yytext+9 );
  heading( stdout );
  printf( "<H1>%s</H1>\n", titlename );
}

^"<@@head>".*$		{

  skipnewline=1;
  getstr( headname, 8 ); 
  sprintf( Headbuf, "%s", headname);
}

^"<@@part>".*$		{
  current = PART;
}

^"<@@endhead>".*$	{

  switch (current){
  case PART:
    current=0;
    break;
  case CHAPTER:
    current=0;
    fprintf( out, "<H1>%s</H1>\n", Headbuf);
    break;
  case SECTION:
    current=0;
    fprintf( out, "<H2>%s</H2>\n", Headbuf);
    break;
  case SUBSECT:
    current=0;
    fprintf( out, "<H2>%s</H2>\n", Headbuf);
    break;
  default:
    current=0;
    fprintf( out, "<H3>%s</H3>\n", Headbuf);
    break;
  }
  strcpy(Headbuf, "");
  skipnewline=0;
}

^"<@@chapt>".*$		{ 

  chapter_mode = 1;
  skipnewline=1;
  getstr( sectname, 9 ) ;

  start_chapter( sectname );
}

^"<@@sect>".*$		{ 

  skipnewline=1;
  getstr( ssectname, 8 ) ;

  if (chapter_mode)
    {
      start_section( ssectname );
    }
  else
    {
      strcpy( sectname, ssectname );
      start_chapter( ssectname );
    }
}

^"<@@ssect>".*$          { 

  skipnewline=1;
  getstr( ssectname, 9 ) ;
  if (!chapter_mode)
    {
      start_section( ssectname );
    }
  else
    {
      current=0;
      sprintf( Headbuf, "%s", ssectname );
    }  
}

^"<@@endchapt>".*$	{

  if (in_section_list)
    fprintf(stdout,"</UL>\n");
  if( out != stdout )
    {
      footing( out );
      fclose(out);
      out = stdout;
    }
}

^"<@@endsect>".*$	{

  if (!chapter_mode && in_section_list)
    fprintf(stdout,"</UL>\n");
  if(( out != stdout ) && ((!chapter_mode) || (! big_page_mode)))
    {
      footing( out );
      fclose(out);
      out = stdout;
    }
}

^"<@@endssect>".*$       {
  if(( out != stdout ) && (!chapter_mode) && (! big_page_mode))
    {
      /* fprintf(stdout,"</UL>\n"); */
      footing( out );
      fclose(out);
      out = stdout;
    }
}

^"<@@enddoc>".*$      ;

^"<@@sectcount>".*$   {

  if (sscanf( yytext, "<@@sectcount>%d", &filecount ) != 1)
    {
      fprintf( stderr, "Problem with @@sectcount!\n");
    }
  else
    {
      filecount++;
    };
};


<SECT>^"<@@label>".*$	{
  
  strcpy( Tmp2, yytext+9 );
  if (!getlp( Tmp2 ))
    {
      fprintf( stderr, "Problem with @@label (%s)!\n", yytext+9);
    } 
  else
    {
      strcpy( labeltxt, Tmp2 );
    }
}

^"<@@label>".*$		{
  
  strcpy( Tmp2, yytext+9 );
  if (!getlp( Tmp2 ))
    {
      fprintf( stderr, "Problem with @@label (%s)!\n", yytext+9 );
    } 
  else
    {
      if( skipnewline ) {
        sprintf( Tmp1, "<A NAME=\"%s\"></A> %s", Tmp2, Headbuf);
	strcpy (Headbuf, Tmp1);
	strcpy (Tmp1,"");
      } else {
        fprintf( out, "<A NAME=\"%s\"></A> ", Tmp2 );
      }
    }
}


^"<@@labelp>".*$	{

#ifdef DEBUG
  fprintf( stderr, "DEBUG: yytext = <<%s>>\n", yytext );
#endif
  if (sscanf( yytext, "<@@labelp>%[^#]#%d", Tmp1, &tmpfn ) != 2)
{
  fprintf( stderr, "Problem with @@labelp (%s)!\n", yytext);
#ifdef DEBUG
  fprintf( stderr, "DEBUG: sectname = <<%s>>\n", Tmp1);
  fprintf( stderr, "DEBUG: tmpfn = <<%d>>\n", tmpfn );
#endif
} else
  putlp( Tmp1, tmpfn );

}

^"<@@ref>".*$           {

  strcpy( refname, yytext+7 );
  if (!(tmplp = getlp( refname )))
{
  fprintf( stderr, "Problem with @@ref(id = %s)!\n", refname );
  skipnewline++;
} else {
  
  if(tmplp->fileno==(filenum-1)) {
    sprintf( Tmp1, "<A HREF=\"#%s\">", refname );
  } else if(tmplp->fileno==0) {
    sprintf( Tmp1, "<A HREF=\"%s.%s#%s\">", firstname, html_extension, refname );
  } else { 
    sprintf( Tmp1, "<A HREF=\"%s-%d.%s#%s\">", firstname, tmplp->fileno,
	    html_extension, refname );
  }

  if(skipnewline) {
    strcat( Headbuf, Tmp1);
  } else {
    strcpy( Headbuf, Tmp1);
  }
  skipnewline++ ;
}
}

^"<@@refnam>".*$	{

  sprintf( Tmp1,"%s</A>", refname );
  strcat ( Headbuf, Tmp1);
}

^"<@@endref>".*$	{

  switch (skipnewline) {
  case 1:
    fprintf( out, "%s", Headbuf );
    skipnewline= -1; /* swallow 1 newline after endref */
    break;
  case 2:
    skipnewline--;
    break;
  default:
    fprintf( stderr, "Problem with @@endref!\n" );
    skipnewline--;
    break;
  }
}

<SECT>^.*$		{ 

  getstr( sectname, 0 );

  if( out != stdout ) 
{
  footing( out );
  fclose( out );
}
  sprintf( outname, "%s-%d.%s", firstname, filenum++, html_extension );
  out = fopen( outname, "w" );
  if (! out )
     {
       fatal_perror ("Could not open file \"%s\"", outname);
     }
  heading( out );
  if( strlen( labeltxt ))
{
  fprintf( out, "<A NAME=\"%s\"></A>\n", labeltxt );
  labeltxt[0] = 0;
}
  fprintf( out, "<H1>%s</H1>", sectname );
  fprintf( stdout, "<H2><A HREF=\"%s\">%s</A></H2>\n", outname,
	  sectname );

  BEGIN(0);
}

.*			{

  if (skipnewline) {
    strcat(Headbuf, yytext );
  } else if( out != stdout ) {
    fprintf( out, "%s", yytext );
  } else {
    ECHO;
  }
}

\n			{

  if(!skipnewline) {
    if( out != stdout )
      {
	fprintf( out, "%s", yytext );
      }
    else
      {
	ECHO;
      }
  }
  if (skipnewline < 0)
    skipnewline++;
}


%%

void
main( int argc, unsigned char **argv )
{
  int i;

  strcpy( firstname, "$$" );
  language[0]='\0';
  for (i = 1; i < argc; i++)
    {
      if (0 == strcmp("-2", argv[i]))
	{
	  big_page_mode = 0;
	}
      else if (0 == strcmp("-fat", argv[i]))
	{
	  html_extension = "htm";
	}
      else if (0 == strcmp("-img", argv[i]))
	{
	  use_imgs = 1;
	}
      else if (0 == strncmp("-L", argv[i],2))
	{
	  strncpy( language, argv[i]+2, MAX );
	}
      else if (argv[i][0] != '-')
	{
	  strncpy( firstname, argv[i], MAX );
	}
      else
	{
	  fprintf (stderr,
		   "%s: Warning: unhandled command line option \"%s\"\n",
		   argv[0], argv[i]);
	}
    }

  choose_language();
  secnr=0;
  yylex();
  footing( stdout );
   
  if( out != stdout )
    {
      footing( out );
      fclose( out );      
    }

  exit( 0 );
}

/* Use the existing indentation style:
 Local variables:
 c-indent-level: 2
 c-continued-statement-offset: 2
 c-brace-offset: 0
 c-label-offset: -2
 End:
 */
 


