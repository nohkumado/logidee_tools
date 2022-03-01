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
  bool parsevalid= true;

  bool documentBegun = false;
  XmlDocument? document;

  bool parse(String fname, {String outdir = "", bool verbose = false})
  {
    String errmsg = "";
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

    writeslide('\\documentclass{beamer}\n' );
    writescript('\\documentclass[a4paper,12pt]{book}\n' );
    writescript('\\usepackage{graphicx}\n' );
    writescript('\\usepackage{epstopdf}\n' );
    writescript('\\usepackage{html}\n' );
    writescript('\\usepackage{minted}\n' );
    writeslide('\\newcounter{paragraph}\n\\newcommand{\\paragraph}\n');//otherwise html stop compilation
    writeslide('\\usepackage{html}\n' );
    writeslide('\\usepackage{minted}\n' );
    document = XmlDocument.parse(file.readAsStringSync());

    //for (var element in document.attributes) { print("root node att : $element");}
    //print("parsed doc = $document");
    document!.findAllElements('xi:include').forEach((toInc) =>processInclude(toInc));

    bool ignore = true;
    for (var node in document!.children) {
      if (ignore)
      {
        if(node is XmlDeclaration ) {
          lang = node.getAttribute("lang") ?? "";
          lang = (lang == "de")? "german": (lang=="fr")? "french":"";
          if(lang.isNotEmpty)
          {
            writeslide('\\usepackage{babel}[$lang]\n' );
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
          errmsg += parseFormation(node, verbose: verbose);
        } else if(node is XmlText && node.toString().trim().isEmpty) {}
        else {
          errmsg += "tag formation expected, don't know how to handle ${node.runtimeType} $node\n";
          parsevalid = false;
        }
      }
    }

    writeslide("\\end{document}\n");
    slidesink.close();
    writescript("\\tableofcontents\n");
    writescript("\\listoffigures        % Liste des figures\n");
    writescript("\\listoftables        % Liste des tableaux\n");
    writescript("\\end{document}\n");
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
  String parseFormation(XmlElement formation, {bool verbose : false})
  {
    String errmsg = "";
    //remove empty stuff
    cleanList(formation.children);

    for (var node in formation.children) {
      if(node is XmlElement && node.name.toString() == "info" ||node is XmlElement && node.name.toString() == "shortinfo") {
        //if(formation.children.length >2)
        parseInfo(node, verbose: verbose);
      }
      else if(node is XmlElement && node.name.toString() == "theme") {
        //if(formation.children.length >2)
        parseTheme(node, verbose: verbose);
      }
      else {
        if(node is XmlElement) errmsg += "parsing formation unknown element ${node.name}\n";
        else errmsg = "parsing formation unknown  ${node.runtimeType}\n";
      }
      parsevalid = false;
    }
    return errmsg;
  }
    //var info = node.getElement("info");
  String parseTheme(XmlElement theme, {bool verbose : false})
  {
    String errmsg = "";
    //remove empty stuff
    cleanList(theme.children);

    for (var node in theme.children) {
        if(node is XmlElement && node.name.toString() == "info" ||node is XmlElement && node.name.toString() == "shortinfo") {
        parseInfo(node);
      } else if(node is XmlElement && node.name.toString() == "module") {
        parseModule(node);
      } else {
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
  String parseModule(XmlElement module, {bool verbose : false})
  {
    String errmsg = "";
    //remove empty stuff
    cleanList(module.children);

    for (var node in module.children) {
        if(node is XmlElement && node.name.toString() == "info" ||node is XmlElement && node.name.toString() == "shortinfo") {
        parseInfo(node, level: 1);
      } else if(node is XmlElement && node.name.toString() == "page") {
        parsePage(node);
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

  void cleanList(List<XmlNode> nodes, {bool verbose : false}) {
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

  String parseInfo(XmlElement? info, {int level  =0, bool verbose : false}) {
    String errmsg = "";
    String title = info?.getElement("title")?.text??"";
    var version = info?.getElement("version");
    String date =version?.getAttribute("number")??"";
    String author = version?.getElement("author")?.text??"";
    String desc = info?.getElement("description")?.text??"";
    String type = (level <= 0)? "part":(level == 1)? "chapter":"section";

    if(!documentBegun) {
      if (title.isNotEmpty) writescript("\\title{$title}\n");
      if (date.isNotEmpty) writescript("\\date{$date}\n");
      if (author.isNotEmpty) writescript("\\author{$author}\n");

      writescript("\\begin{document}\n");
      writescript("\\maketitle\n");


      writeslide("\\usetheme{$theme}\n"); // % Berlin, Darmstadt, Goettingen, Hannover, Singapore
      writeslide("\\title{$title}\n");
      writeslide("\\subtitle{$desc}\n");
      writeslide("\\author{$author}\n");
      writeslide("\\institute{Beamer Slides}\n");
      writeslide("\\date{$date}\n");
      //% Image Logo\n");
      if(File("logo.png").existsSync()) {
        writeslide(
          "\\logo{\\includegraphics[width=2.5cm,height=2.5cm]{logo.png}}\n");
      }
      writeslide("\\begin{document}\n");
      writeslide("\\begin{frame}\n");
      //% Print the title page as the first slide\n");
      writeslide("\\titlepage\n");
      writeslide("\\end{frame}\n");
      //% Presentation outline\n");
      writeslide("\\begin{frame}{Outline}\n");
      writeslide("\\tableofcontents\n");
      writeslide("\\end{frame}\n");
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
        writescript("\\$type{$title}\n");
        if(desc.isNotEmpty){
          writescript("\\chapter*{\\centering \\begin{normalsize}Abstract\\end{normalsize}}\n\\begin{quotation}\n$desc\n\\end{quotation}\n\\clearpage\n");
          //replace in-existing abstract with :
        }



        writeslide("\\begin{frame}\n");
        writeslide("\\Large{$title}\n");
        writeslide("$desc\n");
        writeslide("\\end{frame}\n");
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

  String parsePage(XmlElement page, {bool verbose : false}) {
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
        parseSection(node, level : 0);
      } else if(node is XmlElement && node.name.toString() == "slide") {
        parseSlide(node);
      } else {
        if(node is XmlElement) {
          errmsg = "parsing page unknown element ${node.name}";
        } else {
          errmsg = "parsing page unknown  ${node.runtimeType}";
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

  String parseTitle(XmlElement node, {bool verbose : false}) {
    return node.text;
  }

  String parseSection(XmlElement section, {int level  = 0, bool silent = false,bool verbose : false}) {
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
        parseSection(node, level : level+1, silent : silent);
      } else if(node is XmlElement && node.name.toString() == "para") {
        parsePara(node, silent : silent);
      } else if(node is XmlElement && node.name.toString() == "slide") {
        parseSlide(node);
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

  String parseSlide(XmlElement slide, {bool verbose : false}) {
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
        parseSection(node, silent : true);
      } else if(node is XmlElement && node.name.toString() == "para") {
        parsePara(node, silent : true);
      } else if(node is XmlElement && node.name.toString() == "subtitle") {
        writeslide("{\\bfseries ");
        parsePara(node, silent : true);
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

  String parsePara(XmlNode paragraph, {bool silent = false, bool nowrite: false, bool verbose:false}) {
    String errmsg = "";
    String result = "";
    if(paragraph is XmlElement) cleanList(paragraph.children);
    var toReplace = {};
    for (var node in paragraph.children) {
      print("parsepara child loop treating $node of ${node.runtimeType}");
      if(node is XmlText) {
        parseText(node, nowrite: nowrite, verbose:verbose);
      }
      else if(node is XmlElement && node.name.toString() == "url")
      {
        errmsg += parseUrl(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      }
      else if(node is XmlElement && node.name.toString() == "image")
      {
        String src = node.getAttribute("src") ?? "";
        bool visible =  ((node.getAttribute("visible")??"true") == "true")? true: false;
        if(visible) {
          String urlref ="\\includegraphics[scale=1]{$src}";
          XmlNode txtNode = XmlText(urlref);
          toReplace[node] = txtNode;
        }
        else {
          errmsg += "rejected image $node";
          parsevalid = false;
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
      else if(node is XmlElement && node.name.toString() == "em")
        errmsg += parseEm(node, nowrite: nowrite, verbose: verbose);
      else if(node is XmlElement && node.name.toString() == "cmd")
        errmsg += parseCmd(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      else if(node is XmlElement && node.name.toString() == "menu")
        errmsg += parseMenu(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      else if(node is XmlElement && node.name.toString() == "file")
        errmsg += parseFile(node, nowrite: nowrite, verbose: verbose, toReplace: toReplace);
      else if(node is XmlElement && node.name.toString() == "code")
      {
        cleanList(node.children);
        String proglang = node.getAttribute("lang") ?? "";
        String urlref ="\\begin{minted}{$proglang}\n";
        for (var p0 in node.children) { urlref += p0.text+" ";}
        urlref +="\\end{minted}\n";
        XmlNode txtNode = XmlText(urlref);
        toReplace[node] = txtNode;
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
    if(nowrite) errmsg += "${paragraph.text}";
    else writescript("${paragraph.text}\n\n");
    return errmsg;
  }

  String parseText(XmlText txtnode, {bool verbose : false, bool nowrite: false})
  {
    print("parse text with ver: $verbose nowr: $nowrite for ${txtnode.text}");
    String errmsg = "";
    if(txtnode.children.isEmpty) {
      if(nowrite) errmsg += "${txtnode.text} ";
      else writescript("${txtnode.text}\n\n");
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

    return errmsg;
  }

  String parseEm(XmlElement emnode, {bool nowrite:false, bool verbose: false})
  {
    String result = "\\textbf{";
    String errmsg = (nowrite)?result:"";

    if(!nowrite)writescript("${result}");
    if(emnode.children.isNotEmpty)
    {
      for(var subnode in emnode.children) errmsg += parsePara(subnode, nowrite:nowrite, verbose: verbose);
    }
    if(!nowrite)writescript("}");
    else errmsg +="}";
  return errmsg;
  }

  String parseMenu(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    cleanList(node.children);
    String urlref ="{\\bfseries \\large  ";
    for (var p0 in node.children) { urlref += p0.text+" ";}
    urlref +="} ";
    XmlNode txtNode = XmlText(urlref);
    if(toReplace != null) toReplace[node] = txtNode;
    else if(nowrite) return urlref;
    return "";
  }

  String parseCmd(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
  {
    cleanList(node.children);
    String urlref ="{\\tt ";
    for (var p0 in node.children) { urlref += p0.text+" ";}
    urlref +="} ";
    XmlNode txtNode = XmlText(urlref);
    if(toReplace != null) toReplace[node] = txtNode;
    else if(nowrite) return urlref;
    return "";
  }

  String parseFile(XmlElement node, {bool nowrite = false, bool verbose = false, Map? toReplace})
   {
     cleanList(node.children);
     String urlref ="{\\tt ";
     for (var p0 in node.children) { urlref += p0.text+" ";}
     urlref +="} ";
     XmlNode txtNode = XmlText(urlref);
     if(toReplace != null) toReplace[node] = txtNode;
     else if(nowrite) return urlref;

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
       } else if(nowrite) errmsg += urlref;
     }
     else {
       errmsg += "failed parsing paragraph url $href $name \n";
       parsevalid = false;
     }
     return errmsg;
   }

}