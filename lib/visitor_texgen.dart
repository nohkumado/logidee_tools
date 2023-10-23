import 'dart:collection';

import 'package:logidee_tools/visitor_treetraversor.dart';
import 'package:xml/xml.dart';

class VisitorTexgen extends VisitorTreeTraversor {
  String content = "";
  Queue<String> stack = Queue();
  List<String> separators = const ["\\part", "\\chapter", "\\section","\\subsection","\\paragraph"];

  String abstract = "";

  List<String> desc = [];
  List<String> object = [];


  @override
  void acceptAnswer(XmlElement node, {bool verbose = false}) {
    print("accept amswer, should treat stuff??");
    super.acceptAnswer(node, verbose: verbose);
  }

  @override
  void acceptAuthor(XmlElement node, {bool verbose = false}) {
    int level = stack.length;
    if (level == 1) {
      content += "\\author{";
      super.acceptAuthor(node, verbose: verbose);
      content += "}\n";
    } else if (level == 2) {
      //ignored for now
    }
    else {
      print("accept author[$level], should treat stuff?? $object and $stack");
      super.acceptAuthor(node, verbose: verbose);
    }
  }

  @override
  void acceptCDATA(XmlCDATA cnode, {required bool verbose})
  {
    //print("CDATA : '${cnode.value}' ${cnode.innerText} ");
    content += cnode.value.trim()+"\n";
    super.acceptCDATA(cnode, verbose: verbose);
  }

  @override
  void acceptCmd(XmlElement node, {bool verbose = false}) {
    content += "{\\tt ";
    super.acceptCmd(node, verbose: verbose);
    content += "} ";
  }

  @override
  void acceptCode(XmlElement node, {bool verbose = false}) {
    String proglang = node.getAttribute("lang") ?? "";
    content  += "\\begin{minted}{$proglang}\n";
    super.acceptCode(node, verbose: verbose);
    content  += "\\end{minted}\n";
  }

  @override
  void acceptCol(XmlElement node, {bool verbose = false}) {
    super.acceptCol(node, verbose: verbose);
    content += "&";
  }

  @override
  void acceptComment(XmlElement node, {bool verbose = false}) {
    int level = stack.length;
    if (level == 1) {
      super.acceptComment(node, verbose: verbose);
    }
    else if (level == 2 && stack.last == "theme") {}
    else {
      print("accept Comment[$level], should treat stuff?? $stack");
      super.acceptComment(node, verbose: verbose);
    }
  }

  @override
  void acceptDate(XmlElement node, {bool verbose = false}) {
    int level = stack.length;
    if (level == 1) {
      content += "\\date{";
      super.acceptDate(node, verbose: verbose);
      content += "}\n";
    } else {
      print("accept date, should treat stuff??");
      super.acceptDate(node, verbose: verbose);
    }
  }

  @override
  void acceptDependency(XmlElement dependency, {bool verbose = false}) {
    //print("accept dependency, should treat stuff??");
    //super.acceptDependency(dependency, verbose: verbose);
  }

  @override
  void acceptDescription(XmlElement desc, {bool verbose = false}) {
    int level = stack.length;
    if (level == 1) {
      stack.add(desc.name.toString());
      super.acceptDescription(desc, verbose: verbose);
      String removed = stack.removeLast();
      if (removed != "description")
        print("AYEEEHH??? stack got back $removed instead of description??");
    } else if (level == 2) {
      //TODO ignored theme desc for now
    } else if (level == 3) {
      content += "\\section*{}\n";
      super.acceptDescription(desc, verbose: verbose);
    } else {
      print(
          "accept description[$level], should treat stuff??i $desc and $stack");
      super.acceptDescription(desc, verbose: verbose);
    }
  }

  @override
  void acceptDuration(XmlElement node, {bool verbose = false}) {
    super.acceptDuration(node, verbose: verbose);
  }

  @override
  void acceptEm(XmlElement node, {bool verbose = false}) {
    content += "\\emph{";
    super.acceptEm(node, verbose: verbose);
    content = content.trim();
    content += "} ";
  }

  @override
  void acceptEmail(XmlElement node, {bool verbose = false}) {
    print("accept email, should treat stuff??");
    super.acceptEmail(node, verbose: verbose);
  }

  @override
  void acceptExercice(XmlElement module, {bool verbose = false}) {
    print("accept exercice, should treat stuff??");
    super.acceptExercice(module, verbose: verbose);
  }

