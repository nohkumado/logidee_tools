import 'package:logidee_tools/visitor.dart';
import 'package:logidee_tools/visitor_check.dart';
import 'package:xml/src/xml/utils/node_list.dart';
import 'package:xml/xml.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'logidee_checker.dart';

class LogideeTools
{
  String dirname = "";
  String lang = "";
  String theme = "";
  late IOSink slidesink;
  late IOSink scriptsink;
  bool parsevalid= true;

  bool documentBegun = false;
  XmlDocument? document;
  String errmsg = "";

  bool loadXml(String fname, {String outdir = "", bool verbose = false})
  {
    errmsg = "";
    dirname = path.dirname(fname);
    String outname = ((outdir.isNotEmpty)? outdir: dirname)+path.separator+path.basenameWithoutExtension(fname);
    String slidename = outname+"_gen_slides.tex";
    String scriptname = outname+"_gen.tex";
    if(verbose)print("ouputname = $slidename $scriptname");
    if(dirname.isNotEmpty)dirname += path.separator;
    final file= File(fname);
    final slidefile= File(slidename);
    final scriptfile= File(scriptname);
    slidesink=  slidefile.openWrite();
    scriptsink=scriptfile.openWrite();

    document = XmlDocument.parse(file.readAsStringSync());

    //for (var element in document.attributes) { print("root node att : $element");}
    //print("parsed doc = $document");
    document!.findAllElements('xi:include').forEach((toInc) =>processInclude(toInc));
    if(document!.children.isNotEmpty)cleanList(document!.children, recursive: true);
    if(document != null)
      {
        Visitor visit =  VisitorCheck();
        LogideeChecker checker = new LogideeChecker(document!,visit);
      }
    else print("failed to load document....");

    if(verbose) print(errmsg);
    if(!parsevalid && verbose) print("Errors occurred, check the log");
    return parsevalid;
  }
  bool parse({bool verbose = false, bool nowrite: false})
  {
    errmsg = "";
    String scriptHeader ='''\\documentclass[a4paper,12pt]{book}
    \\usepackage{graphicx}
    \\usepackage{epstopdf}
    \\usepackage{html}
    \\usepackage{minted}
    \\usepackage[font=small,labelfont=bf]{caption} % Required for specifying captions to tables and figures
    ''' ;



    String slideHeader ='''\\documentclass{beamer}
    \\newcounter{paragraph}\n\\newcommand{\\paragraph} %otherwise html stop compilation
    \\usepackage{html}
    \\usepackage{minted}
    ''';

    if(!nowrite)
    {
      writeslide(slideHeader );
      writescript(scriptHeader );
    }
    else
    {
      errmsg += scriptHeader;
    }

    bool ignore = true;
    for (var node in document!.children) {
      if (ignore)
      {
        if(node is XmlDeclaration ) {
          lang = node.getAttribute("lang") ?? "";
          lang = (lang == "de")? "german": (lang=="fr")? "french":"";
          if(lang.isNotEmpty)
          {
            if(!nowrite) {
              writeslide('\\usepackage{babel}[$lang]\n');
              scriptsink.write('\\usepackage{babel}[$lang]\n');
            }
            else
            {
              errmsg += '\\usepackage{babel}[$lang]\n';
            }
          }
          theme = node.getAttribute("theme") ?? "default";
        }
        //print("ignoring ${node.runtimeType}");
        //node.attributes.forEach((element) {
        //  print("ignored node att: $element");
        //});
        if (node is XmlDoctype) ignore = false;
      }
      else {
        if(node is XmlElement && node.name.toString() == "formation") {
          errmsg += parseFormation(node, verbose: verbose, nowrite:nowrite);
        } else if(node is XmlText && node.toString().trim().isEmpty) {}
        else {
          errmsg += "tag formation expected, don't know how to handle ${node.runtimeType} $node\n";
          parsevalid = false;
        }
      }
    }

    String footer = '''
    \\tableofcontents
    \\listoffigures        % Liste des figures
    \\listoftables        % Liste des tableaux
    \\end{document}
    ''';
    if(!nowrite)
      {
        writeslide("\\end{document}\n");
        writescript(footer);
      }
    else errmsg += footer;

    slidesink.close();
    scriptsink.close();
    if(verbose) print(errmsg);
    if(!parsevalid && verbose) print("Errors occurred, check the log");
    return parsevalid;
  }
  /// replace recursively the xi:include by the file given in the href
  void processInclude(XmlElement toInc) {
    String href = (toInc.getAttribute("href")!= null)?toInc.getAttribute("href")!:"";
    if(href.isNotEmpty)
    {
      final file= File(dirname+href);
      if(!file.existsSync()) parsevalid = false;
      var inclusion = XmlDocument.parse(file.readAsStringSync());
      inclusion.findAllElements('xi:include').forEach((toInc) =>processInclude(toInc));
      List<XmlElement> list = [];
      for (var p0 in inclusion.children) { if(p0 is XmlElement) list.add(p0);}
      if(list.length > 1) {
        print("Error!!! $href contains more than one element!!");
        parsevalid = false;
      }
      if(list.isNotEmpty) {
        XmlElement replacement =list[0];
        if(replacement.hasParent) replacement.detachParent(replacement.parent!);
        toInc.replace(replacement);
      }
    }
  }

