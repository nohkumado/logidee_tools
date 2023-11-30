import 'dart:io';

import 'package:logidee_tools/visitor_check.dart';
import 'package:logidee_tools/visitor_slidegen.dart';
import 'package:logidee_tools/visitor_texgen.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

import 'logidee_checker.dart';

class LogideeTools {
  String dirname = "";
  String lang = "";
  String theme = "";
  late IOSink slidesink;
  //late IOSink scriptsink;
  bool parsevalid = true;
  StringBuffer errors = new StringBuffer();

  bool documentBegun = false;
  XmlDocument? document;

  VisitorCheck loadXml(String fname, {String outdir = "", bool verbose = false}) {
    VisitorCheck visit = VisitorCheck();
    dirname = path.dirname(fname);
    if (dirname.isNotEmpty) dirname += path.separator;
    final file = File(fname);

    try {
      document = XmlDocument.parse(file.readAsStringSync());
    } catch (e) {
      if (e is XmlException) {
        visit.errmsg.write("parse error in  $fname : $e");
        print("parse error in  $fname : $e");
        errors.write(visit.errmsg);
      } else {
        visit.errmsg.write("couldn't open file $fname : $e");
        print(visit.errmsg);
        errors.write(visit.errmsg);
      }
      visit.valid = false;
      return visit;
    }
    if (document == null) {
      visit.errmsg.write("Well don't know why (there should have been previous errors) but the parsing of $fname failed....");
      print(visit.errmsg );
      visit.valid = false;
      return visit;
    }
    //for (var element in document.attributes) { print("root node att : $element");}
    //print("parsed doc = $document");
    try {
      document!
          .findAllElements('xi:include')
          .forEach((toInc) => processInclude(toInc));
    } catch (e) {
      visit.errmsg.write("something bad happened.... $e");
      print(visit.errmsg );
      visit.valid = false;
      return visit;
    }
    if (document!.children.isNotEmpty) {
      cleanList(document!.children, recursive: true);
    }
    LogideeChecker checker = LogideeChecker(document!, visit);
    parsevalid = checker.valid;
    if (!parsevalid && verbose) print("Errors occurred, check the log");
    return visit;
  }
  VisitorTexgen buildTexScript(String fname, {String outdir = "", bool verbose = false}) {
    VisitorTexgen txtVis = VisitorTexgen();
    if (document == null) {
      print("invocation of buildTexScript  impossible, document is null...");
      return txtVis;
    }
    dirname = path.dirname(fname);
    String outname = ((outdir.isNotEmpty) ? outdir : dirname) +
        path.separator +
        path.basenameWithoutExtension(fname);
    String scriptname = outname + "_gen.tex";
    if (verbose) print("ouputname = $scriptname");
    if (dirname.isNotEmpty) dirname += path.separator;
    final scriptfile = File(scriptname);
    //scriptsink = scriptfile.openWrite();
    if(parsevalid)
    {
      String charte = (Platform.environment["CHARTE"] ?? "default").trim();
      bool trainer = bool.parse(Platform.environment["TRAINER"]??"false");
      String selection = (Platform.environment["SELECTION"]??"all").trim();
      bool cycle = bool.parse(Platform.environment["CYCLE"]??"false");
      String lang = Platform.environment["LANG"]??"en";
      txtVis = VisitorTexgen(charte: charte, trainer: trainer, selection: selection, lang: lang);




     //list = parser.document!.findAllElements('formation');
     ////print("got back list: ${list.length} and $list");
     //txtVis.acceptFormation(list.first,buffer: resBuf);



      XmlElement? root = document?.getElement("formation");
      //print("PREPARATION OF visitor: $root\n\n");
      StringBuffer result = StringBuffer();
      //if(root != null) FormationChecker(root,txtVis, buffer: result);
      result.clear();
      txtVis.clearAll();
      if(root != null) txtVis.acceptFormation(root, buffer: result);
      //print("visitor produced : ${result}");
      if(txtVis.glossary.isNotEmpty)
      {
        String glosname ="${((outdir.isNotEmpty) ? outdir : dirname)}${path.separator}glossaire.tex";
        final glosfile = File(glosname);
        glosfile.writeAsStringSync(txtVis.glossary.toString());
      }
      //scriptfile.writeAsStringSync(txtVis.content.toString());
      scriptfile.writeAsStringSync(result.toString());
      print("written script file $scriptname");
      print("now run : pdflatex -shell-escape $scriptname");
    }
    else print("something went wrong creating $scriptname");
    return txtVis;
  }
  /// replace recursively the xi:include by the file given in the href
  void processInclude(XmlElement toInc) {
    String href =
        (toInc.getAttribute("href") != null) ? toInc.getAttribute("href")! : "";
    if (href.isNotEmpty) {
      final file = File(dirname + href);
      if (!file.existsSync()) parsevalid = false;
      var inclusion = XmlDocument.parse(file.readAsStringSync());
      inclusion
          .findAllElements('xi:include')
          .forEach((toInc) => processInclude(toInc));
      List<XmlElement> list = [];
      for (var p0 in inclusion.children) {
        if (p0 is XmlElement) list.add(p0);
      }
      if (list.length > 1) {
        print("Error!!! $href contains more than one element!!");
        parsevalid = false;
      }
      if (list.isNotEmpty) {
        XmlElement replacement = list[0];
        if (replacement.hasParent) {
          replacement.detachParent(replacement.parent!);
        }
        toInc.replace(replacement);
      }
    }
  }