  @override
  void acceptFile(XmlElement node, {bool verbose = false}) {
    content +=
    "{\\tt ${node.children.map((child) => child.toString().trim()).where((
        child) => child.isNotEmpty).join(" ")}}";
    super.acceptFile(node, verbose: verbose);
  }

  @override
  acceptFormation(XmlElement formation, {bool verbose = false}) {
    stack.add("formation");
    super.acceptFormation(formation, verbose: verbose);
    String removed = stack.removeLast();
    if (removed != "formation")
      print("AYEEEHH??? stack got back $removed instead of formation??");
    content += "\\end{document}\n";
  }

  @override
  void acceptGlossary(XmlElement node, {bool verbose = false}) {
    print("accept glossary, should treat stuff??");
    super.acceptGlossary(node, verbose: verbose);
  }

  @override
  void acceptImage(XmlElement node, {bool verbose = false}) {
    String src = node.getAttribute("src") ?? "";
    String scale = node.getAttribute("scale") ?? "1";
    bool visible =
    ((node.getAttribute("visible") ?? "true") == "true") ? true : false;
    bool captionVisible = true;

    if (visible) {
      content += "\\includegraphics[scale=$scale]{$src}";
      if (node.children.isNotEmpty) {
        XmlNode capNode = node.firstChild!;
        if (capNode is XmlElement) {
          if (capNode.name.toString() == 'legend') {
            captionVisible =
            ((capNode.getAttribute("visible") ?? "true") == "true")
                ? true
                : false;
            if (captionVisible) {
              content += "\n\\captionof{figure}{";
              acceptPara(capNode, verbose: verbose);
              content += "}";
            }
          } else
            content +=
            "unknown figure : ${capNode.runtimeType} '${capNode
                .name}' $capNode\n";
        }
      }
    } else
      content +=
      "expected legend, don't know what to do with ${node.children.first
          .runtimeType} ${node.firstChild}";
    super.acceptImage(node, verbose: verbose);
  }
  //TODO probable need an acceptLegend for image!
  @override
  void acceptInfo(XmlElement info, {bool verbose = false}) {
    int level = stack.length;
    //print("==============called acceptInfo with $level $stack");
    //var version = info?.getElement("version");
    //String date = version?.getAttribute("number") ?? "";
    //String author = version?.getElement("author")?.value ?? "";
    //String desc = info?.getElement("description")?.value ?? "";
    //String type = (level <= 0)
    //    ? "part"
    //    : (level == 1)
    //    ? "chapter"
    //    : "section";

    //String script = "", slides = "";

    if (level == 1) {
      abstract =
      """\\chapter*{\\centering \\begin{normalsize}Abstract\\end{normalsize}}
  \\begin{quotation};
  <DESC>
  <OBJ>
  \\end{quotation}
  \\clearpage
  """;
      content += '''\\documentclass[a4paper,12pt]{book}
\\usepackage{babel}[$lang]
\\usepackage[most]{tcolorbox}
\\usepackage{tikz}
\\usepackage{fontawesome}
\\usepackage[font=small,labelfont=bf]{caption} 
\\usepackage{graphicx}
\\usepackage{epstopdf}
\\usepackage{hyperref}
\\usepackage{minted}

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
    ''';
      super.acceptInfo(info, verbose: verbose);

      content += "\\begin{document}\n";
      content += "\\maketitle\n";
      abstract = abstract.replaceAll("<DESC>", desc.join("\n"));
      // Convert the list into a TeX-formatted string
      String formattedObjectives = object.map((item) => "\\item $item").join(
          "\n");
      // Construct the final string with TeX formatting
      String itemized = "\\begin{itemize}\n$formattedObjectives\n\\end{itemize}";

      abstract = abstract.replaceAll("<OBJ>", itemized);
      content += abstract;
    } else if (level == 2) {
      print("TODO make a part page with the additional info $level");
      super.acceptInfo(info, verbose: verbose);
    } else if (level == 3) {
      super.acceptInfo(info, verbose: verbose);
    } else {
      print("don't know wjhat to do with info lvl $level");
      super.acceptInfo(info, verbose: verbose);
    }
  }

  @override
  void acceptItem(XmlElement node, {bool verbose = false}) {
    int level = stack.length;
    if (level == 2 && stack.last == "objectives") {
      super.acceptItem(node, verbose: verbose);
    }
    else if (level == 2 && stack.last == "theme") {}
    else {
      //print("accept Item[$level], should treat stuff?? $stack $node");
      content += "\\item ";
      super.acceptItem(node, verbose: verbose);
      content += "\n";
    }
  }

  @override
  void acceptLegend(XmlElement node, {bool verbose = false}) {
    print("accept Legend, should treat stuff??");
    super.acceptLegend(node, verbose: verbose);
  }

  @override
  void acceptLevel(XmlElement node, {bool verbose = false}) {
    int level = stack.length;
    if (level == 1) {
      super.acceptLevel(node, verbose: verbose);
    }
    else if (level == 2 && stack.last == "theme") {}
    else if (level == 3) {}
    else {
      print("accept Level[$level], should treat stuff?? $stack");
      super.acceptLevel(node, verbose: verbose);
    }
  }

  @override
  void acceptList(XmlElement node, {bool verbose = false}) {
    content += "\\begin{itemize}\n";
    super.acceptList(node, verbose: verbose);
    content += "\\end{itemize}\n";
  }

  @override
  void acceptMath(XmlElement mathnode, {bool verbose = false}) {
    String notation = mathnode.getAttribute("notation") ?? "html";
    content += (notation == "tex") ? "\\begin{eqnarray}\n" : "{\\tt ";
    super.acceptMath(mathnode, verbose: verbose);

    content += (notation == "tex") ? "\\end{eqnarray}\n" : "}";
  }

  @override
  void acceptMenu(XmlElement node, {bool verbose = false}) {
    content += "{\\bfseries \\large ";
    super.acceptMenu(node, verbose: verbose);
    content += "} ";
  }

  @override
  void acceptModule(XmlElement module, {bool verbose = false}) {
    stack.add("module");
    super.acceptModule(module, verbose: verbose);
    String removed = stack.removeLast();
    if (removed != "module")
      print("AYEEEHH??? stack got back $removed instead of module??");
  }

  @override
  void acceptNote(XmlElement module, {bool verbose = false}) {
    String restriction = module.getAttribute("restriction")??"";
    String icon = module.getAttribute("restriction")??"";
    bool trainer = ((module.getAttribute("trainer") ?? "0") == "1");

    print("accept Note, should treat stuff??");
    content += "\\begin{mybox}{Note}${(icon.isNotEmpty)?"{$icon}":""}\n";
    super.acceptNote(module, verbose: verbose);
    content += "\\end{mybox}\n";
  }

  @override
  void acceptObjectives(XmlElement object, {bool verbose = false}) {
    int level = stack.length;
    if (level == 1) {
      stack.add(object.name.toString());
      super.acceptObjectives(object, verbose: verbose);
      String removed = stack.removeLast();
      if (removed != "objectives")
        print("AYEEEHH??? stack got back $removed instead of objectives??");
    } else if (level == 2) {
      //ignored for now
    } else if (level == 3) {
      content += "\\subsection*{}\n\\begin{itemize}\n";
      super.acceptObjectives(object, verbose: verbose);
      content += "\\end{itemize}\n";
    } else {
      print(
          "accept Objective[$level], should treat stuff?? $object and $stack");
      super.acceptObjectives(object, verbose: verbose);
    }
  }

  @override
  void acceptPage(XmlElement module, {bool verbose = false}) {
    //print("accept Page, should treat stuff??");
    stack.add("page");
    //print("stack now $stack ${stack.length}");
    super.acceptPage(module, verbose: verbose);
    String removed = stack.removeLast();
    if (removed != "page")
      print("AYEEEHH??? stack got back $removed instead of page??");
  }

  @override
  void acceptPara(XmlElement node,
      {bool verbose = false, String tag = "Para"}) {
    //print("accept Para, should treat stuff??");
    super.acceptPara(node, verbose: verbose);
    content += "\n";
  }

  @override
  void acceptPrerequisite(XmlElement node, {bool verbose = false}) {
    //print("accept Prerequisites, should treat stuff??");
    //super.acceptPrerequisite(node, verbose: verbose);
  }

  @override
  void acceptProofreaders(XmlElement node, {bool verbose = false}) {
    //print("accept proofreader, should treat stuff??");
    //super.acceptProofreaders(node, verbose: verbose);
  }

  @override
  void acceptQuestion(XmlElement node, {bool verbose = false}) {
    print("accept question, should treat stuff??");
    super.acceptQuestion(node, verbose: verbose);
  }

  @override
  void acceptRatio(XmlElement node, {bool verbose = false}) {
    super.acceptRatio(node, verbose: verbose);
  }

  @override
  void acceptRef(XmlElement node, {bool verbose = false}) {
    //super.acceptRef(node,verbose: verbose);
  }

  @override
  void acceptRow(XmlElement node, {bool verbose = false}) {
    bool border = ((node.getAttribute("border") ?? "1") == "1");
    if(content.contains("<COLDEF>"))
      {
        String replacement = "${(border)?"|":" "}c"*node.children.length;
        content=  content.replaceAll("<COLDEF>", replacement);
      }
    super.acceptRow(node, verbose: verbose);
    content = content.replaceFirst(RegExp(r'&$'), '')+" \\\\ \\hline\n";
  }

  @override
  void acceptSection(XmlElement section, {bool verbose = false, int level = 0}) {
    level = stack.length;
    stack.add("section");
    //print("accept section[$level], should treat stuff??i $stack $section");
    super.acceptSection(section, verbose: verbose);
    String removed = stack.removeLast();
    if (removed != "section")
      print("AYEEEHH??? stack got back $removed instead of section??");
  }

  @override
  void acceptSlide(XmlElement module, {bool verbose = false}) {
    print("accept slide, should treat stuff??");
    super.acceptSlide(module, verbose: verbose);
  }

  @override
  void acceptSlideShow(XmlElement show, {bool verbose = false}) {
    print("accept slideshow, should treat stuff??");
    super.acceptSlideShow(show, verbose: verbose);
  }

  @override
  void acceptState(XmlElement node, {bool verbose = false}) {
    int level = stack.length;
    if (level == 1) {
      super.acceptState(node, verbose: verbose);
    }
    else if (level == 2 && stack.last == "theme") {}
    else if (level == 3 && stack.last == "module") {}
    else {
      print("accept State[$level], should treat stuff?? $stack");
      super.acceptState(node, verbose: verbose);
    }
  }

  @override
  void acceptSubTitle(XmlElement subtitle, {bool verbose = false}) {
    print("accept subtitle, should treat stuff??");
    super.acceptSubTitle(subtitle, verbose: verbose);
  }

  @override
  void acceptSuggestion(XmlElement suggestion, {bool verbose = false}) {
    //print("accept suggestion, should treat stuff??");
    //super.acceptSuggestion(suggestion, verbose: verbose);
  }

  @override
  void acceptTable(XmlElement node, {bool verbose = false}) {
    bool border = ((node.getAttribute("border") ?? "1") == "1")
        ? true
        : false; //TODO do something with border
    content += "\\begin{tabular}{<COLDEF>|}\n${(border)?"\\hline":""}\n";
    super.acceptTable(node, verbose: verbose);
    content += "\\end{tabular}";
  }

  @override
  void acceptText(XmlText node, {bool verbose = false, bool add = true}) {
    String txt = ((node.value.isNotEmpty) ? node.value : node.innerText).trim();
    if (node.children.isNotEmpty)
      print("should do something with ${node.children}");

    if (stack.last == "description") {
      desc.add(txt);
    } else if (stack.last == "objectives") {
      object.add(txt);
    } else {
      content += "$txt ";
    }
    super.acceptText(node, verbose: verbose);
  }

  @override
  void acceptTheme(XmlElement theme, {bool verbose = false}) {
    stack.add("theme");
    super.acceptTheme(theme, verbose: verbose);
    String removed = stack.removeLast();
    if (removed != "theme")
      print("AYEEEHH??? stack got back $removed instead of theme??");
  }

  @override
  void acceptTitle(XmlElement title, {bool verbose = false, bool add = true}) {
    int level = stack.length;
    //print("accespt title $level with $stack $title");
    if (level == 1) {
      content += "\\title{";
      if (title.children.isNotEmpty) {
        super.acceptTitle(title, verbose: verbose);
      }
      content += "}\n";
    } else {
      content += "${separators[level-2]}{";
      if (title.children.isNotEmpty) {
        super.acceptTitle(title, verbose: verbose);
      }
      content += "}\n";
    }
  }

  @override
  void acceptUrl(XmlElement node, {bool verbose = false}) {
    String href = node.getAttribute("href") ?? "";
    String name = node.getAttribute("name") ?? "";
    if (name.isEmpty) name = href;
    if (href.isNotEmpty) {
      content += "\\href{$name}{$href}";
      //To create a link to another place in your own document
      //\htmlref{text to have highlighted}{Label_name}
    }
    super.acceptUrl(node, verbose: verbose);
  }

  @override
  void acceptVersion(XmlElement version, {bool verbose = false}) {
   // int level = stack.length;
   // if(level == 1 || level == 2 || level == 3) {}
   // else {
   //   print("accept Version[$level], should treat stuff?? $object and $stack");
   //   super.acceptVersion(version, verbose: verbose);
   // }
  }
}
