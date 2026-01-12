\LoadClass{tufte-handout} % A4 paper and 11pt font size
\ProvidesClass{notes}

\RequirePackage{sectsty} % Allows customizing section commands
\allsectionsfont{\normalfont \bfseries} % Make all sections centered, the default font and small caps

\RequirePackage{fancyhdr} % Custom headers and footers
\pagestyle{fancyplain} % Makes all pages in the document conform to the custom headers and footers
\fancyhead{} % No page header - if you want one, create it in the same way as the footers below
\fancyfoot[L]{} % Empty left footer
\fancyfoot[C]{} % Empty center footer
\fancyfoot[R]{\thepage} % Page numbering for right footer
\renewcommand{\headrulewidth}{0pt} % Remove header underlines
\renewcommand{\footrulewidth}{0pt} % Remove footer underlines
\setlength{\headheight}{13.6pt} % Customize the height of the header

\RequirePackage{geometry}
\def \v {\vspace{0.2cm}}
\geometry{
	left=13mm, % left margin
	textwidth=130mm, % main text block
	marginparsep=8mm, % gutter between main text block and margin notes
	marginparwidth=55mm % width of margin notes
}
\fontsize{10}{20}\selectfont
%----------------------------------------------------------------------------------------
%	TITLE SECTION
%----------------------------------------------------------------------------------------

\title{	
	\normalfont\normalsize 
%	{University of California, Los Angeles - Summer 2025} \\ [0pt] % Your university, school and/or department name(s)
	\huge Math 110BH class notes% The assignment title
} % Your name
\date{\vspace{-5pt}\normalsize} %06/23/2025} % Today's date or a custom date

