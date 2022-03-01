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
      print("got back list: ${list.length} and $list");
      list = parser.document!.findAllElements('menu');
      expect(list.length,1);
      result = "{\\bfseries \\large  Fichier } ";
      print("got back list: ${list.length} and $list");
      expect(parser.parseMenu(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('cmd');
      expect(list.length,1);
      result = "{\\tt ls -al } ";
      print("got back list: ${list.length} and $list");
      expect(parser.parseCmd(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('file');
      expect(list.length,1);
      result = "{\\tt /etc/passwd } ";
      print("got back list: ${list.length} and $list");
      expect(parser.parseFile(list.first, nowrite: true, verbose: true),result);
      //   <page>
      // <url href="http://linux-france.org"/>
      expect(true,true);
    });
  });
}