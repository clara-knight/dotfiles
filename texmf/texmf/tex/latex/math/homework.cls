\ProvidesClass{homework}
\LoadClass[letterpaper]{scrartcl} % A4 paper and 11pt font size

\RequirePackage{xkeyval}
\def\myclass{}
\def\hwnumber{}
\def\instructor{}
\def\myname{}

\define@key{homework.cls}{myclass}{\def\myclass{#1}}
\define@key{homework.cls}{hwnumber}{\def\hwnumber{#1}}
\define@key{homework.cls}{instructorname}{\def\instructor{#1}}
\define@key{homework.cls}{myname}{\def\myname{#1}}

\ProcessOptionsX

\RequirePackage{mytheme}

\RequirePackage{scrlayer-scrpage} % KOMA-Script headers and footers
\RequirePackage{lastpage}
\pagestyle{scrheadings} % Use KOMA-Script page style
\clearpairofpagestyles % Clear all headers and footers first
\cfoot{\raisebox{-.083333in}{Page \thepage\ of \pageref{LastPage}}} % Page numbering for center footer
\KOMAoptions{headsepline=0.4pt, footsepline=0.4pt} % Header rule thickness
\setlength{\headheight}{27.2pt} % Customize the height of the header for two lines
\setlength{\footheight}{25pt} % Accommodate footer text with added spacing
\setkomafont{sectioning}{\normalfont\bfseries} % Make all sections normal font and bold


\RequirePackage{geometry}
\def \v {\vspace{0.2cm}}
\geometry{
	left=1.25in, % left margin
	right=1.25in, % right margin
	bottom=1in,
}
\fontsize{10}{20}\selectfont
%----------------------------------------------------------------------------------------
%	TITLE SECTION
%----------------------------------------------------------------------------------------

% Custom header with full-width table
\chead{\upshape\begin{tabularx}
	{\textwidth}{@{}
		>{\raggedright\arraybackslash}X
		>{\centering\arraybackslash}X
		>{\raggedleft\arraybackslash}X
		@{}}
	\myclass & \textbf{Homework \hwnumber} & \phantom{placeholder} \\
	Instructor: \instructor & & \myname
\end{tabularx}}
