import 'package:logidee_tools/logidee_tools.dart';
import 'package:logidee_tools/visitor_check.dart';
import 'package:logidee_tools/visitor_slidegen.dart';
import 'package:logidee_tools/visitor_texgen.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';


void main()
{
  late LogideeTools parser;
  late String fname;
  late String outdir;
  setUp(()
  {
    //Directory current  = Directory.current;
    parser = LogideeTools();
    fname = "./assets/formation.xml";
    outdir = "/tmp";
  });
  group('validation',(){
    test('dtd validation',()
    {
      fname = "assets/formation_wrong.xml";
      expect(parser.loadXml(fname, outdir: outdir, verbose: false).valid,false);
      fname = "assets/formation.xml";
      expect(parser.loadXml(fname, outdir: outdir, verbose: true).valid,true);
    });
    test('xml structure test',()
    {
      VisitorCheck vis =  parser.loadXml(fname, outdir: outdir);
      parser.loadXml(fname, outdir: outdir);
      parser.loadXml(fname, outdir: outdir);
      //bool valid = parser.parse(fname, outdir: outdir, verbose:  true);
      if(!vis.valid) print("Parsing had errors: ${vis.errmsg}");
      expect(vis.valid,true);
      var list = parser.document!.findAllElements('formation');
      bool subvalid = true;
      //print("got back list: ${list.length} and $list");
      expect(list.length,1);
      XmlElement formation = list.first;
      late XmlElement node;
      vis.acceptFormation(formation, verbose:  true);
      if(!vis.valid)print("retour vis:\n${vis.errmsg}");
      for (var p0 in formation.children) {
        if(p0 is XmlElement && p0.name.toString() == "theme") node = p0;}
      expect(vis.valid,true);
      subvalid = true;
      late XmlElement module, slideshow;
      vis.acceptTheme(node);
      for (var p0 in node.children) {
        //(p0 is XmlElement)? print("theme child: ${p0.name.toString()}"):print("theme unknown: $p0 of ${p0.runtimeType}");
        if(p0 is XmlElement && p0.name.toString() == "module") {
          module= p0;
        } else if(p0 is XmlElement && p0.name.toString() == "slideshow") slideshow= p0;
      }
      expect(vis.valid,true);
      vis.acceptModule(module);
      expect(vis.valid,true);
      vis.acceptSlideShow(slideshow);
      expect(vis.valid,true);

      subvalid = true;
      for (var p0 in slideshow.children) {
        String value = (p0 is XmlElement)?p0.name.toString():"node";
        List<String> check = ["info","shortinfo","slide"];
        if(!check.any((listElement) => listElement.contains(value))) print("slideshow $p0 $value not in $check failed");
        subvalid &= check.any((listElement) => listElement.contains(value));
        //if(p0 is XmlElement && p0.name.toString() == "module") module= p0;
      }
      expect(subvalid,true);
      //print("got back list: ${node.children.length} and $node");
      //expect(node.children.length,1);
      vis.acceptFormation(formation);
      expect(vis.valid,true);

    });
  });
  group('full tex generation by visitor',(){
    test('script parsing',()
    {
      parser.loadXml(fname, outdir: outdir);
      VisitorTexgen txtVis = VisitorTexgen();
      XmlElement? root = parser.document?.getElement("formation");
      StringBuffer resBuf = StringBuffer();
      //print("PREPARATION OF visitor: $root");
      //if(root != null) FormationChecker(root,txtVis);
      //parser.parse(fname, outdir: outdir);
      var list = parser.document!.findAllElements('text');
      expect(list.length,0);
      String result = "\\emph{texte en évidence}";
      //txtVis.acceptEm(list.first,buffer: resBuf);
      //expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('em');
      expect(list.length,2);
      result = "\\emph{texte en évidence} ";
      txtVis.acceptEm(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('title');
      expect(list.length,19);
      result = "\\title{Le titre}\n";
      resBuf.clear();
      txtVis.acceptTitle(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('version');
      expect(list.length,3);
      result = "Auteur du texte2001-08-09";
      resBuf.clear();
      txtVis.acceptVersion(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('proofreaders');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptProofreaders(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('subtitle');
      expect(list.length,1);
      txtVis.clearAll();
      txtVis.stack.add("formation");
      result = "sous titre du Module";
      resBuf.clear();
      txtVis.acceptSubTitle(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('ratio');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptRatio(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('ref');
      expect(list.length,5);
      //result = "une référence à un élément nécessaire";
      result = "";
      resBuf.clear();
      txtVis.acceptRef(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('author');
      expect(list.length,3);
      result = "Auteur du texte";
      resBuf.clear();
      txtVis.acceptAuthor(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('email');
      expect(list.length,3);
      //result = "mon_email@mondomaine.tld ";
      result = "";
      resBuf.clear();
      txtVis.acceptEmail(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('comment');
      expect(list.length,3);
      //result = "Un commentaire de mise à jour";
      result = "";
      resBuf.clear();
      txtVis.acceptComment(list.last,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('date');
      expect(list.length,3);
      result = "2001-08-09";
      resBuf.clear();
      txtVis.acceptDate(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('level');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptLevel(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('legend');
      expect(list.length,1);
      result = "Schéma d'interconnexion";
      resBuf.clear();
      txtVis.acceptLegend(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('duration');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptDuration(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);


      list = parser.document!.findAllElements('prerequisite');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptPrerequisite(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('menu');
      expect(list.length,1);
      result = "{\\bfseries \\large un menu} ";
      resBuf.clear();
      txtVis.acceptMenu(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('cmd');
      expect(list.length,1);
      result = "{\\texttt ls -al} ";
      resBuf.clear();
      txtVis.acceptCmd(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('file');
      expect(list.length,1);
      result = "{\\texttt /etc/passwd}";
      resBuf.clear();
      txtVis.acceptFile(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('url');
      expect(list.length,2);
      result = "\\href{linuxfr.fr}{http://linux-france.org}";
      resBuf.clear();
      txtVis.acceptUrl(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('code');
      expect(list.length,1);
      result = '\\begin{minted}{}\nvoid main (void) {\nprintf("Hello World.\\n");\n}\\end{minted}\n';
      result ='\\begin{lstlisting}[language=C ]\nvoid main (void) {\nprintf("Hello World.\\n");\n}\\end{lstlisting}\n';
      resBuf.clear();
      txtVis.acceptCode(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('image');
      expect(list.length,3);
      List<String> results =[
        "\\includegraphics[scale=0.5]{logo.eps}",
        "\\includegraphics[scale=1]{schema.eps}\n\\captionof{figure}{Schéma d'interconnexion}"
      ];
      resBuf.clear();
      txtVis.acceptImage(list.first,buffer: resBuf);
      expect(resBuf.toString(),results[0]);
      resBuf.clear();
      txtVis.acceptImage(list.elementAt(1),buffer: resBuf);
      expect(resBuf.toString(),results[1]);
      list = parser.document!.findAllElements('table');
      expect(list.length,1);
      result = "\\begin{tabular}{|c|c|}\n\\hline\ncol1&col2 \\\\ \\hline\ncol3&col4 \\\\ \\hline\n\\end{tabular}";
      resBuf.clear();
      txtVis.acceptTable(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('math');
      expect(list.length,2);
      result = "\\begin{eqnarray}\nE = MC^2\n\\end{eqnarray}\n";
      resBuf.clear();
      txtVis.acceptMath(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      result = "{\\texttt [ Energie = Masse * Célérité au carré ]}";
      resBuf.clear();
      txtVis.acceptMath(list.last,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('item');
      //print("got back list: ${list.length} and $list");
      expect(list.length,17);
      result = "\\item Objectif 1\n";
      resBuf.clear();
      txtVis.acceptItem(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('list');
      //print("got back list: ${list.length} and $list");
      //expect(list.length,2);
      result = "\\begin{itemize}\n\\item something\n\\item \\begin{itemize}\n\\item item of sublist\n\\end{itemize}\n\n\\end{itemize}\n";
      resBuf.clear();
      txtVis.acceptList(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('para');
      //print("got back list: ${list.length} and $list");
      expect(list.length,17);
      resBuf.clear();
      txtVis.acceptPara(list.first,buffer: resBuf);
      result = "Une brève description\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('glossary');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptGlossary(list.first,buffer: resBuf);
      expect(list.length,4);
      result = " \\gls{IP} ";
      expect(resBuf.toString(),result);
      result = "\\newglossaryentry{IP}\n{\n name=IP, description={Internet Protocol}\n}\n";
      expect(txtVis.glossary.toString(),result);

      list = parser.document!.findAllElements('description');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptDescription(list.first,buffer: resBuf);
      expect(list.length,3);
      result = "Une brève description\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('suggestion');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptSuggestion(list.first,buffer: resBuf);
      expect(list.length,1);
      result = "";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('dependency');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptDependency(list.first,buffer: resBuf);
      expect(list.length,1);
      result = "";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('question');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptQuestion(list.first,buffer: resBuf);
      expect(list.length,2);
      result = "Écrivez un script qui imprime la table de multiplication de 1 à 10";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('answer');
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptAnswer(list.first,buffer: resBuf);
      expect(list.length,2);
      result = "\\includegraphics[scale=1]{images/exo-tablemult.pl.1.eps}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('exercise');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptExercise(list.first,buffer: resBuf);
      expect(list.length,2);
      result = """\\begin{mybox}{Exercise} \\label{Écrivez un script qui imprime la table de multiplication de 1 à 10}
Écrivez un script qui imprime la table de multiplication de 1 à 10\\end{mybox}
""";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('note');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptNote(list.first,buffer: resBuf);
      expect(list.length,2);
      result = "\\begin{mybox}{Note}\nun encadré pour evidencier des trucs\n\\end{mybox}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('section');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme")..add("module")..add("page");
      txtVis.acceptSection(list.first,buffer: resBuf);
      expect(list.length,8);
      result = """\\section{section sans info}
\\emph{texte en évidence} {\\bfseries \\large un menu} {\\texttt ls -al} {\\texttt /etc/passwd}\\href{linuxfr.fr}{http://linux-france.org}\\begin{lstlisting}[language=C ]
void main (void) {
printf("Hello World.\\n");
}\\end{lstlisting}
\\includegraphics[scale=0.5]{logo.eps}\\includegraphics[scale=1]{schema.eps}
\\captionof{figure}{Schéma d'interconnexion}\\begin{tabular}{|c|c|}
\\hline
col1&col2 \\\\ \\hline
col3&col4 \\\\ \\hline
\\end{tabular}\\begin{eqnarray}
E = MC^2
\\end{eqnarray}
{\\texttt [ Energie = Masse * Célérité au carré ]}
Un réseau \\gls{IP} est ...
Les technologies \\gls{IP} ...\\begin{mybox}{Note}
un encadré pour evidencier des trucs
\\end{mybox}

\\begin{mybox}{Exercise} \\label{Écrivez un script qui imprime la table de multiplication de 1 à 10}
Écrivez un script qui imprime la table de multiplication de 1 à 10\\end{mybox}
""";
expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('slide');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme")..add("module");
      txtVis.acceptSlide(list.first,buffer: resBuf);
      expect(list.length,4);


      result = "\\chapter{page with slides}\n\\begin{itemize}\n\\item something\n\\item \\begin{itemize}\n\\item item of sublist\n\\end{itemize}\n\n\\end{itemize}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('page');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme")..add("module");
      txtVis.acceptPage(list.first,buffer: resBuf);
      expect(list.length,3);
      result = """\\chapter{Page with all para elements}
\\section{section sans info}
\\emph{texte en évidence} {\\bfseries \\large un menu} {\\texttt ls -al} {\\texttt /etc/passwd}\\href{linuxfr.fr}{http://linux-france.org}\\begin{lstlisting}[language=C ]
void main (void) {
printf("Hello World.\\n");
}\\end{lstlisting}
\\includegraphics[scale=0.5]{logo.eps}\\includegraphics[scale=1]{schema.eps}
\\captionof{figure}{Schéma d'interconnexion}\\begin{tabular}{|c|c|}
\\hline
col1&col2 \\\\ \\hline
col3&col4 \\\\ \\hline
\\end{tabular}\\begin{eqnarray}
E = MC^2
\\end{eqnarray}
{\\texttt [ Energie = Masse * Célérité au carré ]}
Un réseau \\gls{IP} est ...
Les technologies \\gls{IP} ...\\begin{mybox}{Note}
un encadré pour evidencier des trucs
\\end{mybox}

\\begin{mybox}{Exercise} \\label{Écrivez un script qui imprime la table de multiplication de 1 à 10}
Écrivez un script qui imprime la table de multiplication de 1 à 10\\end{mybox}
""";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('objectives');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptObjectives(list.first,buffer: resBuf);
      expect(list.length,1);
      result = "\\subsection*{}\n\\begin{itemize}\n\\item Objectif 1\n\\item Objectif 2\n\\end{itemize}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('info');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack.add("formation");
      txtVis.acceptInfo(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """
\\documentclass[a4paper,12pt]{scrbook}
\\usepackage{babel}[fr]
\\usepackage[most]{tcolorbox}
\\usepackage{tikz}
\\usepackage{fontawesome}
\\usepackage[font=small,labelfont=bf]{caption} 
\\usepackage{graphicx}
\\usepackage{epstopdf}
\\usepackage{hyperref}
\\usepackage{listings}
<GLOSSARY>

\\definecolor{myblue}{RGB}{20, 70, 180}
\\newtcolorbox{mybox}[3][Note]{
    colback=myblue!5!white,
    colframe=myblue,
    fonttitle=\\bfseries,
    title=#2,
    sharp corners,
    rounded corners=southeast, 
    attach boxed title to top left={xshift=5mm, yshift=-\\tcboxedtitleheight/2, yshifttext=-1mm},
    boxed title style={size=small, colback=myblue, sharp corners=north, boxrule=0.5mm},
    overlay={
         \\IfFileExists{#3}{
            \\node[anchor=north east, inner sep=0pt] at (frame.north east) {\\includegraphics[height=0.5cm]{#3}};
        }{}
    },
}
    \\subject{Une référence}
 \\title{Le titre}
\\subtitle{Une brève description
}
\\author{Auteur du texte}
\\date{2001-08-09}
\\begin{document}
\\maketitle
\\chapter*{\\centering \\begin{normalsize}Abstract\\end{normalsize}}
  \\begin{quotation};
  
  \\begin{itemize}
\\item Objectif 1
\\item Objectif 2
\\end{itemize}
  \\end{quotation}
  \\clearpage""";
      expect(resBuf.toString().trim(),result);


      list = parser.document!.findAllElements('module');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme");
      txtVis.acceptModule(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """
\\part{Module}
\\chapter{Page with all para elements}
\\section{section sans info}
\\emph{texte en évidence} {\\bfseries \\large un menu} {\\texttt ls -al} {\\texttt /etc/passwd}\\href{linuxfr.fr}{http://linux-france.org}\\begin{lstlisting}[language=C ]
void main (void) {
printf("Hello World.\\n");
}\\end{lstlisting}
\\includegraphics[scale=0.5]{logo.eps}\\includegraphics[scale=1]{schema.eps}
\\captionof{figure}{Schéma d'interconnexion}\\begin{tabular}{|c|c|}
\\hline
col1&col2 \\\\ \\hline
col3&col4 \\\\ \\hline
\\end{tabular}\\begin{eqnarray}
E = MC^2
\\end{eqnarray}
{\\texttt [ Energie = Masse * Célérité au carré ]}
Un réseau \\gls{IP} est ...
Les technologies \\gls{IP} ...\\begin{mybox}{Note}
un encadré pour evidencier des trucs
\\end{mybox}

\\begin{mybox}{Exercise} \\label{Écrivez un script qui imprime la table de multiplication de 1 à 10}
Écrivez un script qui imprime la table de multiplication de 1 à 10\\end{mybox}
\\chapter{Page with glossary stuff}
\\section{Para with glossary stuff}
Ceci est du texte normal,\\emph{du texte en évidence} ,
            une URL\\href{http://linux-france.org}{http://linux-france.org}, etc.
Un autre \\gls{TE} est ...
            Les mots \\gls{TE} ...
\\subsection{subsection lvl1}
empty
\\paragraph{subsection lvl2}
empty
\\paragraph{subsection lvl3}
empty
\\section{2nd top level section}
empty
\\chapter{page with slides this title shouldn\'t show}
\\section{page with slides}
\\begin{itemize}
\\item something
\\item \\begin{itemize}
\\item item of sublist
\\end{itemize}

\\end{itemize}
\\section{Les caractëres spéciaux}
\\subsection{listing caractëres spéciaux}
Les entités pour les caractères spéciaux

                    Un certain nombre de caractères ne sont pas accessibles au clavier ou sont réservés en XML, pour pallier cela, certaines entités ont été définies.
\\begin{itemize}
\\item ipso factum
\\item \\&nbsp; : l'espace insécable ;
\\item \\&tir; : le tiret d'intervalle '?';
\\item " : le caractère '”' ;
\\item \\& : le caractère '\\&' ;
\\item < : le caractère pluspetitque ;
\\item > : le caractère plusgrandque ;
\\item \\&OElig; : le caractère OE ligaturé (?) ;
\\item \\&oelig; : le caractère oe ligaturé (?) ;
\\item \\&reg; : le caractère '©' ;
\\item \\&euro; : le caractère pour l'euro (?).
\\end{itemize}

\\begin{mybox}{Exercise} \\label{combien font 2 plus 2 ?
}
combien font 2 plus 2 ?
\\end{mybox}
\\section{Answers}
\\subsection{Solution \\ref{Écrivez un script qui imprime la table de multiplication de 1 à 10}}
\\includegraphics[scale=1]{images/exo-tablemult.pl.1.eps}

\\subsection{Solution \\ref{combien font 2 plus 2 ?
}}
4

""" ;
      expect(resBuf.toString(),result);

    // list = parser.document!.findAllElements('slideshow');
    // //print("got back list: ${list.length} and $list");
    // resBuf.clear();
    // txtVis.acceptSlideShow(list.first,buffer: resBuf);
    // expect(list.length,2);
    // result = "\\gls{Internet Protocol}";
    // expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('theme');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack.add("formation");
      txtVis.acceptTheme(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """
\\title{Titre du diaporama}
\\part{Module}
\\chapter{Page with all para elements}
\\section{section sans info}
\\emph{texte en évidence} {\\bfseries \\large un menu} {\\texttt ls -al} {\\texttt /etc/passwd}\\href{linuxfr.fr}{http://linux-france.org}\\begin{lstlisting}[language=C ]
void main (void) {
printf("Hello World.\\n");
}\\end{lstlisting}
\\includegraphics[scale=0.5]{logo.eps}\\includegraphics[scale=1]{schema.eps}
\\captionof{figure}{Schéma d'interconnexion}\\begin{tabular}{|c|c|}
\\hline
col1&col2 \\\\ \\hline
col3&col4 \\\\ \\hline
\\end{tabular}\\begin{eqnarray}
E = MC^2
\\end{eqnarray}
{\\texttt [ Energie = Masse * Célérité au carré ]}
Un réseau \\gls{IP} est ...
Les technologies \\gls{IP} ...
\\begin{mybox}{Exercise} \\label{Écrivez un script qui imprime la table de multiplication de 1 à 10}
Écrivez un script qui imprime la table de multiplication de 1 à 10\\end{mybox}
\\chapter{Page with glossary stuff}
\\section{Para with glossary stuff}
Ceci est du texte normal,\\emph{du texte en évidence} ,
            une URL\\href{http://linux-france.org}{http://linux-france.org}, etc.
Un réseau \\gls{IP} est ...
            Les technologies \\gls{IP} ...
\\chapter{}
\\begin{itemize}
\\item something
\\item \\begin{itemize}
\\item item of sublist
\\end{itemize}

\\end{itemize}
\\section{Les caractëres spéciaux}
\\subsection{listing caractëres spéciaux}
Les entités pour les caractères spéciaux

                    Un certain nombre de caractères ne sont pas accessibles au clavier ou sont réservés en XML, pour pallier cela, certaines entités ont été définies.
\\begin{itemize}
\\item ipso factum
\\item \\&nbsp; : l'espace insécable ;
\\item \\&tir; : le tiret d'intervalle '?';
\\item " : le caractère '”' ;
\\item \\& : le caractère '&' ;
\\item < : le caractère pluspetitque ;
\\item > : le caractère plusgrandque ;
\\item \\&OElig; : le caractère OE ligaturé (?) ;
\\item \\&oelig; : le caractère oe ligaturé (?) ;
\\item \\&reg; : le caractère '©' ;
\\item \\&euro; : le caractère pour l'euro (?).
\\end{itemize}

\\begin{mybox}{Exercise} \\label{combien font 2 plus 2 ?
}
combien font 2 plus 2 ?
\\end{mybox}
\\section{Answers}
\\subsection{Solution \\ref{Écrivez un script qui imprime la table de multiplication de 1 à 10}}
\\includegraphics[scale=1]{images/exo-tablemult.pl.1.eps}

\\subsection{Solution \\ref{combien font 2 plus 2 ?
}}
4

\\chapter{Titre du diaporama}

\\chapter{(première diapo)}
\\chapter{(deuxième diapo)}
\\chapter{(Nièmediapo)}
""" ;
      //TODO implement slideshow expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('formation');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptFormation(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """
\\documentclass[a4paper,12pt]{scrbook}
\\usepackage{babel}[fr]
\\usepackage[most]{tcolorbox}
\\usepackage{tikz}
\\usepackage{fontawesome}
\\usepackage[font=small,labelfont=bf]{caption} 
\\usepackage{graphicx}
\\usepackage{epstopdf}
\\usepackage{hyperref}
\\usepackage{listings}
\\usepackage{glossaries}
\\input{glossaire.tex}
\\makeglossaries


\\definecolor{myblue}{RGB}{20, 70, 180}
\\newtcolorbox{mybox}[3][Note]{
    colback=myblue!5!white,
    colframe=myblue,
    fonttitle=\\bfseries,
    title=#2,
    sharp corners,
    rounded corners=southeast, 
    attach boxed title to top left={xshift=5mm, yshift=-\\tcboxedtitleheight/2, yshifttext=-1mm},
    boxed title style={size=small, colback=myblue, sharp corners=north, boxrule=0.5mm},
    overlay={
         \\IfFileExists{#3}{
            \\node[anchor=north east, inner sep=0pt] at (frame.north east) {\\includegraphics[height=0.5cm]{#3}};
        }{}
    },
}
    \\subject{Une référence}
 \\title{Le titre}
\\subtitle{Une brève description
}
\\author{Auteur du texte}
\\date{2001-08-09}
\\begin{document}
\\maketitle
\\chapter*{\\centering \\begin{normalsize}Abstract\\end{normalsize}}
  \\begin{quotation};
  
  \\begin{itemize}
\\item Objectif 1
\\item Objectif 2
\\item Objectif 1
\\item Objectif 2
\\end{itemize}
  \\end{quotation}
  \\clearpage
  
  \\part{Module}
\\chapter{Page with all para elements}
\\section{section sans info}
\\emph{texte en évidence} {\\bfseries \\large un menu} {\\texttt ls -al} {\\texttt /etc/passwd}\\href{linuxfr.fr}{http://linux-france.org}\\begin{lstlisting}[language=C ]
void main (void) {
printf("Hello World.\\n");
}\\end{lstlisting}
\\includegraphics[scale=0.5]{logo.eps}\\includegraphics[scale=1]{schema.eps}
\\captionof{figure}{Schéma d'interconnexion}\\begin{tabular}{|c|c|}
\\hline
col1&col2 \\\\ \\hline
col3&col4 \\\\ \\hline
\\end{tabular}\\begin{eqnarray}
E = MC^2
\\end{eqnarray}
{\\texttt [ Energie = Masse * Célérité au carré ]}
Un réseau \\gls{IP} est ...
Les technologies \\gls{IP} ...\\begin{mybox}{Note}
un encadré pour evidencier des trucs
\\end{mybox}

\\begin{mybox}{Exercise} \\label{Écrivez un script qui imprime la table de multiplication de 1 à 10}
Écrivez un script qui imprime la table de multiplication de 1 à 10\\end{mybox}
\\chapter{Page with glossary stuff}
\\section{Para with glossary stuff}
Ceci est du texte normal,\\emph{du texte en évidence} ,
            une URL\\href{http://linux-france.org}{http://linux-france.org}, etc.
Un autre \\gls{TE} est ...
            Les mots \\gls{TE} ...
\\subsection{subsection lvl1}
empty
\\paragraph{subsection lvl2}
empty
\\paragraph{subsection lvl3}
empty
\\section{2nd top level section}
empty
\\chapter{page with slides this title shouldn\'t show}
\\section{page with slides}
\\begin{itemize}
\\item something
\\item \\begin{itemize}
\\item item of sublist
\\end{itemize}

\\end{itemize}
\\section{Les caractëres spéciaux}
\\subsection{listing caractëres spéciaux}
Les entités pour les caractères spéciaux

                    Un certain nombre de caractères ne sont pas accessibles au clavier ou sont réservés en XML, pour pallier cela, certaines entités ont été définies.
\\begin{itemize}
\\item ipso factum
\\item \\&nbsp; : l'espace insécable ;
\\item \\&tir; : le tiret d'intervalle '?';
\\item " : le caractère '”' ;
\\item \\& : le caractère '\\&' ;
\\item < : le caractère pluspetitque ;
\\item > : le caractère plusgrandque ;
\\item \\&OElig; : le caractère OE ligaturé (?) ;
\\item \\&oelig; : le caractère oe ligaturé (?) ;
\\item \\&reg; : le caractère '©' ;
\\item \\&euro; : le caractère pour l'euro (?).
\\end{itemize}

\\begin{mybox}{Exercise} \\label{combien font 2 plus 2 ?
}
combien font 2 plus 2 ?
\\end{mybox}
\\section{Answers}
\\subsection{Solution \\ref{Écrivez un script qui imprime la table de multiplication de 1 à 10}}
\\includegraphics[scale=1]{images/exo-tablemult.pl.1.eps}

\\subsection{Solution \\ref{combien font 2 plus 2 ?
}}
4

\\chapter{Titre du diaporama}
\\section{(première diapo)}
\\section{(deuxième diapo)}
\\section{(Nièmediapo)}
\\tableofcontents
\\listoffigures
\\listoftables
\\end{document}
""";
      expect(resBuf.toString(),result);
    });
    test('slide parsing',()
    {

      parser.loadXml(fname, outdir: outdir);
      VisitorSlideGen txtVis = VisitorSlideGen();
      XmlElement? root = parser.document?.getElement("formation");
      StringBuffer resBuf = StringBuffer();
      //print("PREPARATION OF visitor: $root");
      //if(root != null) FormationChecker(root,txtVis);
      //parser.parse(fname, outdir: outdir);
      var list = parser.document!.findAllElements('text');
      expect(list.length,0);
      String result = "\\emph{texte en évidence}";
      //txtVis.acceptEm(list.first,buffer: resBuf);
      //expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('em');
      expect(list.length,2);
      result = "\\emph{texte en évidence} ";
      txtVis.acceptEm(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('title');
      expect(list.length,19);
      result = "Le titre";
      resBuf.clear();
      txtVis.acceptTitle(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('version');
      expect(list.length,3);
      result = "Auteur du texte2001-08-09";
      resBuf.clear();
      txtVis.acceptVersion(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('proofreaders');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptProofreaders(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('subtitle');
      expect(list.length,1);
      txtVis.clearAll();
      txtVis.stack.add("formation");
      result = "sous titre du Module";
      resBuf.clear();
      txtVis.acceptSubTitle(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('ratio');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptRatio(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('ref');
      expect(list.length,5);
      //result = "une référence à un élément nécessaire";
      result = "";
      resBuf.clear();
      txtVis.acceptRef(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('author');
      expect(list.length,3);
      result = "Auteur du texte";
      resBuf.clear();
      txtVis.acceptAuthor(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('email');
      expect(list.length,3);
      //result = "mon_email@mondomaine.tld ";
      result = "";
      resBuf.clear();
      txtVis.acceptEmail(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('comment');
      expect(list.length,3);
      //result = "Un commentaire de mise à jour";
      result = "";
      resBuf.clear();
      txtVis.acceptComment(list.last,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('date');
      expect(list.length,3);
      result = "2001-08-09";
      resBuf.clear();
      txtVis.acceptDate(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('level');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptLevel(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('legend');
      expect(list.length,1);
      result = "Schéma d'interconnexion";
      resBuf.clear();
      txtVis.acceptLegend(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('duration');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptDuration(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);


      list = parser.document!.findAllElements('prerequisite');
      expect(list.length,1);
      result = "";
      resBuf.clear();
      txtVis.acceptPrerequisite(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('menu');
      expect(list.length,1);
      result = "{\\bfseries \\large un menu} ";
      resBuf.clear();
      txtVis.acceptMenu(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('cmd');
      expect(list.length,1);
      result = "{\\texttt ls -al} ";
      resBuf.clear();
      txtVis.acceptCmd(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('file');
      expect(list.length,1);
      result = "{\\texttt /etc/passwd}";
      resBuf.clear();
      txtVis.acceptFile(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('url');
      expect(list.length,2);
      result = "\\href{linuxfr.fr}{http://linux-france.org}";
      resBuf.clear();
      txtVis.acceptUrl(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('code');
      expect(list.length,1);
      result = '\\begin{minted}{}\nvoid main (void) {\nprintf("Hello World.\\n");\n}\\end{minted}\n';
      result ='\\begin{lstlisting}[language=C ]\nvoid main (void) {\nprintf("Hello World.\\n");\n}\\end{lstlisting}\n';
      resBuf.clear();
      txtVis.acceptCode(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('image');
      expect(list.length,3);
      List<String> results =[
        "\\includegraphics[scale=0.5]{logo.eps}",
        "\\includegraphics[scale=1]{schema.eps}\n\\captionof{figure}{Schéma d'interconnexion}"
      ];
      resBuf.clear();
      txtVis.acceptImage(list.first,buffer: resBuf);
      expect(resBuf.toString(),results[0]);
      resBuf.clear();
      txtVis.acceptImage(list.elementAt(1),buffer: resBuf);
      expect(resBuf.toString(),results[1]);
      list = parser.document!.findAllElements('table');
      expect(list.length,1);
      result = "\\begin{tabular}{|c|c|}\n\\hline\ncol1&col2 \\\\ \\hline\ncol3&col4 \\\\ \\hline\n\\end{tabular}";
      resBuf.clear();
      txtVis.acceptTable(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      list = parser.document!.findAllElements('math');
      expect(list.length,2);
      result = "\\begin{eqnarray}\nE = MC^2\n\\end{eqnarray}\n";
      resBuf.clear();
      txtVis.acceptMath(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);
      result = "{\\texttt [ Energie = Masse * Célérité au carré ]}";
      resBuf.clear();
      txtVis.acceptMath(list.last,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('item');
      //print("got back list: ${list.length} and $list");
      expect(list.length,17);
      result = "\\item Objectif 1\n";
      resBuf.clear();
      txtVis.acceptItem(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('list');
      //print("got back list: ${list.length} and $list");
      //expect(list.length,2);
      result = "\\begin{itemize}\n\\item something\n\\item \\begin{itemize}\n\\item item of sublist\n\\end{itemize}\n\n\\end{itemize}\n";
      resBuf.clear();
      txtVis.acceptList(list.first,buffer: resBuf);
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('para');
      //print("got back list: ${list.length} and $list");
      expect(list.length,17);
      resBuf.clear();
      txtVis.acceptPara(list.first,buffer: resBuf);
      result = "Une brève description\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('glossary');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptGlossary(list.first,buffer: resBuf);
      expect(list.length,4);
      result = " \\gls{IP} ";
      expect(resBuf.toString(),result);
      result = "\\newglossaryentry{IP}\n{\n name=IP, description={Internet Protocol}\n}\n";
      expect(txtVis.glossary.toString(),result);

      list = parser.document!.findAllElements('description');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptDescription(list.first,buffer: resBuf);
      expect(list.length,3);
      result = "Une brève description\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('suggestion');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptSuggestion(list.first,buffer: resBuf);
      expect(list.length,1);
      result = "";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('dependency');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptDependency(list.first,buffer: resBuf);
      expect(list.length,1);
      result = "";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('question');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptQuestion(list.first,buffer: resBuf);
      expect(list.length,2);
      result = "Écrivez un script qui imprime la table de multiplication de 1 à 10";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('answer');
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptAnswer(list.first,buffer: resBuf);
      expect(list.length,2);
      result = "\\includegraphics[scale=1]{images/exo-tablemult.pl.1.eps}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('exercise');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptExercise(list.first,buffer: resBuf);
      expect(list.length,2);
      result = """\\begin{exampleblock}{Exercise}
Écrivez un script qui imprime la table de multiplication de 1 à 10
\\end{exampleblock}
""";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('note');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptNote(list.first,buffer: resBuf);
      expect(list.length,2);
      result = "\\begin{alertblock}{Note}\nun encadré pour evidencier des trucs\n\\end{alertblock}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('section');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme")..add("module")..add("page");
      txtVis.acceptSection(list.first,buffer: resBuf);
      expect(list.length,8);
      result = """\\item section sans info
\\begin{exampleblock}{Exercise}
Écrivez un script qui imprime la table de multiplication de 1 à 10
\\end{exampleblock}
""";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('slide');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme")..add("module");
      txtVis.acceptSlide(list.first,buffer: resBuf);
      expect(list.length,4);
      result = "{\n\\setbeamertemplate{background}\n{\n\\includegraphics[width=\\paperwidth,height=\\paperheight]{image.eps}\n}\n\\begin{frame}{page with slides}\n\\begin{itemize}\n\\item something\n\\item \\begin{itemize}\n\\item item of sublist\n\\end{itemize}\n\n\\end{itemize}\n\\end{frame}\n}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('page');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme")..add("module");
      txtVis.acceptPage(list.first,buffer: resBuf);
      expect(list.length,3);
      result = """\\begin{frame}{Page with all para elements}
\\begin{itemize}
\\item section sans info
\\begin{exampleblock}{Exercise}
Écrivez un script qui imprime la table de multiplication de 1 à 10
\\end{exampleblock}
\\end{itemize}
\\end{frame}
""";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('objectives');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.acceptObjectives(list.first,buffer: resBuf);
      expect(list.length,1);
      result = "\\subsection*{}\n\\begin{itemize}\n\\item Objectif 1\n\\item Objectif 2\n\\end{itemize}\n";
      expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('info');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack.add("formation");
      txtVis.acceptInfo(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """
\\documentclass{beamer}
\\usepackage[T1]{fontenc}
\\usepackage[francais]{babel}
\\usepackage{graphicx}
\\usepackage{epstopdf}
\\usepackage{hyperref}
\\usepackage[most]{tcolorbox}
\\usepackage{listings}

\\title{Le titre}
\\subtitle{Une brève description}
\\author{Auteur du texte}
\\date{2001-08-09}
\\begin{document}
\\begin{frame}
\\titlepage
\\end{frame}
\\begin{frame}{Outline}
\\tableofcontents
\\end{frame}
\\section{Abstract}
\\begin{frame}{Objectives}
\\begin{itemize}
\\item Objectif 1
\\item Objectif 2
\\end{itemize}
\\end{frame}""";
      expect(resBuf.toString().trim(),result);


      list = parser.document!.findAllElements('module');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack..add("formation")..add("theme");
      txtVis.acceptModule(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """\\begin{frame}{Page with all para elements}
\\begin{itemize}
\\item section sans info
\\begin{exampleblock}{Exercise}
Écrivez un script qui imprime la table de multiplication de 1 à 10
\\end{exampleblock}
\\end{itemize}
\\end{frame}
\\begin{frame}{Page with glossary stuff}
\\begin{itemize}
\\item Para with glossary stuff
\\item \\begin{itemize}
\\item subsection lvl1
\\item \\begin{itemize}
\\item subsection lvl2
\\item \\begin{itemize}
\\item subsection lvl3
\\end{itemize}
\\end{itemize}
\\end{itemize}
\\item 2nd top level section
\\end{itemize}
\\end{frame}
{
\\setbeamertemplate{background}
{
\\includegraphics[width=\\paperwidth,height=\\paperheight]{image.eps}
}
\\begin{frame}{page with slides}
\\begin{itemize}
\\item something
\\item \\begin{itemize}
\\item item of sublist
\\end{itemize}

\\end{itemize}
\\end{frame}
}\n""" ;
      expect(resBuf.toString(),result);

      // list = parser.document!.findAllElements('slideshow');
      // //print("got back list: ${list.length} and $list");
      // resBuf.clear();
      // txtVis.acceptSlideShow(list.first,buffer: resBuf);
      // expect(list.length,2);
      // result = "\\gls{Internet Protocol}";
      // expect(resBuf.toString(),result);

      list = parser.document!.findAllElements('theme');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.stack.add("formation");
      txtVis.acceptTheme(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """
\\title{Titre du diaporama}
\\part{Module}
\\chapter{Page with all para elements}
\\section{section sans info}
\\emph{texte en évidence} {\\bfseries \\large un menu} {\\texttt ls -al} {\\texttt /etc/passwd}\\href{linuxfr.fr}{http://linux-france.org}\\begin{lstlisting}[language=C ]
void main (void) {
printf("Hello World.\\n");
}\\end{lstlisting}
\\includegraphics[scale=0.5]{logo.eps}\\includegraphics[scale=1]{schema.eps}
\\captionof{figure}{Schéma d'interconnexion}\\begin{tabular}{|c|c|}
\\hline
col1&col2 \\\\ \\hline
col3&col4 \\\\ \\hline
\\end{tabular}\\begin{eqnarray}
E = MC^2
\\end{eqnarray}
{\\texttt [ Energie = Masse * Célérité au carré ]}
Un réseau \\gls{IP} est ...
Les technologies \\gls{IP} ...
\\begin{mybox}{Exercise} \\label{Écrivez un script qui imprime la table de multiplication de 1 à 10}
Écrivez un script qui imprime la table de multiplication de 1 à 10\\end{mybox}
\\chapter{Page with glossary stuff}
\\section{Para with glossary stuff}
Ceci est du texte normal,\\emph{du texte en évidence} ,
            une URL\\href{http://linux-france.org}{http://linux-france.org}, etc.
Un réseau \\gls{IP} est ...
            Les technologies \\gls{IP} ...
\\chapter{}
\\begin{itemize}
\\item something
\\item \\begin{itemize}
\\item item of sublist
\\end{itemize}

\\end{itemize}
\\section{Les caractëres spéciaux}
\\subsection{listing caractëres spéciaux}
Les entités pour les caractères spéciaux

                    Un certain nombre de caractères ne sont pas accessibles au clavier ou sont réservés en XML, pour pallier cela, certaines entités ont été définies.
\\begin{itemize}
\\item ipso factum
\\item \\&nbsp; : l'espace insécable ;
\\item \\&tir; : le tiret d'intervalle '?';
\\item " : le caractère '”' ;
\\item \\& : le caractère '&' ;
\\item < : le caractère pluspetitque ;
\\item > : le caractère plusgrandque ;
\\item \\&OElig; : le caractère OE ligaturé (?) ;
\\item \\&oelig; : le caractère oe ligaturé (?) ;
\\item \\&reg; : le caractère '©' ;
\\item \\&euro; : le caractère pour l'euro (?).
\\end{itemize}

\\begin{mybox}{Exercise} \\label{combien font 2 plus 2 ?
}
combien font 2 plus 2 ?
\\end{mybox}
\\section{Answers}
\\subsection{Solution \\ref{Écrivez un script qui imprime la table de multiplication de 1 à 10}}
\\includegraphics[scale=1]{images/exo-tablemult.pl.1.eps}

\\subsection{Solution \\ref{combien font 2 plus 2 ?
}}
4

\\chapter{Titre du diaporama}

\\chapter{(première diapo)}
\\chapter{(deuxième diapo)}
\\chapter{(Nièmediapo)}
""" ;
      list = parser.document!.findAllElements('formation');
      //print("got back list: ${list.length} and $list");
      resBuf.clear();
      txtVis.clearAll();
      txtVis.acceptFormation(list.first,buffer: resBuf);
      expect(list.length,1);
      result = """
\\documentclass{beamer}
\\usepackage[T1]{fontenc}
\\usepackage[francais]{babel}
\\usepackage{graphicx}
\\usepackage{epstopdf}
\\usepackage{hyperref}
\\usepackage[most]{tcolorbox}
\\usepackage{listings}

\\title{Le titre}
\\subtitle{Une brève description}
\\author{Auteur du texte}
\\date{2001-08-09}
\\begin{document}
\\begin{frame}
\\titlepage
\\end{frame}
\\begin{frame}{Outline}
\\tableofcontents
\\end{frame}
\\section{Abstract}
\\begin{frame}{Objectives}
\\begin{itemize}
\\item Objectif 1
\\item Objectif 2
\\item Objectif 1
\\item Objectif 2
\\end{itemize}
\\end{frame}
\\begin{frame}{Page with all para elements}
\\begin{itemize}
\\item section sans info
\\begin{exampleblock}{Exercise}
Écrivez un script qui imprime la table de multiplication de 1 à 10
\\end{exampleblock}
\\end{itemize}
\\end{frame}
\\begin{frame}{Page with glossary stuff}
\\begin{itemize}
\\item Para with glossary stuff
\\item \\begin{itemize}
\\item subsection lvl1
\\item \\begin{itemize}
\\item subsection lvl2
\\item \\begin{itemize}
\\item subsection lvl3
\\end{itemize}
\\end{itemize}
\\end{itemize}
\\item 2nd top level section
\\end{itemize}
\\end{frame}
{
\\setbeamertemplate{background}
{
\\includegraphics[width=\\paperwidth,height=\\paperheight]{image.eps}
}
\\begin{frame}{page with slides}
\\begin{itemize}
\\item something
\\item \\begin{itemize}
\\item item of sublist
\\end{itemize}

\\end{itemize}
\\end{frame}
}
\\begin{frame}{(première diapo)}
\\end{frame}
\\begin{frame}{(deuxième diapo)}
\\end{frame}
\\begin{frame}{(Nièmediapo)}
\\end{frame}
\\end{document}
""";
      expect(resBuf.toString(),result);
    }) ;
  });
}
