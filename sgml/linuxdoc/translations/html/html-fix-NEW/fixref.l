/*
 * Modified on Thu, Oct 26 1995 
 *   by Steve Tynor (tynor@atlanta.twr.com). 
 *      - Now splits by <chapt> and <sect> instead of just <sect> (when 
 *        invoked with the "-2" command line option).
 */
%{

#include <stdio.h>
#include <string.h>

#define DEBUG

char sectname[256];

int filenum = 0;
int homefile = 1;
/* int big_page_mode = 1; */
int big_page_mode = 0;
int chapter_mode = 0;

/*
 * <sect> causes a new page if 1) not big_page_mode OR 2) not chapter_mode
 * <ssect> causes a new page if 1) not big_page_mode AND 2) not chapter_mode
 */
%}

%%

^"<@@ssect>".*$		{
  if((!big_page_mode) && (!chapter_mode))
     { 
        filenum++; homefile=0; 
     }
}
^"<@@sect>".*$		{
  if((!big_page_mode) || (!chapter_mode))
     { 
        filenum++; homefile=0; 
     }
}
^"<@@chapt>".*$		{ chapter_mode = 1; filenum++; homefile=0; }
^"<@@endchapt>".*$	{ }
^"<@@endsect>".*$	{ }
^"<@@endssect>".*$	{ }

^"<@@enddoc>".*$	{

  printf( "<@@sectcount>%d\n", filenum );

}

^"<@@label>".*$		{

strcpy( sectname, yytext+9 );
printf( "<@@labelp>%s#%d\n", sectname, homefile?0:filenum );

}

.|\n			;



%%

void
main( int argc, char **argv )
{
  int i;
  for (i = 1; i < argc; i++)
    {
      if (0 == strcmp("-2", argv[i]))
	{
	  big_page_mode = 0;
	}
      else
	{
	  fprintf (stderr,
		   "%s: Warning: unhandled command line option \"%s\"\n",
		   argv[0], argv[i]);
	}
    }
  yylex();
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
 