  VisitorSlideGen buildTexSlides(String fname, {String outdir = "", bool verbose = false}) {
    VisitorSlideGen txtVis = VisitorSlideGen();
    if (document == null) {
      print("invocation of buildTexScript  impossible, document is null...");
      return txtVis;
    }


    dirname = path.dirname(fname);
    String outname = ((outdir.isNotEmpty) ? outdir : dirname) +
        path.separator +
        path.basenameWithoutExtension(fname);
    String scriptname = outname + "_gen_slides.tex";
    if (verbose) print("ouputname = $scriptname");
    if (dirname.isNotEmpty) dirname += path.separator;
    final file = File(fname);
    final scriptfile = File(scriptname);
    //scriptsink = scriptfile.openWrite();
    if(parsevalid)
    {
      String charte = Platform.environment["CHARTE"] ?? "default";
      bool trainer = bool.parse(Platform.environment["TRAINER"]??"false");
      String selection = Platform.environment["SELECTION"]??"all ";
      bool cycle = bool.parse(Platform.environment["CYCLE"]??"false");
      String lange = Platform.environment["LANG"]??"en";
      txtVis = VisitorSlideGen(charte: charte, trainer: trainer, selection: selection, lang: lang);
      XmlElement? root = document?.getElement("formation");
      //print("PREPARATION OF visitor: $root");
      if(root != null) FormationChecker(root,txtVis);
      //print("visitor produced : ${txtVis.content}");
      scriptfile.writeAsStringSync(txtVis.content.toString());
      print("written slide file $scriptname");
      print("now run : pdflatex -shell-escape $scriptname");
    }
    else print("something went wrong creating $scriptname");
    return txtVis;
  }

  void cleanList(List<XmlNode> nodes,
      {bool verbose = false, recursive = false}) {
    //remove empty stuff
    var toRemove = [];
    for (var node in nodes) {
      if (node is XmlText && node.toString().trim().isEmpty) {
        toRemove.add(node);
      } else if (node is XmlComment) {
        toRemove.add(node);
      }
    }
    try {
      nodes.removeWhere((element) => toRemove.contains(element));
    } catch (e) {}

    if (recursive) {
      for (var node in nodes) {
        cleanList(node.children, verbose: verbose, recursive: recursive);
      }
    }
  }

}
