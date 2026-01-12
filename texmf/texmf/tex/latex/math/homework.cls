\LoadClass[letterpaper]{scrartcl} % A4 paper and 11pt font size
\ProvidesClass{homework}

\RequirePackage{mytheme}

\RequirePackage{scrlayer-scrpage} % KOMA-Script headers and footers
\RequirePackage{lastpage}
\pagestyle{scrheadings} % Use KOMA-Script page style
\clearpairofpagestyles % Clear all headers and footers first
\cfoot{\raisebox{-1.5pt}{Page \thepage\ of \pageref{LastPage}}} % Page numbering for center footer
\KOMAoptions{headsepline=0.4pt, footsepline=0.4pt} % Header rule thickness
\setlength{\headheight}{27.2pt} % Customize the height of the header for two lines
\setlength{\footheight}{25pt} % Accommodate footer text with added spacing
\setkomafont{sectioning}{\normalfont\bfseries} % Make all sections normal font and bold


\RequirePackage{geometry}
\def \v {\vspace{0.2cm}}
\geometry{
	left=19mm, % left margin
	right=19mm, % right margin
	bottom=25mm,
}
\fontsize{10}{20}\selectfont
%----------------------------------------------------------------------------------------
%	TITLE SECTION
%----------------------------------------------------------------------------------------

% Custom header with full-width table
\chead{
	\upshape \begin{tabularx}
		{\textwidth}{@{}>{\raggedright\arraybackslash}X>{\centering\arraybackslash}X>{\raggedleft\arraybackslash}X@{}}
		Math 110BH, W26 & \textbf{Homework } & \phantom{placeholder} \\
		Instructor: & & Student: Clara Knight
	\end{tabularx}
}

\newcounter{problemcounter}
\newenvironment{problem}[1]
{\refstepcounter{problemcounter}\par\noindent\theproblemcounter. #1\par\vspace{0.5em}}
{\par\vspace{1em}}


