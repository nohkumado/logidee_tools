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
      expect(list.length,1);
      result = "\\htmladdnormallink{linuxfr.fr}{http://linux-france.org}";
      print("got back list: ${list.length} and $list");
      expect(parser.parseUrl(list.first, nowrite: true, verbose: true),result);
      //   <page>
      expect(true,true);
    });
  });
}