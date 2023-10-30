import 'dart:io';

import 'package:logidee_tools/visitor.dart';
import 'package:logidee_tools/visitor_check.dart';
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

  bool documentBegun = false;
  XmlDocument? document;

  VisitorCheck loadXml(String fname, {String outdir = "", bool verbose = false}) {
    VisitorCheck visit = VisitorCheck();
    dirname = path.dirname(fname);
    String outname = ((outdir.isNotEmpty) ? outdir : dirname) +
        path.separator +
        path.basenameWithoutExtension(fname);
    String slidename = outname + "_gen_slides.tex";
    String scriptname = outname + "_gen.tex";
    if (verbose) print("ouputname = $slidename $scriptname");
    if (dirname.isNotEmpty) dirname += path.separator;
    final file = File(fname);
    final slidefile = File(slidename);
    final scriptfile = File(scriptname);
    slidesink = slidefile.openWrite();
    //scriptsink = scriptfile.openWrite();

    try {
      document = XmlDocument.parse(file.readAsStringSync());
    } catch (e) {
      if (e is XmlException) {
        visit.errmsg = "parse error in  $fname : $e";
        print("parse error in  $fname : $e");
      } else {
        visit.errmsg = "couldn't open file $fname : $e";
        print(visit.errmsg);
      }
      visit.valid = false;
      return visit;
    }
    if (document == null) {
      visit.errmsg = "Well don't know why (there should have been previous errors) but the parsing of $fname failed....";
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
      visit.errmsg = "something bad happened.... $e";
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
  bool buildTexScript(String fname, {String outdir = "", bool verbose = false}) {
    if (document == null) {
      print("invocation of buildTexScript  impossible, document is null...");
      return false;
    }
    dirname = path.dirname(fname);
    String outname = ((outdir.isNotEmpty) ? outdir : dirname) +
        path.separator +
        path.basenameWithoutExtension(fname);
    String scriptname = outname + "_gen.tex";
    if (verbose) print("ouputname = $scriptname");
    if (dirname.isNotEmpty) dirname += path.separator;
    final file = File(fname);
    final scriptfile = File(scriptname);
    //scriptsink = scriptfile.openWrite();
    if(parsevalid)
    {
      VisitorTexgen txtVis = VisitorTexgen();
      XmlElement? root = document?.getElement("formation");
      //print("PREPARATION OF visitor: $root");
      if(root != null) FormationChecker(root,txtVis);
      //print("visitor produced : ${txtVis.content}");
      scriptfile.writeAsStringSync(txtVis.content.toString());
      print("written script file $scriptname");
    }
    return parsevalid;
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

  void processNode(XmlNode node) {
    if (node is XmlAttribute) {
      print("found attribute :${node.value}");
    } else if (node is XmlCDATA) {
      print("found CDATA :${node.value}");
    } else if (node is XmlComment) {
      //print("found comment :${node.text}");
    } else if (node is XmlDeclaration) {
      print("found Declaration :${node.value}");
    } else if (node is XmlDoctype) {
      print("found Doctype :${node.value}");
    } else if (node is XmlDocument) {
      print("found Document :${node.value}");
    } else if (node is XmlDocumentFragment) {
      print("found DocumentFragment :${node.value}");
    } else if (node is XmlElement) {
      processElement(node);
    } else if (node is XmlProcessing) {
      print("found XmlProcessing :${node.value}");
    } else if (node is XmlText) {
      processTxt(node);
    } else {
      print(
          "found unknown node t:${node.nodeType} txt:${node.value} txt:${node.innerText}");
      parsevalid = false;
    }
  }

  void processElement(XmlElement node) {
    switch (node.name.toString()) {
      case "shortinfo":
      case "info":
        processInfo(node);
        break;
      default:
        print("found XmlElement :${node.name} ");
        for (var element in node.attributes) {
          print("att: $element");
        }
    }
  }

  void processTxt(XmlText node) {
    //ignore empty nodes
    if (node.value.trim().isNotEmpty) print("found XmlText : '${node.value}'");
  }

  void processInfo(XmlElement node) {}

  /*
   * or \begin{titlepage}
      \vspace*{\stretch{1}}
      \begin{center}
      {\huge\bfseries Thesis \\[1ex]
      title}                  \\[6.5ex]
      {\large\bfseries Author name}           \\
      \vspace{4ex}
      Thesis  submitted to                    \\[5pt]
      \textit{University name}                \\[2cm]
      in partial fulfilment for the award of the degree of \\[2cm]
      \textsc{\Large Doctor of Philosophy}    \\[2ex]
      \textsc{\large Mathematics}             \\[12ex]
      \vfill
      Department of Mathematics               \\
      Address                                 \\
      \vfill
      \today
      \end{center}
      \vspace{\stretch{2}}
      \end{titlepage}
   */

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


  void writeslide(String txt) {
    if (txt.contains(r'_')) txt = txt.replaceAll(r'_', r'\_');
    slidesink.write(txt);
  }

  void writescript(String txt, {bool onlyfilled = false}) {
    if (txt.contains(r'_')) txt = txt.replaceAll(r'_', r'\_');
    if (txt == 'null') print("some fucker added null....");
    print("WARNING writescript ATM inactivated writing to file '$txt'");
    //if (onlyfilled && txt.trim().isNotEmpty)
    //  scriptsink.write(txt);
    //else if (!onlyfilled) scriptsink.write(txt);
  }
}