  void processNode(XmlNode node) {
    if (node is XmlAttribute) {
      print("found attribute :${node.text}");
    } else if (node is XmlCDATA) {
      print("found CDATA :${node.text}");
    } else if (node is XmlComment) {
      //print("found comment :${node.text}");
    } else if (node is XmlDeclaration) {
      print("found Declaration :${node.text}");
    } else if (node is XmlDoctype) {
      print("found Doctype :${node.text}");
    } else if (node is XmlDocument) {
      print("found Document :${node.text}");
    } else if (node is XmlDocumentFragment) {
      print("found DocumentFragment :${node.text}");
    } else if (node is XmlElement) {
      processElement(node);
    } else if (node is XmlProcessing) {
      print("found XmlProcessing :${node.text}");
    } else if (node is XmlText) {
      processTxt(node);
    } else {
      print(
          "found unknown node t:${node.nodeType} txt:${node.text} txt:${node
              .innerText}");
      parsevalid = false;
    }


  }

  void processElement(XmlElement node) {
    switch(node.name.toString()){
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
    if(node.text.trim().isNotEmpty) print("found XmlText : '${node.text}'");
  }

  void processInfo(XmlElement node)
  {

  }

  /**
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
  String parseFormation(XmlElement formation, {bool verbose  = false, bool nowrite = false})
  {
    String errmsg = "";
    //remove empty stuff

    for (var node in formation.children) {
      if(node is XmlElement && node.name.toString() == "info" ||node is XmlElement && node.name.toString() == "shortinfo") {
        //if(formation.children.length >2)
        errmsg += parseInfo(node, verbose: verbose);
      }
      else if(node is XmlElement && node.name.toString() == "theme") {
        //if(formation.children.length >2)
        errmsg += parseTheme(node, verbose: verbose, nowrite:nowrite);
      }
      else {
        if(node is XmlElement) {
          errmsg += "parsing formation unknown element ${node.name}\n";
        } else {
          errmsg = "parsing formation unknown  ${node.runtimeType}\n";
        }
      }
      parsevalid = false;
    }
    return errmsg;
  }
  //var info = node.getElement("info");
  String parseTheme(XmlElement theme, {bool verbose  = false, bool nowrite = false})
  {
    String errmsg = "";
    //remove empty stuff
    cleanList(theme.children);

    for (var node in theme.children) {
      if(node is XmlElement && node.name.toString() == "info" ||node is XmlElement && node.name.toString() == "shortinfo") {
        errmsg += parseInfo(node, verbose: verbose, nowrite: nowrite);
      } else if(node is XmlElement && node.name.toString() == "module") {
        errmsg += parseModule(node, verbose: verbose, nowrite: nowrite);
      } else if(node is XmlElement && node.name.toString() == "slideshow") {
        errmsg += parseSlideShow(node, verbose: verbose, nowrite: nowrite);
      }else {
        if(node is XmlElement) {
          errmsg += "parsing theme unknown element ${node.name}\n";
        } else {
          errmsg += "parsing theme unknown  ${node.runtimeType}\n";
        }
        parsevalid = false;
      }
    }
    //var info = node.getElement("info");
    return errmsg;
  }
  String parseModule(XmlElement module, {bool verbose  = false, bool nowrite = false})
  {
    String errmsg = "";
    //remove empty stuff
    cleanList(module.children);

    for (var node in module.children) {
      if(node is XmlElement && node.name.toString() == "info" ||node is XmlElement && node.name.toString() == "shortinfo") {
        errmsg += parseInfo(node, level: 1, verbose: verbose, nowrite: nowrite);
      } else if(node is XmlElement && node.name.toString() == "page") {
        errmsg += parsePage(node, verbose: verbose, nowrite: nowrite);
      } else {
        if(node is XmlElement) {
          errmsg = "parsing module unknown element ${node.name}\n";
        } else {
          errmsg = "parsing module unknown  ${node.runtimeType}\n";
        }
        parsevalid = false;
      }
    }
    //var info = node.getElement("info");
    return errmsg;
  }

  void cleanList(List<XmlNode> nodes, {bool verbose  = false, recursive = false}) {
    //remove empty stuff
    var toRemove = [];
    for (var node in nodes) {
      if(node is XmlText && node.toString().trim().isEmpty) {
        toRemove.add(node);
      } else if(node is XmlComment) {
        toRemove.add(node);
      }
    }
    try {
      nodes.removeWhere((element) => toRemove.contains(element));
    }
    catch(e)
    {
    }

    if(recursive)
      {
        for (var node in nodes) {
          cleanList(node.children, verbose: verbose, recursive: recursive);
      }
  }
  }

  String parseInfo(XmlElement? info, {int level  =0, bool verbose  = false, bool nowrite = false}) {
    String errmsg = "";
    String title = info?.getElement("title")?.text??"";
    var version = info?.getElement("version");
    String date =version?.getAttribute("number")??"";
    String author = version?.getElement("author")?.text??"";
    String desc = info?.getElement("description")?.text??"";
    String type = (level <= 0)? "part":(level == 1)? "chapter":"section";

    String script = "", slides="";


    if(!documentBegun) {
      if (title.isNotEmpty) script += "\\title{$title}\n";
      if (date.isNotEmpty) script +="\\date{$date}\n";
      if (author.isNotEmpty) script +="\\author{$author}\n";

      script += "\\begin{document}\n";
      script += "\\maketitle\n";


      slides += "\\usetheme{$theme}\n"; // % Berlin, Darmstadt, Goettingen, Hannover, Singapore
      slides += "\\title{$title}\n";
      slides += "\\subtitle{$desc}\n";
      slides += "\\author{$author}\n";
      slides += "\\institute{Beamer Slides}\n";
      slides += "\\date{$date}\n";
      //% Image Logo\n");
      if(File("logo.png").existsSync()) {
        slides +=
            "\\logo{\\includegraphics[width=2.5cm,height=2.5cm]{logo.png}}\n";
      }
      slides += "\\begin{document}\n";
      slides += "\\begin{frame}\n";
      //% Print the title page as the first slide\n");
      slides += "\\titlepage\n";
      slides += "\\end{frame}\n";
      //% Presentation outline\n");
      slides += "\\begin{frame}{Outline}\n";
      slides += "\\tableofcontents\n";
      slides += "\\end{frame}\n";
    }
    else
    {
      XmlElement? objectives = (info != null)? info.getElement("objectives"):null;
      if(objectives != null)
      {
        cleanList(objectives.children);
        if(objectives.children.isNotEmpty)
        {
          desc += "\\begin{itemize}\n";

          for(XmlNode item in objectives.children)
          {
            if(item is XmlElement) {
              desc += "\\item ${item.text}\n";
            } else {
              errmsg += "$item is no an Element??\n";
            }
          }
          desc += "\\end{itemize}\n";

        }
      }
      script += "\\$type{$title}\n";
      if(desc.isNotEmpty){
        script += "\\chapter*{\\centering \\begin{normalsize}Abstract\\end{normalsize}}\n\\begin{quotation}\n$desc\n\\end{quotation}\n\\clearpage\n";
        //replace in-existing abstract with :
      }



      slides += "\\begin{frame}\n";
      slides += "\\Large{$title}\n";
      slides += "$desc\n";
      slides += "\\end{frame}\n";
    }
    if(nowrite)
      {
        errmsg += script;
      }
    else
      {
        writescript(script);
        writeslide(slides);
      }
    documentBegun = true;
    return errmsg;
  }

  void writeslide(String txt) {
    if(txt.contains(r'_')) txt= txt.replaceAll(r'_', r'\_');
    slidesink.write(txt);
  }
  void writescript(String txt) {
    if(txt.contains(r'_')) txt= txt.replaceAll(r'_', r'\_');
    scriptsink.write(txt);
  }

  String parsePage(XmlElement page, {bool verbose  = false, bool nowrite = false}) {
    String errmsg = "";
    //remove empty stuff
    cleanList(page.children);

    int startFrame = 0;
    String title = "";
    for (var node in page.children) {
      if(node is XmlElement && node.name.toString() == "title") {
        title = parseTitle(node);
        writescript("\\section{$title}\n");

        //\includegraphics[width=1\linewidth]{image without extension}
        //writeslide("${desc}\n");
      } else if(node is XmlElement && node.name.toString() == "section") {
        writeslide("\\begin{frame}\n");
        writeslide("\\Large{$title}\n");
        startFrame++;
        errmsg += parseSection(node, level : 0);
      } else if(node is XmlElement && node.name.toString() == "slide") {
        errmsg += parseSlide(node);
      } else {
        if(node is XmlElement) {
          errmsg = "parsing page unknown element ${node.name}: $node\n";
        } else {
          errmsg = "parsing page unknown  ${node.runtimeType}: $node\n";
        }
        parsevalid = false;
      }
    }
    if(startFrame >0) {
      writeslide("\\end{frame}\n");
      startFrame--;
    }
    return errmsg;
  }

  String parseTitle(XmlElement node, {bool verbose  = false}) {
    return node.text;
  }

  String parseSection(XmlElement section, {int level  = 0, bool silent = false,bool verbose  = false, bool nowrite = false}) {
    String errmsg = "";
    String divider = (level == 0)? "section":(level == 1)? "subsection":(level == 2)? "subsubsection":(level == 3)? "paragraph": "subparagraph";
    cleanList(section.children);
    for (var node in section.children) {
      if(node is XmlElement && node.name.toString() == "title") {
        String title = parseTitle(node);
        //print("need to parse section ${node.text}");
        writescript("\\$divider{$title}\n");
        if(silent) {
          writeslide("\\item $title\n");
        } else {
          writeslide("$title\n");
        }
      }
      else if(node is XmlElement && node.name.toString() == "section") {
        errmsg += parseSection(node, level : level+1, silent : silent);
      } else if(node is XmlElement && node.name.toString() == "para") {
        errmsg += parsePara(node, silent : silent);
      } else if(node is XmlElement && node.name.toString() == "slide") {
        errmsg += parseSlide(node);
      } else {
        if(node is XmlElement) {
          errmsg += "parsing section unknown element ${node.name}\n";
        } else {
          errmsg += "parsing section unknown  ${node.runtimeType}\n";
        }
        parsevalid = false;
      }
    }
    return errmsg;
  }

  String parseSlide(XmlElement slide, {bool verbose  = false,bool nowrite  = false}) {
    String errmsg = "";

    writeslide("\\begin{frame}\n");
    cleanList(slide.children);
    //print("need to parse slide ${slide.text}");
    for (var node in slide.children) {
      if(node is XmlElement && node.name.toString() == "title") {
        String title = parseTitle(node);
        writeslide("\\Large{$title}\n");
      }
      else if(node is XmlElement && node.name.toString() == "section") {
        errmsg += parseSection(node, silent : true);
      } else if(node is XmlElement && node.name.toString() == "para") {
        errmsg += parsePara(node, silent : true);
      } else if(node is XmlElement && node.name.toString() == "subtitle") {
        writeslide("{\\bfseries ");
        errmsg += parsePara(node, silent : true);
        writeslide("}\n");
      } else {
        if(node is XmlElement) {
          errmsg += "parsing slide unknown element ${node.name} $node\n";
        } else {
          errmsg += "parsing slide unknown  ${node.runtimeType}\n";
        }
        parsevalid = false;
      }
    }
    writeslide("\\end{frame}\n");
    return errmsg;
  }

  String parsePara(XmlNode paragraph, {bool silent = false, bool nowrite = false, bool verbose =false}) {
    String errmsg = "";
    //String result = "";
    if(paragraph is XmlElement) cleanList(paragraph.children);
    var toReplace = {};
    for (var node in paragraph.children) {
      //print("parsepara child loop treating $node of ${node.runtimeType}");
      if(node is XmlText) {
        errmsg += parseText(node, nowrite: nowrite, verbose:verbose);
      } else if(node is XmlElement && node.name.toString() == "url") {
        errmsg += parseUrl(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      } else if(node is XmlElement && node.name.toString() == "image") {
        errmsg += parseImage(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      } else if(node is XmlElement && node.name.toString() == "list")
      {
        //print("parsepara calling parseList $node of ${node.runtimeType}");
        errmsg += parseList(node, nowrite: nowrite,verbose: verbose, toReplace: (!nowrite)? toReplace:null);
      }
      else if(node is XmlElement && node.name.toString() == "em") {
        errmsg += parseEm(node, nowrite: nowrite, verbose: verbose);
      } else if(node is XmlElement && node.name.toString() == "cmd") {
        errmsg += parseCmd(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      } else if(node is XmlElement && node.name.toString() == "menu") {
        errmsg += parseMenu(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      } else if(node is XmlElement && node.name.toString() == "file") {
        errmsg += parseFile(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      } else if(node is XmlElement && node.name.toString() == "code") {
        errmsg += parseCode(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      }
      else if(node is XmlElement && node.name.toString() == "table") {
        errmsg += parseTable(node, nowrite: nowrite, verbose: verbose);
      }
      else if(node is XmlElement && node.name.toString() == "math") {
        errmsg += parseMath(node, nowrite: nowrite, verbose: verbose);
      }
      else if(node is XmlElement) {
        errmsg += "parsing paragraph unknown element ${node.name}\n";
      } else {
        errmsg += "parsing paragraph unknown  ${node.runtimeType}\n";
      }
      parsevalid = false;
    }

    for (var node in toReplace.keys) {
      node.replace(toReplace[node]);
      //print("swapped ${node} with ${toReplace[node]}");
    }
    //sometimes there are no children but still text....
    if(errmsg.isEmpty)
      {
        if(nowrite) {
          errmsg += paragraph.text.trim();
        } else {
          writescript("${paragraph.text}\n\n");
        }
      }
    //print("parsepara return text $errmsg");
    return errmsg.trim();
  }

  String parseText(XmlText txtnode, {bool verbose  = false, bool nowrite = false})
  {
      //print("parse text with ver: $verbose now: $nowrite for ${txtnode.text}");
    String errmsg = "";
    if(txtnode.children.isEmpty) {
      if(nowrite) {
        errmsg += "${txtnode.text} ";
      } else {
        writescript("${txtnode.text}\n\n");
      }
    }
    else
    {
      errmsg += "txt : ${txtnode.children.length} ${txtnode.text}";
    }
    for (var node in txtnode.children) {
      //if(node is XmlText) parseText(node);
      //else
      if(node is XmlElement) {
        errmsg += "parsing txt unknown element ${node.name}\n";
      } else {
        errmsg += "parsing txt unknown  ${node.runtimeType}\n";
      }
      parsevalid = false;
    }

    //print("parseText returns $errmsg");
    return errmsg;
  }

  String parseEm(XmlElement emnode, {bool nowrite =false, bool verbose = false})
  {
    String result = "\\textbf{";
    String errmsg = (nowrite)?result:"";

    if(!nowrite)writescript(result);
    if(emnode.children.isNotEmpty)
    {
      for(var subnode in emnode.children) {
        errmsg += parsePara(subnode, nowrite:nowrite, verbose: verbose);
      }
    }
    if(!nowrite) {
      writescript("}");
    } else {
      errmsg +="}";
    }
    return errmsg;
  }

  String parseMenu(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    cleanList(node.children);
    String urlref ="{\\bfseries \\large  ";
    for (var p0 in node.children) { urlref += p0.text+" ";}
    urlref +="} ";
    XmlNode txtNode = XmlText(urlref);
    if(toReplace != null) {
      toReplace[node] = txtNode;
    } else if(nowrite) {
      return urlref;
    }
    return "";
  }

  String parseCmd(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    cleanList(node.children);
    String urlref ="{\\tt ";
    for (var p0 in node.children) { urlref += p0.text+" ";}
    urlref +="} ";
    XmlNode txtNode = XmlText(urlref);
    if(toReplace != null) {
      toReplace[node] = txtNode;
    } else if(nowrite) {
      return urlref;
    }
    return "";
  }

  String parseFile(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    cleanList(node.children);
    String urlref ="{\\tt ";
    for (var p0 in node.children) { urlref += p0.text+" ";}
    urlref +="} ";
    XmlNode txtNode = XmlText(urlref);
    if(toReplace != null) {
      toReplace[node] = txtNode;
    } else if(nowrite) {
      return urlref;
    }

    return "";
  }

  String parseUrl(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    String errmsg = "";
    String href = node.getAttribute("href") ?? "";
    String name = node.getAttribute("name") ?? "";
    if(name.isEmpty) name = href;
    if(href.isNotEmpty)
    {
      String urlref ="\\htmladdnormallink{$name}{$href}";
      //To create a link to another place in your own document
      //\htmlref{text to have highlighted}{Label_name}
      if(toReplace != null) {
        XmlNode txtNode = XmlText(urlref);
        toReplace[node] = txtNode;
      } else if(nowrite) {
        errmsg += urlref;
      }
    }
    else {
      errmsg += "failed parsing paragraph url $href $name \n";
      parsevalid = false;
    }
    return errmsg;
  }

  String parseCode(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace}) {
    String errmsg = "";
    cleanList(node.children);
    String proglang = node.getAttribute("lang") ?? "";
    String urlref ="\\begin{minted}{$proglang}\n";
    for (var p0 in node.children) { urlref += p0.text+"\n";}
    urlref +="\\end{minted}\n";
    if(toReplace != null) {
      XmlNode txtNode = XmlText(urlref);
      toReplace[node] = txtNode;
    } else if(nowrite) {
      errmsg += urlref;
    }
    return errmsg;
  }


  String parseImage(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    String errmsg = "";
    String src = node.getAttribute("src") ?? "";
    bool visible =  ((node.getAttribute("visible")??"true") == "true")? true: false;
    //String caption  ="";
    bool captionVisible = true;
    cleanList(node.children);

    if(visible) {
      String urlref ="\\includegraphics[scale=1]{$src}";
      if(node.children.isNotEmpty)
      {
        XmlNode capNode  = node.firstChild!;
        if(capNode is XmlElement)
        {
          if(capNode.name.toString() == 'legend')
          {
            captionVisible = ((capNode.getAttribute("visible")??"true") == "true")? true: false;
            if(captionVisible) {
              urlref +="\n\\captionof{figure}{"+parsePara(capNode,nowrite: nowrite,verbose: verbose).trim()+"}";
            }
          }
          else {
            errmsg+= "unknown figure : ${capNode.runtimeType} '${capNode.name}' $capNode\n";
          }
        }
        else
        {
          errmsg += "expected legend, don't know what to do with ${node.children.first.runtimeType} ${node.firstChild}";
          parsevalid = false;
        }
      }
      //\\captionof{figure}{Some here}
      if(toReplace != null) {
        XmlNode txtNode = XmlText(urlref);
        toReplace[node] = txtNode;
      } else if(nowrite) {
        errmsg += urlref;
      }
    }
    else {
      errmsg += "rejected image $node";
      parsevalid = false;
    }
    return errmsg;
  }
  ///TODO border is default atm
  String parseTable(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    String errmsg = "";
    cleanList(node.children);
    bool border = ((node.getAttribute("border")??"1") == "1")? true: false; //TODO do something with border
    int maxwidth = 0;
    List<List<String>> data = extractTable(node.children);
    for (var line in data) { if(line.length > maxwidth) maxwidth = line.length;}

    //print("got back table: $data");
    String result = "\\begin{tabular}{";
    for(int i = 0 ; i < maxwidth; i++)
    {
      result += "|c";
    }
    result += "|}\n";
    result += "\\hline\n";
    for (var line in data) {
      for(int x = 0; x<line.length; x++) {
        result += line[x] +((x<line.length-1)?"&":"");
      }
      result += " \\hline\n";
    }
    result += "\\end{tabular}";

//{|l|p{4cm}|}
    if(toReplace != null) {
      XmlNode txtNode = XmlText(result);
      toReplace[node] = txtNode;
    } else if(nowrite) {
      errmsg += result;
    }
    return errmsg;
  }

  List<List<String>> extractTable(XmlNodeList<XmlNode> rows)
  {
    List<List<String>> result = [];
    int line = 0;
    for(var oneRow in rows){
      result.add([]);
      if(oneRow is XmlElement && oneRow.name.toString() == "row")
      {
        cleanList(oneRow.children);
        for(var oneCell in oneRow.children){
          bool border = ((oneCell.getAttribute("border")??"0") == "1")? true: false;//do something ith border
          bool head = ((oneCell.getAttribute("head")??"0") == "1")? true: false;
          result[line].add(((head) ? "\\textbf{":"")+parsePara(oneCell, nowrite: true)+((head) ? "}":""));
        }
      }
      else {
        print("error need to look at ${oneRow.runtimeType} with $oneRow");
        parsevalid = false;
      }
      line++;
    }

    return result;
  }

  String parseMath(XmlElement mathnode, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    String errmsg = "";
    String notation = mathnode.getAttribute("notation")??"html";
    cleanList(mathnode.children);
    String result = (notation == "tex")?"\\begin{eqnarray}\n":"{\\tt ";
    for (var node in mathnode.children) {
      if(node is XmlCDATA)
      {
        if(notation == "html") {
          print("error!! math tex notation should contain only CDATA !");
          parsevalid = false;
        }
        result += node.text.trim()+"\n";
      }
      else if(node is XmlText)
      {
        if(notation == "tex") {
          print("error!! math html notation should contain only Text !");
          parsevalid = false;
        }
        result += node.text.trim()+"\n";
      }
      else
      {
        print("found  unexpected ${node.runtimeType} with $node");
        for (var element in node.attributes) {
          print("math sub node att: $element");
        }
      }

    }
    result += (notation == "tex")?"\\end{eqnarray}\n":"}";
//{|l|p{4cm}|}
    if(toReplace != null) {
      XmlNode txtNode = XmlText(result);
      toReplace[mathnode] = txtNode;
    } else if(nowrite) {
      errmsg += result.trim();
    }
    return errmsg;
  }

  String parseList(XmlElement listnode, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    String errmsg = "";
    if("${listnode.name}" != "list")
      {
        print("Error !! parseList called with ${listnode.name} for $listnode");
        return errmsg;
      }
    cleanList(listnode.children);
    String result = (listnode.children.isNotEmpty)?"\\begin{itemize}\n":"";
    for(var item in listnode.children)
    {
      //print("child of list : ${item.runtimeType} = $item");
      if(item is XmlElement && item.name.toString() == "item")
      {
        result += parseItem(item, nowrite:nowrite, verbose:verbose, toReplace:toReplace);
      }
      else {
        print("Error(list) ${listnode.name} expected XMlElement item, got node ${item.runtimeType} = $item");
        parsevalid = false;
      }
    }
    result += (listnode.children.isNotEmpty)?"\n\\end{itemize}\n":"";

    if(toReplace != null) {
      XmlNode txtNode = XmlText(result);
      toReplace[listnode] = txtNode;
    } else if(nowrite) {
      errmsg += result.trim();
    }
    return errmsg;
  }

  String parseItem(XmlElement item, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    String errmsg = "";
    if("${item.name}" != "item")
    {
      print("Error !! parseitem called with ${item.name} for $item");
      return errmsg;
    }
    String result = "\\item ";
    cleanList(item.children);
    for(var node in item.children)
    {
      if(node is XmlElement && node.name.toString() == "list") {
        result += "\n"+parseList(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace).trim();
      } else {
        result += parsePara(node, nowrite: true, verbose: verbose).trim();
      }
    }
    return result;
  }

  String parseGlossary(XmlElement emnode, {bool nowrite =false, bool verbose = false})
  {
    String result = "\\index{";
    String errmsg = (nowrite)?result:"";

    if(!nowrite)writescript(result);
    if(emnode.children.isNotEmpty)
    {
      for(var subnode in emnode.children) {
        errmsg += parsePara(subnode, nowrite:nowrite, verbose: verbose);
      }
    }
    if(!nowrite) {
      writescript("}");
    } else {
      errmsg +="}";
    }
    return errmsg;
  }

  String parseSlideShow(XmlElement slide, {bool verbose  = false,bool nowrite  = false})
    {
      String errmsg = "";
      for (var node in slide.children) {
        if(node is XmlElement && node.name.toString() == "info" ||node is XmlElement && node.name.toString() == "shortinfo") {
          errmsg += parseInfo(node, level: 1);
        } else if(node is XmlElement && node.name.toString() == "slide") {
          errmsg += parseSlide(node, verbose: verbose, nowrite: nowrite);
        } else {
          if(node is XmlElement) {
            errmsg = "parsing slideshow unknown element ${node.name}\n";
          } else {
            errmsg = "parsing slideshow unknown  ${node.runtimeType}\n";
          }
          parsevalid = false;
        }
      }
      //var info = node.getElement("info");
      return errmsg;
    }
}
