import 'dart:io';
import 'package:logidee_tools/logidee_tools.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';


void main()
{
  late LogideeTools parser;
  late String fname;
  late String outdir;
  setUp(()
  {
    Directory current  = Directory.current;
    parser = LogideeTools();
    fname = "./assets/formation.xml";
    outdir = "/tmp";
  });
  group('validation',(){
    test('dtd validation',()
    {
      fname = "assets/formation_wrong.xml";
      expect(parser.parse(fname, outdir: outdir),false);
    });
  });
  group('xml parsing function',(){
    test('xml parsing',()
    {
      parser.parse(fname, outdir: outdir);
      var list = parser.document!.findAllElements('em');
      expect(list.length,1);
      String result = "\\textbf{texte en évidence}";
      expect(parser.parseEm(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('menu');
      expect(list.length,1);
      result = "{\\bfseries \\large  Fichier } ";
      expect(parser.parseMenu(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('cmd');
      expect(list.length,1);
      result = "{\\tt ls -al } ";
      expect(parser.parseCmd(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('file');
      expect(list.length,1);
      result = "{\\tt /etc/passwd } ";
      expect(parser.parseFile(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('url');
      expect(list.length,1);
      result = "\\htmladdnormallink{linuxfr.fr}{http://linux-france.org}";
      expect(parser.parseUrl(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('code');
      expect(list.length,1);
      result = '\\begin{minted}{}\n\n            ...\n            void main (void) {\n            printf("Hello World.\\n");\n            }\n        \n\\end{minted}\n';
      expect(parser.parseCode(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('image');
      expect(list.length,2);
      List<String> results =[
      "\\includegraphics[scale=1]{logo.eps}",
        "\\includegraphics[scale=1]{schema.eps}\n\\captionof{figure}{Schéma d'interconnexion}"
      ];
      expect(parser.parseImage(list.first, nowrite: true, verbose: true),results[0]);
      expect(parser.parseImage(list.last, nowrite: true, verbose: true),results[1]);
      list = parser.document!.findAllElements('table');
      expect(list.length,1);
      result = "\\begin{tabular}{|c|c|}\n\\hline\n\\textbf{ col1 }& col2  \\hline\n col3 & col4  \\hline\n\\end{tabular}";
      expect(parser.parseTable(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('math');
      print("got back math: ${list.length} and $list");
      expect(list.length,2);
      result = "\\begin{eqnarray}\n\$ E = MC^2 \$\n\\end{eqnarray}";
      expect(parser.parseMath(list.first, nowrite: true, verbose: true),result);
      result = "{\\tt [ Energie = Masse * Célérité au carré ]\n}";
      expect(parser.parseMath(list.last, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('list');
      print("got back list: ${list.length} and $list");
      expect(list.length,2);
      result = "\\begin{eqnarray}\n\$ E = MC^2 \$\n\\end{eqnarray}";
      expect(parser.parseList(list.first, nowrite: true, verbose: true),result);
      //   <formation>
      //   <theme>
      //   <module>
      //   <module>
      //   <page> page, section, exercise, para et note disposent d'un attribut <note restriction="debian">Tout ce qui est dit là est   spécifique à Debian.      </note>
      //exercise, para et note disposent d'un attribut icon
      //   <slide>, section,exercice
      //      -> section,para,note,exercice
      //           -> para,note,exercice
      //list
      //->list,item
      expect(true,true);
    });
  });
}