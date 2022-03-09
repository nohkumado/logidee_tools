import 'package:logidee_tools/logidee_tools.dart';
import 'package:logidee_tools/visitor_check.dart';
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
      expect(parser.loadXml(fname, outdir: outdir),false);
    });
  });
  group('xml parsing function',(){
    test('xml parsing',()
    {
      parser.loadXml(fname, outdir: outdir);
      //parser.parse(fname, outdir: outdir);
      var list = parser.document!.findAllElements('em');
      expect(list.length,2);
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
      expect(list.length,2);
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
      result = "\\begin{tabular}{|c|c|}\n\\hline\n\\textbf{col1}&col2 \\hline\ncol3&col4 \\hline\n\\end{tabular}";
      expect(parser.parseTable(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('math');
      expect(list.length,2);
      result = "\\begin{eqnarray}\n\$ E = MC^2 \$\n\\end{eqnarray}";
      expect(parser.parseMath(list.first, nowrite: true, verbose: true),result);
      result = "{\\tt [ Energie = Masse * Célérité au carré ]\n}";
      expect(parser.parseMath(list.last, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('list');
      //print("got back list: ${list.length} and $list");
      //expect(list.length,2);
      result = "\\begin{itemize}\n\\item something\n\\begin{itemize}\n\\item item of sublist\n\\end{itemize}\n\\end{itemize}";
      expect(parser.parseList(list.first, nowrite: true, verbose: true),result);
      list = parser.document!.findAllElements('glossary');
      //print("got back list: ${list.length} and $list");
      expect(list.length,2);
      result = "\\index{Internet Protocol}";
      expect(parser.parseGlossary(list.first, nowrite: true, verbose: true),result);



      //   <formation>
      //   <theme>
      //   <module>
      //   <module>
      //   <page> page, section, exercise, para et note disposent d'un attribut <note restriction="debian">Tout ce qui est dit là est   spécifique à Debian.      </note>
      //exercise, para et note disposent d'un attribut icon
      //   <slide>, section,exercice
      //      -> section,para,note,exercice
      //           -> para,note,exercice
    });
    test('xml structure test',()
    {
      VisitorCheck vis = VisitorCheck();
      bool valid = parser.loadXml(fname, outdir: outdir);
      //bool valid = parser.parse(fname, outdir: outdir, verbose:  true);
      if(!valid) print("Parsing had errors: ${parser.errmsg}");
      expect(valid,true);
      var list = parser.document!.findAllElements('formation');
      bool subvalid = true;
      //print("got back list: ${list.length} and $list");
      expect(list.length,1);
      XmlElement formation = list.first;
      late XmlElement node;
      for (var p0 in formation.children) {
        //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
        String value = (p0 is XmlElement)?p0.name.toString():"node";
        List<String> check = ["info","shortinfo","theme"];
        subvalid &= check.any((listElement) => listElement.contains(value));
     if(p0 is XmlElement && p0.name.toString() == "theme") node = p0;}
        expect(subvalid,true);
      subvalid = true;
      late XmlElement module, slideshow;
      for (var p0 in node.children) {
        //(p0 is XmlElement)? print("theme child: ${p0.name.toString()}"):print("theme unknown: $p0 of ${p0.runtimeType}");
        String value = (p0 is XmlElement)?p0.name.toString():"node";
        List<String> check = ["info","shortinfo","module", "slideshow"];
        subvalid &= check.any((listElement) => listElement.contains(value));
        if(p0 is XmlElement && p0.name.toString() == "module") module= p0;
        else if(p0 is XmlElement && p0.name.toString() == "slideshow") slideshow= p0;
      }
      expect(subvalid,true);
      subvalid = true;
      for (var p0 in module.children) {
        //(p0 is XmlElement)? print("module child: ${p0.name.toString()}"):print("module unknown: $p0 of ${p0.runtimeType}");
        String value = (p0 is XmlElement)?p0.name.toString():"node";
        List<String> check = ["info","shortinfo","page"];
        subvalid &= check.any((listElement) => listElement.contains(value));
        //if(p0 is XmlElement && p0.name.toString() == "module") module= p0;
      }
      expect(subvalid,true);

      subvalid = true;
      for (var p0 in slideshow.children) {
        (p0 is XmlElement)? print("slideshow child: ${p0.name}"):print("slideshow unknown: $p0 of ${p0.runtimeType}");
        String value = (p0 is XmlElement)?p0.name.toString():"node";
        List<String> check = ["info","shortinfo","slide"];
        if(!check.any((listElement) => listElement.contains(value))) print("slideshow $p0 ${value} not in ${check} failed");
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
}