% Bestand: uva-inf-presentatie.cls
% Auteur:  Stephen Swatman (s.n.swatman@uva.nl)
%
% Dit bestand is het template dat binnen het informatica onderwijs
% wordt gebruikt om de presentaties te maken. Het studenten template is een
% aangepaste versie hiervan in een andere kleur.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uva-inf-presentation}

\RequirePackage{translations}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{arrayjobx}
\RequirePackage[percent]{overpic}
\RequirePackage{tikz}
\RequirePackage[utf8x]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage{booktabs}

\input{uva-inf-common}

% Geef opties door aan de beamer klasse. Gaat voornamelijk om de aspect ratio.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}

% Registreer of de gebruiker een sidebar wil.
\DeclareOption{sidebar}{\newcommand{\addsidebar}{}}
\ProcessOptions

\LoadClass[14pt]{beamer}

\definecolor{achtergrond}{RGB}{27,78,117}

% Deze code wordt uitgevoerd om de sidebar te maken.
\ifdefined\addsidebar

% Laad de sidebar.
\useoutertheme[width=2cm,height=0cm,right]{sidebar}

% Maak een omgeving zonder sidebar voor de titelpagina.
\newenvironment{titelframe}{
    \advance\textwidth\beamer@sidebarwidth\begin{frame}
}{
    \end{frame}
}

% Thema van de sidebar.
\setbeamertemplate{sidebar \beamer@sidebarside}{
    \vspace{3mm}
    \hskip1.7pt
    % Print de titel van de bijeenkomst.
    {
        \usebeamerfont{title in sidebar}\usebeamercolor[fg]{title in sidebar}
        Bijeenkomst \@jaar.\@blok.\@bijeenkomst\par
    }

    % Dit maakt de daadwerkelijke navigatie.
    \insertverticalnavigation{\beamer@sidebarwidth}
}
\else

% Zonder sidebar hoeft de titel omgeving niks te doen!
\newenvironment{titelframe}{\begin{frame}}{\end{frame}}
\fi

% De achtergrond van de hele presentatie.
\setbeamertemplate{background}{
    % De hele achtergrond is een prachtige tikz tekening.
    \begin{tikzpicture}
        % Vul de achtergrond eerst met kleur.
        \fill[color=achtergrond] (0,0) rectangle (\paperwidth,\paperheight);
        % Teken een + en draai het 45 graden om een Andreaskruis te maken.
        \andreas{0.859375\paperwidth}{0}{2}{black}
        % De balk aan de onderkant moet wit zijn.
        \fill[color=white] (0,0) rectangle (\the\paperwidth,0.08\paperheight);
    \end{tikzpicture}
}

% De stijl van de titelpagina.
\setbeamertemplate{title page}{
    \vfill

    {\centering
		{\Large\bfseries\inserttitle}\\[0.5cm]
        \begin{tikzpicture}
        \definecolorseries{kruisserie}{rgb}{last}{achtergrond}{white!99!black}
        \definecolorseries{kruisseriereverse}{rgb}{last}{white!99!black}{achtergrond}
        \newcommand\numcross{9}
        \resetcolorseries[\numcross]{kruisserie}
        \resetcolorseries[\numcross]{kruisseriereverse}
        \colorlet{andreastmp}{kruisseriereverse!!+}

        \foreach \n in {0,...,\the\numexpr\numcross*2\relax} {
            \ifnum \n>\numcross\relax
            \colorlet{andreastmp}{kruisseriereverse!!+}
            \else
            \colorlet{andreastmp}{kruisserie!!+}
            \fi
            \andreas{0.5*\n}{0}{0.12}{andreastmp}
        }
        \end{tikzpicture}\\[0.5cm]
	    \@date\\[0.4cm]
    }

	\begin{minipage}[t]{0.4\paperwidth}
        \footnotesize
		\begin{flushleft}
			\emph{\ifnum\value{authorcount}>1\relax
                    \GetTranslation{students}%
                  \else
                    \GetTranslation{student}%
                  \fi:}\\
          \foreach \index in {1, ..., \value{authorcount}} {%
              {\getprefix{author\index}\\ {\getprefix{uva\index}\\[0.2cm]}}
          }
		\end{flushleft}
	\end{minipage}
    ~
	\begin{minipage}[t]{0.4\paperwidth}
        \footnotesize
		\begin{flushright}
			\ifdefempty{\@tutor}{}{
    			\emph{\GetTranslation{tutor}:} \\
    			\@tutor \\[0.2cm]
			}
			\ifdefempty{\@mentor}{}{
    			\emph{\GetTranslation{mentor}:} \\
    			\@mentor \\[0.2cm]
			}
			\ifdefempty{\@group}{}{
    			\emph{\GetTranslation{group}:} \\
    			\@group \\[0.2cm]
    		}
			\ifdefempty{\@docent}{}{
    			\emph{\GetTranslation{lecturer}:} \\
    			\@docent \\[0.2cm]
    		}
		\end{flushright}
	\end{minipage}
    \vfill
}

% De stijl van de titel van elke pagina.
\setbeamertemplate{frametitle}{
    \vskip0.2cm
    \begin{beamercolorbox}[ht=1.2cm,center]{frametitle}
    \insertframetitle
    \end{beamercolorbox}
}

% De stijl van de witte regel onderin.
\setbeamertemplate{footline}{
    \usebeamercolor[fg]{footer}
    % Eerste blok bevat het UvA logo.
    \begin{minipage}[c][0.08\paperheight]{.4\paperwidth}
    \hspace*{0.012\linewidth}\vspace{-0.4mm}
    \begin{overpic}[height=0.05\paperheight]{logoUvA_nl}
    \put (12.5,0) {\textsc{\scriptsize Informatica}}
    \end{overpic}
    \end{minipage}
    \hfill
    \begin{minipage}[c][0.08\paperheight]{.1\paperwidth}
    \centering
    \textsc{\insertframenumber~\GetTranslation{of} \inserttotalframenumber}
    \end{minipage}
    \hfill
    \begin{minipage}[c][0.08\paperheight]{.4\paperwidth}
    \raggedleft
    \textsc{\@course}
    \end{minipage}
    \hspace*{0.02\linewidth}
}

% Secties in de navigatie waar we nu zijn drukken we dik.
\setbeamertemplate{subsection in sidebar}{
    \beamer@sidebarformat{3.5pt}{subsection in sidebar}{\textbf{\insertsubsectionhead}}
}

% Elke section krijgt ook een page.
\setbeamertemplate{section page}{
    \vfill
    \begin{beamercolorbox}{title}
        \centering\usebeamerfont{title}\insertsection
    \end{beamercolorbox}
    \vfill
}

% Stel de kleuren in. Meeste is wit.
\setbeamercolor{normal text}{fg=white}
\setbeamercolor{title}{fg=white}
\setbeamercolor{frametitle}{fg=white}
\setbeamercolor{footer}{fg=black}
\setbeamercolor{structure}{fg=white}

% Het soort bullets dat we willen gebruiken.
\setbeamertemplate{itemize items}[circle]
\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{itemize subitem}{\color{white}--}
