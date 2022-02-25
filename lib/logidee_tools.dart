import 'package:xml/xml.dart';
//import 'dart:html';
import 'dart:io';
import 'package:path/path.dart' as path;

class LogideeTools
{
  String dirname = "";
  String lang = "";
  String theme = "";
  late IOSink slidesink;
  late IOSink scriptsink;

  bool documentBegun = false;
  void parse(String fname)
  {
    dirname = path.dirname(fname);
    String outname = dirname+path.separator+path.basenameWithoutExtension(fname);
    String slidename = outname+"_gen_slides.tex";
    String scriptname = outname+"_gen.tex";
    print("ouputname = $slidename $scriptname");
    if(dirname.isNotEmpty)dirname += path.separator;
    final file= File(fname);
    final slidefile= File(slidename);
    final scriptfile= File(scriptname);
    slidesink=  slidefile.openWrite();
    scriptsink=scriptfile.openWrite();

    slidesink.write('\\documentclass{beamer}\n' );
    scriptsink.write('\\documentclass[a4paper,12pt]{book}\n' );
    scriptsink.write('\\usepackage{graphicx}\n' );
    scriptsink.write('\\usepackage{epstopdf}\n' );
    scriptsink.write('\\usepackage{html}\n' );
    slidesink.write('\\usepackage{html}\n' );
    final document = XmlDocument.parse(file.readAsStringSync());

    for (var element in document.attributes) { print("root node att : $element");}
    //print("parsed doc = $document");
    document.findAllElements('xi:include').forEach((toInc) =>processInclude(toInc));

    bool ignore = true;
    for (var node in document.children) {
      if (ignore)
      {
        if(node is XmlDeclaration ) {
          lang = node.getAttribute("lang") ?? "";
          lang = (lang == "de")? "german": (lang=="fr")? "french":"";
          if(lang.isNotEmpty)
          {
            slidesink.write('\\usepackage{babel}[$lang]\n' );
            scriptsink.write('\\usepackage{babel}[$lang]\n' );
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
          parseFormation(node);
        } else if(node is XmlText && node.toString().trim().isEmpty) {}
        else {
          print("tag formation expected, don't know how to handle ${node.runtimeType} $node");
        }
      }
      //processNode(node);
    }

    slidesink.write("\\end{document}\n");
    slidesink.close();
    scriptsink.write("\\tableofcontents\n");
    scriptsink.write("\\listoffigures        % Liste des figures\n");
    scriptsink.write("\\listoftables        % Liste des tableaux\n");
    scriptsink.write("\\end{document}\n");
    scriptsink.close();
  }
/// replace recursively the xi:include by the file given in the href
  void processInclude(XmlElement toInc) {
    String href = (toInc.getAttribute("href")!= null)?toInc.getAttribute("href")!:"";
    if(href.isNotEmpty)
    {
      final file= File(dirname+href);
      var inclusion = XmlDocument.parse(file.readAsStringSync());
      inclusion.findAllElements('xi:include').forEach((toInc) =>processInclude(toInc));
      List<XmlElement> list = [];
      for (var p0 in inclusion.children) { if(p0 is XmlElement) list.add(p0);}
      if(list.length > 1) print("Error!!! $href contains more than one element!!");
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
    }
    
    
  }

  void processElement(XmlElement node) {
    switch(node.name.toString()){
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
  void parseFormation(XmlElement formation)
  {

    //remove empty stuff
    cleanList(formation.children);

    for (var node in formation.children) {
    if(node is XmlElement && node.name.toString() == "info") {
      //if(formation.children.length >2)
        parseInfo(node);
    }
    else if(node is XmlElement && node.name.toString() == "theme") {
      //if(formation.children.length >2)
      parseTheme(node);
    }
    else {
      if(node is XmlElement) {
        print("parsing formation unknwon elemebnt ${node.name}");
      } else {
        print("parsing formation unknwon  ${node.runtimeType}");
      }
    }
    }
    //var info = node.getElement("info");
  }
  void parseTheme(XmlElement theme)
  {
    //remove empty stuff
    cleanList(theme.children);

    for (var node in theme.children) {
      if(node is XmlElement && node.name.toString() == "info") {
        parseInfo(node);
      } else if(node is XmlElement && node.name.toString() == "module") {
        parseModule(node);
      } else {
        if(node is XmlElement) {
          print("parsing formation unknwon elemebnt ${node.name}");
        } else {
          print("parsing formation unknwon  ${node.runtimeType}");
        }
      }
    }
    //var info = node.getElement("info");
  }
  void parseModule(XmlElement module)
  {
    //remove empty stuff
    cleanList(module.children);

    for (var node in module.children) {
      if(node is XmlElement && node.name.toString() == "info") {
        parseInfo(node, level: 1);
      } else if(node is XmlElement && node.name.toString() == "page") {
        parsePage(node);
      } else {
        if(node is XmlElement) {
          print("parsing formation unknwon elemebnt ${node.name}");
        } else {
          print("parsing formation unknwon  ${node.runtimeType}");
        }
      }
    }
    //var info = node.getElement("info");
  }

  void cleanList(List<XmlNode> nodes) {
    //remove empty stuff
    var toRemove = [];
    for (var node in nodes) {
      if(node is XmlText && node.toString().trim().isEmpty) {
        toRemove.add(node);
      } else if(node is XmlComment) {
        toRemove.add(node);
      }
    }
       nodes.removeWhere((element) => toRemove.contains(element));
  }

  void parseInfo(XmlElement? info, {int level  =0}) {
    String title = info?.getElement("title")?.text??"";
    var version = info?.getElement("version");
    String date =version?.getAttribute("number")??"";
    String author = version?.getElement("author")?.text??"";
    String desc = info?.getElement("description")?.text??"";
    String type = (level <= 0)? "part":(level == 1)? "chapter":"section";

    if(!documentBegun) {
      if (title.isNotEmpty) scriptsink.write("\\title{$title}\n");
      if (date.isNotEmpty) scriptsink.write("\\date{$date}\n");
      if (author.isNotEmpty) scriptsink.write("\\author{$author}\n");

      scriptsink.write("\\begin{document}\n");
      scriptsink.write("\\maketitle\n");


      slidesink.write(
          "\\usetheme{$theme}\n"); // % Berlin, Darmstadt, Goettingen, Hannover, Singapore
      slidesink.write("\\title{$title}\n");
      slidesink.write("\\subtitle{$desc}\n");
      slidesink.write("\\author{$author}\n");
      slidesink.write("\\institute{Beamer Slides}\n");
      slidesink.write("\\date{$date}\n");
      //% Image Logo\n");
      if(File("logo.png").existsSync()) {
        slidesink.write(
          "\\logo{\\includegraphics[width=2.5cm,height=2.5cm]{logo.png}}\n");
      }
      slidesink.write("\\begin{document}\n");
      slidesink.write("\\begin{frame}\n");
      //% Print the title page as the first slide\n");
      slidesink.write("\\titlepage\n");
      slidesink.write("\\end{frame}\n");
      //% Presentation outline\n");
      slidesink.write("\\begin{frame}{Outline}\n");
      slidesink.write("\\tableofcontents\n");
      slidesink.write("\\end{frame}\n");
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
                     print("$item is no an Exmelement??");
                   }
                  }
                desc += "\\end{itemize}\n";

              }
          }
        scriptsink.write("\\$type{$title}\n");
        if(desc.isNotEmpty){
          scriptsink.write("\\begin{abstract}\n\\begin{quote}\n$desc\n\\end{abstract}\n\\end{quote}\n");



        }



        slidesink.write("\\begin{frame}\n");
        slidesink.write("\\Large{$title}\n");
        slidesink.write("$desc\n");
        slidesink.write("\\end{frame}\n");
      }
    documentBegun = true;
  }

  void parsePage(XmlElement page) {
    //remove empty stuff
    cleanList(page.children);

    bool startFrame = false;
    String title = "";
    for (var node in page.children) {
      if(node is XmlElement && node.name.toString() == "title") {
        title = parseTitle(node);
        scriptsink.write("\\section{$title}\n");

        //\includegraphics[width=1\linewidth]{image without extension}
        //slidesink.write("${desc}\n");
      } else if(node is XmlElement && node.name.toString() == "section") {
        slidesink.write("\\begin{frame}\n");
        slidesink.write("\\Large{$title}\n");
        startFrame = true;
        parseSection(node, level : 0);
      } else if(node is XmlElement && node.name.toString() == "slide") {
        parseSlide(node);
      } else {
        if(node is XmlElement) {
          print("parsing page unknwon elemebnt ${node.name}");
        } else {
          print("parsing page unknwon  ${node.runtimeType}");
        }
      }
    }
    if(startFrame) slidesink.write("\\end{frame}\n");
  }

  String parseTitle(XmlElement node) {
    return node.text;
  }

  void parseSection(XmlElement section, {int level  = 0, bool silent = false}) {
    String divider = (level == 0)? "section":(level == 1)? "subsection":(level == 2)? "subsubsection":(level == 3)? "paragraph": "subparagraph";
    cleanList(section.children);
    for (var node in section.children) {
      if(node is XmlElement && node.name.toString() == "title") {
        String title = parseTitle(node);
        //print("need to parse section ${node.text}");
        scriptsink.write("\\$divider{$title}\n");
        if(silent) {
          slidesink.write("\\item $title\n");
        } else {
          slidesink.write("$title\n");
        }
      }
      else if(node is XmlElement && node.name.toString() == "section") {
        parseSection(node, level : level+1, silent : silent);
      } else if(node is XmlElement && node.name.toString() == "para") {
        parsePara(node, silent : silent);
      } else if(node is XmlElement && node.name.toString() == "slide") {
        parseSlide(node);
      } else {
        if(node is XmlElement) {
          print("parsing section unknwon elemebnt ${node.name}");
        } else {
          print("parsing section unknwon  ${node.runtimeType}");
        }
      }
    }
  }

  void parseSlide(XmlElement slide) {

    slidesink.write("\\begin{frame}\n");
    cleanList(slide.children);
    //print("need to parse slide ${slide.text}");
    for (var node in slide.children) {
      if(node is XmlElement && node.name.toString() == "title") {
        String title = parseTitle(node);
        slidesink.write("\\Large{$title}\n");
      }
      else if(node is XmlElement && node.name.toString() == "section") {
        parseSection(node, silent : true);
      } else if(node is XmlElement && node.name.toString() == "para") {
        parsePara(node, silent : true);
      } else {
        if(node is XmlElement) {
          print("parsing slide unknwon elemebnt ${node.name}");
        } else {
          print("parsing slide unknwon  ${node.runtimeType}");
        }
      }
    }
    slidesink.write("\\end{frame}\n");
  }

  void parsePara(XmlElement paragraph, {bool silent = false}) {
    cleanList(paragraph.children);
    var toReplace = {};
    for (var node in paragraph.children) {
      if(node is XmlText) {
        parseText(node);
      } else if(node is XmlElement && node.name.toString() == "url") {
        String href = node.getAttribute("href") ?? "";
        String name = node.getAttribute("name") ?? "";
        if(name.isEmpty) name = href;
        if(href.isNotEmpty)
        {
          String urlref ="\\htmladdnormallink{$name}{$href}";
          XmlNode txtNode = XmlText(urlref);
          toReplace[node] = txtNode;
          //To create a link to another place in your own document
          //\htmlref{text to have highlighted}{Label_name}magg
        }
        else {
          print("failed parsing paragraph url $href $name ");
        }
      }
      else if(node is XmlElement && node.name.toString() == "image") {
        String src = node.getAttribute("src") ?? "";
        bool visible =  ((node.getAttribute("visible")??"true") == "true")? true: false;
        if(visible) {
          String urlref ="\\includegraphics[scale=1]{$src}";
          XmlNode txtNode = XmlText(urlref);
          toReplace[node] = txtNode;
        }
        else {
          print("rejected image $node");
        }
      }
      else if(node is XmlElement && node.name.toString() == "list")
        {
         //print("found list $node") ;
         String urlref ="\\begin{itemize}\n";
         cleanList(node.children);
         for (var p0 in node.children) { urlref += "\\item ${p0.text} ";}
         urlref +="\\end{itemize}\n";
         XmlNode txtNode = XmlText(urlref);
         toReplace[node] = txtNode;
        }
      else if(node is XmlElement && node.name.toString() == "cmd")
      {
        cleanList(node.children);
        String urlref ="{\\tt ";
        for (var p0 in node.children) { urlref += p0.text+"\n";}
        urlref +="} ";
        XmlNode txtNode = XmlText(urlref);
        toReplace[node] = txtNode;
      }
      else if(node is XmlElement && node.name.toString() == "menu")
      {
        cleanList(node.children);
        String urlref ="{\\bfseries\large  ";
        for (var p0 in node.children) { urlref += p0.text+"\n";}
        urlref +="} ";
        XmlNode txtNode = XmlText(urlref);
        toReplace[node] = txtNode;
      }
      else if(node is XmlElement && node.name.toString() == "code")
      {
        cleanList(node.children);
        String urlref ="\\begin{code}\n";
        for (var p0 in node.children) { urlref += p0.text+" ";}
        urlref +="\\end{code}\n";
        XmlNode txtNode = XmlText(urlref);
        toReplace[node] = txtNode;
      }
      else if(node is XmlElement) {
        print("parsing paragraph unknwon elemebnt ${node.name}");
      } else {
        print("parsing paragraph unknwon  ${node.runtimeType}");
      }
    }

    for (var node in toReplace.keys) {
      node.replace(toReplace[node]);
      //print("swapped ${node} with ${toReplace[node]}");
    }
    scriptsink.write("${paragraph.text}\n\n");
  }

  void parseText(XmlText txtnode)
  {
    if(txtnode.children.isEmpty) {
      scriptsink.write("${txtnode.text}\n\n");
    } else {
      print("txt : ${txtnode.children.length} ${txtnode.text}");
    }
    for (var node in txtnode.children) {
      //if(node is XmlText) parseText(node);
      //else
        if(node is XmlElement) {
          print("parsing txt unknwon elemebnt ${node.name}");
        } else {
          print("parsing txt unknwon  ${node.runtimeType}");
        }
    }

  }
}