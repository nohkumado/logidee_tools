import 'dart:collection';

import 'package:logidee_tools/visitor_treetraversor.dart';
import 'package:xml/xml.dart';

import 'visitor.dart';

class VisitorTexgen extends VisitorTreeTraversor {
  StringBuffer content = StringBuffer();
  StringBuffer abstract = StringBuffer();
  StringBuffer answers = StringBuffer();
  StringBuffer glossary = StringBuffer();

  Queue<String> stack = Queue();
  List<String> separators = const [
    "\\title",
    "\\part",
    "\\chapter",
    "\\section",
    "\\subsection",
    "\\paragraph"
  ];

  List<String> desc = [];
  List<String> object = [];

  @override
  Visitor acceptAnswer(XmlElement answNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen answer can't have null buffer...");
    super.acceptAnswer(answNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptAuthor(XmlElement authorNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if (buffer == null) throw Exception("textgen Author can't have null buffer...");
    int level = stack.length;
    //print("============ acceptAuthor $authorNode $level $stack");
    if (level == 1) {
      StringBuffer refBuffer = StringBuffer();
      super.acceptAuthor(authorNode, verbose: verbose, buffer: refBuffer);
      String rpl = buffer.toString();
      if (refBuffer.isNotEmpty && buffer.toString().contains("<AUTHOR>")) {
        rpl = buffer.toString().replaceAll("<AUTHOR>", "\\author{$refBuffer}");
      } else if (buffer.toString().contains("<AUTHOR>")) {
        rpl = buffer.toString().replaceAll("<AUTHOR>", "");
      }
      buffer.clear();
      buffer.write(rpl);
    } else if (level == 2) {
      //ignored for now
    } else {
      //print("accept author[$level], should treat stuff?? $object and $stack");
      if(stack.isEmpty || stack.last != "slideshow") {
        super.acceptAuthor(authorNode, verbose: verbose, buffer: buffer);
      }
      //TODO author in slideshow info??
    }
    return this;
  }

  @override
  Visitor acceptCDATA(XmlCDATA cnode,
      {required bool verbose, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen cdata can't have null buffer...");
    //print("CDATA : '${cnode.value}' ${cnode.innerText} ");
    add("${cnode.value.trim()}\n", buffer: buffer);
    super.acceptCDATA(cnode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCmd(XmlElement cmdNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen cmd can't have null buffer...");
    add("{\\texttt ", buffer: buffer);
    super.acceptCmd(cmdNode, verbose: verbose, buffer: buffer);
    add("} ", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCode(XmlElement codeNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen code can't have null buffer...");
    String proglang = (codeNode.getAttribute("lang") ?? "C").trim();
    String caption = codeNode.getAttribute("caption") ?? "";
    add("\\begin{lstlisting}[language=$proglang ${(caption.isNotEmpty)? ", caption=\"$caption\"":""}]\n", buffer: buffer);
    super.acceptCode(codeNode, verbose: verbose, buffer: buffer);
    add("\\end{lstlisting}\n", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCol(XmlElement colNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen col can't have null buffer...");
    super.acceptCol(colNode, verbose: verbose, buffer: buffer);
    add("&", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptComment(XmlElement cmtNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen comment can't have null buffer...");
    int level = stack.length;
    if (level == 1) {
      super.acceptComment(cmtNode, verbose: verbose, buffer: buffer);
    } else if (level == 2 && stack.last == "theme") {
    } else {
      //print("accept Comment[$level], should treat stuff?? $stack");
      super.acceptComment(cmtNode, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptDate(XmlElement dateNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen date can't have null buffer...");
    int level = stack.length;
    if (level == 1) {
      add("\\date{",buffer: buffer);
      super.acceptDate(dateNode, verbose: verbose, buffer: buffer);
      add("}\n",buffer: buffer);
    } else {
      //print("accept date, should treat stuff??");
      super.acceptDate(dateNode, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptDependency(XmlElement dependency,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen dependency can't have null buffer...");
    //print("accept dependency, should treat stuff??");
    //super.acceptDependency(dependency, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDescription(XmlElement desc,
      {bool verbose = false, StringBuffer? buffer}) {
    if (buffer == null) throw Exception("textgen description can't have null buffer...");
    int level = stack.length;
    if (level == 1) {
      StringBuffer refBuffer = StringBuffer();
      super.acceptDescription(desc, verbose: verbose, buffer: refBuffer);
      String rpl = buffer.toString();
      if (refBuffer.isNotEmpty && buffer.toString().contains("<SUBTITLE>")) {
        rpl = buffer
            .toString()
            .replaceAll("<SUBTITLE>", "\\subtitle{${refBuffer.toString().trim()}}");
      } else if (buffer.toString().contains("<SUBTITLE>")) {
        rpl = buffer.toString().replaceAll("<SUBTITLE>", "");
      }
      buffer.clear();
      buffer.write(rpl);
    } else if (level == 2) {
      //TODO ignored theme desc for now
    } else if (level == 3 ) {
     StringBuffer tmpBuf = StringBuffer();
      super.acceptDescription(desc, verbose: verbose, buffer: tmpBuf);
      if(tmpBuf.isNotEmpty && tmpBuf.toString().trim().isNotEmpty){
        if(stack.last != "slideshow") {
          add("\\section*{}\n", buffer: buffer);
          buffer.write(tmpBuf);
        }
        //else TODO handle slideshow info description
      }
    } else {
      //print( "accept description[$level], should treat stuff??i $desc and $stack");
      super.acceptDescription(desc, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptDuration(XmlElement durNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen duration can't have null buffer...");
    super.acceptDuration(durNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptEm(XmlElement emNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen em can't have null buffer...");
    add("\\emph{", buffer: buffer);
    super.acceptEm(emNode, verbose: verbose, buffer: buffer);
    //buffer = StringBuffer(buffer.toString().trim());
    add("} ", buffer: buffer, trim: true);
    return this;
  }

  @override
  Visitor acceptEmail(XmlElement mailNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen email can't have null buffer...");
    //super.acceptEmail(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptExercise(XmlElement exNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen Exercise can't have null buffer...");
    String restriction = exNode.getAttribute("restriction") ?? "all";
    if(!(restriction == "all" || restriction == selection)) {
      print("textgen exercise $restriction != all of '$selection' bailing out");
      return this;
    }
    StringBuffer questBuf = StringBuffer();
    StringBuffer answBuf = StringBuffer();
    for (var p0 in exNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement && value == "question") {
        acceptQuestion(p0, verbose: verbose, buffer: questBuf);
      } else if (p0 is XmlElement && value == "answer") {
        acceptAnswer(p0, verbose: verbose, buffer: answBuf);
      } else {
        valid = false;
        errmsg.write("exercise unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    if (questBuf.isNotEmpty) {
      String question = "\\begin{mybox}{Exercise} \\label{$questBuf}\n$questBuf\\end{mybox}\n";
      add(question,
          buffer: buffer);
      //print("buffer now $buffer");
      if (answBuf.isNotEmpty) {
        String answer = "\\subsection{Solution \\ref{$questBuf}}\n$answBuf\n";
        //print(" exercise, answering $answer");
        add(answer, buffer: answers);
      }
    }
    return this;
  }

  @override
  Visitor acceptFile(XmlElement fileNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen file can't have null buffer...");
    add("{\\texttt ${fileNode.children.map((child) => child.toString().trim()).where((child) => child.isNotEmpty).join(" ")}}",
        buffer: buffer, trim: false);
    super.acceptFile(fileNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  acceptFormation(XmlElement formation,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen formation can't have null buffer...");
    stack.add("formation");
    super.acceptFormation(formation, verbose: verbose, buffer: buffer);
    String removed = stack.removeLast();
    if (removed != "formation") {
      print("AYEEEHH??? stack got back $removed instead of formation??");
    }
    add("\\tableofcontents\n\\listoffigures\n\\listoftables\n\\end{document}\n",buffer: buffer);
    if(glossary.isNotEmpty)
      {
        String txt = buffer.toString().replaceAll("<GLOSSARY>", "\\usepackage{glossaries}\n\\input{glossaire.tex}\n\\makeglossaries\n");
        buffer.clear();
        buffer.write(txt);
      }
    else {
      String txt = buffer.toString().replaceAll("<GLOSSARY>", "");
      buffer.clear();
      buffer.write(txt);
    }
    return this;
  }

  @override
  Visitor acceptGlossary(XmlElement gloNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen glossary can't have null buffer...");
    //print("accept glossary, should treat stuff?? $node");
    String name = gloNode.getAttribute("name") ?? "";
    if (name.isNotEmpty) add(" \\gls{$name} ", buffer: buffer, trim: false);
    bool def = (gloNode.children.isNotEmpty) ? true : false;
    if (def) {
      add("\\newglossaryentry{$name}\n{\n name=$name, description={",
          buffer: glossary);
    }
    super.acceptGlossary(gloNode, verbose: verbose, buffer: glossary);
    if (def) add("}\n}\n", buffer: glossary);
    return this;
  }

  @override
  Visitor acceptImage(XmlElement imgNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen image can't have null buffer...");
    String src = imgNode.getAttribute("src") ?? "";
    String scale = imgNode.getAttribute("scale") ?? "1";
    bool visible =
        ((imgNode.getAttribute("visible") ?? "true") == "true") ? true : false;
    bool captionVisible = true;

    if (visible) {
      add("\\includegraphics[scale=$scale]{$src}", buffer: buffer, trim: false);
      if (imgNode.children.isNotEmpty) {
        XmlNode capNode = imgNode.firstChild!;
        if (capNode is XmlElement) {
          if (capNode.name.toString() == 'legend') {
            captionVisible =
                ((capNode.getAttribute("visible") ?? "true") == "true")
                    ? true
                    : false;
            if (captionVisible) {
              add("\n\\captionof{figure}{", buffer: buffer, trim: false);
              super.acceptImage(imgNode, verbose: verbose, buffer: buffer);
              add("}", buffer: buffer, trim: false);
            }
          } else {
            add("unknown figure : ${capNode.runtimeType} '${capNode.name}' $capNode\n",
                buffer: buffer, trim: false);
          }
        }
      }
    } else {
      add("expected legend, don't know what to do with ${imgNode.children.first.runtimeType} ${imgNode.firstChild}",
          buffer: buffer, trim: false);
      super.acceptImage(imgNode, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  //TODO probable need an acceptLegend for image!
  @override
  Visitor acceptInfo(XmlElement info,
      {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if(buffer == null) throw Exception("textgen info can't have null buffer...");
    int level = stack.length;
    //print("==============called acceptInfo with $level $stack");

    if (level == 1) {
      add("""\\chapter*{\\centering \\begin{normalsize}Abstract\\end{normalsize}}
  \\begin{quotation};
  <DESC>
  <OBJ>
  \\end{quotation}
  \\clearpage
  
  """, buffer: abstract);
      add('''\\documentclass[a4paper,12pt]{scrbook}
\\usepackage{babel}[$lang]
\\usepackage[most]{tcolorbox}
\\usepackage{tikz}
\\usepackage{fontawesome}
\\usepackage[font=small,labelfont=bf]{caption} 
\\usepackage{graphicx}
\\usepackage{epstopdf}
\\usepackage{hyperref}
\\usepackage{listings}
<GLOSSARY>

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
    ''', buffer: buffer);
      super.acceptInfo(info, verbose: verbose, buffer: buffer, treated: treated);

      add("\\begin{document}\n", buffer: buffer);
      add("\\maketitle\n", buffer: buffer);
      String rpld = abstract.toString().replaceAll("<DESC>", desc.join("\n"));
      abstract.clear();
      abstract.write(rpld);
      // Convert the list into a TeX-formatted string
      String formattedObjectives =
          object.map((item) => "\\item $item").join("\n");
      // Construct the final string with TeX formatting
      String itemized =
          "\\begin{itemize}\n$formattedObjectives\n\\end{itemize}";

      String obRep = abstract.toString().replaceAll("<OBJ>", itemized);
      abstract.clear();
      abstract.write(obRep);
      add(obRep, buffer: buffer);
    } else if (level == 2) {
      //print("acceptInfo lvl 2 $info");
      //print("TODO make a part page with the additional info $level");
      super.acceptInfo(info, verbose: verbose, buffer: buffer);
    } else if (level == 3) {
      //print("acceptInfo lvl 3 $info");
      super.acceptInfo(info, verbose: verbose, buffer: buffer);
    } else {
      print("don't know what to do with info lvl $level $info");
      super.acceptInfo(info, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptItem(XmlElement itemNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen item can't have null buffer...");
    int level = stack.length;
    if (level == 2 && stack.last == "objectives") {
      super.acceptItem(itemNode, verbose: verbose, buffer: buffer);
    } else if (level == 2 && stack.last == "theme") {
    } else {
      //print("accept Item[$level], should treat stuff?? $stack $node");
      StringBuffer tmpBuffer = StringBuffer();
      super.acceptItem(itemNode, verbose: verbose, buffer: tmpBuffer);
      if (tmpBuffer.length > 0) {
        add("\\item $tmpBuffer\n", buffer: buffer, trim: false);
      } //else print("item was empty, no \item generated for $node");
    }
    return this;
  }

  @override
  Visitor acceptLegend(XmlElement legNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen legend can't have null buffer...");
    super.acceptLegend(legNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptLevel(XmlElement lvlNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen level can't have null buffer...");
    int level = stack.length;
    if (level == 1) {
      super.acceptLevel(lvlNode, verbose: verbose, buffer: buffer);
    } else if (level == 2 && stack.last == "theme") {
    } else if (level == 3) {
    } else {
      //print("accept Level[$level], should treat stuff?? $stack");
      super.acceptLevel(lvlNode, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptList(XmlElement listNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen list can't have null buffer...");
    add("\\begin{itemize}\n", buffer: buffer);
    super.acceptList(listNode, verbose: verbose, buffer: buffer);
    add("\\end{itemize}\n", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptMath(XmlElement mathNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen math can't have null buffer...");
    String notation = mathNode.getAttribute("notation") ?? "html";
    add((notation == "tex") ? "\\begin{eqnarray}\n" : "{\\texttt ", buffer: buffer);
    super.acceptMath(mathNode, verbose: verbose, buffer: buffer);

    add((notation == "tex") ? "\\end{eqnarray}\n" : "}", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptMenu(XmlElement menNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen menu can't have null buffer...");
    add("{\\bfseries \\large ", buffer: buffer);
    super.acceptMenu(menNode, verbose: verbose, buffer: buffer);
    add("} ", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptModule(XmlElement module,
      {bool verbose = false, StringBuffer? buffer, List<String> treated = const []}) {
    if(buffer == null) throw Exception("textgen module can't have null buffer...");
    stack.add("module");
    super.acceptModule(module, verbose: verbose, buffer: buffer, treated: treated);
    if (answers.isNotEmpty) add("\\section{Answers}\n$answers", buffer: buffer);
    answers.clear();
    String removed = stack.removeLast();
    if (removed != "module") {
      print("AYEEEHH??? stack got back $removed instead of module??");
    }
    return this;
  }

  @override
  Visitor acceptNote(XmlElement notNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen note can't have null buffer...");
    String restriction = notNode.getAttribute("restriction") ?? "all";
      if(!(restriction == "all" || restriction == selection)) {
      print("textgen note $restriction != all or '$selection' bailing out");
      return this;
    }
    String icon = notNode.getAttribute("icon") ?? "";
    bool trainer = ((notNode.getAttribute("trainer") ?? "0") == "1") ||
        ((notNode.getAttribute("trainer") ?? "0") == "true");

    //print("accept Note, should treat stuff??");
    if (trainer) {
      add("\\begin{mybox}{Note}${(icon.isNotEmpty) ? "{$icon}" : ""}\n",
          buffer: buffer);
      super.acceptNote(notNode, verbose: verbose, buffer: buffer);
      add("\n\\end{mybox}\n", buffer: buffer);
    } else {
      print("suppressed note $notNode, not a trainer");
    }
    return this;
  }

  @override
  Visitor acceptObjectives(XmlElement object,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen objective can't have null buffer...");
    int level = stack.length;
    if (level == 0) level = 1; //happens only in testing
    if (level == 1) {
      stack.add(object.name.toString());
      super.acceptObjectives(object, verbose: verbose, buffer: buffer);
      String removed = stack.removeLast();
      if (removed != "objectives") {
        print("AYEEEHH??? stack got back $removed instead of objectives??");
      }
    } else if (level == 2) {
      //ignored for now
    } else if (level == 3) {
      add("\\subsection*{}\n\\begin{itemize}\n", buffer: buffer);
      super.acceptObjectives(object, verbose: verbose, buffer: buffer);
      add("\\end{itemize}\n", buffer: buffer);
    } else {
      print(
          "accept Objective[$level], should treat stuff?? $object and $stack");
      super.acceptObjectives(object, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptPage(XmlElement pageNode,
      {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    //print("texgen accepting page");
    if(buffer == null) throw Exception("textgen page can't have null buffer...");
    //print("texgen  page buffer ok");
    String restriction = pageNode.getAttribute("restriction") ?? "all";
    //print("texgen  page restriction= '$restriction' vs '$selection' ok");
      if(!(restriction == "all" || restriction == selection)) {
      print("texgen  page restriction= failed bailing out '$restriction' vs $selection ok");
      return this;
    }
    //print("accept Page, should treat stuff??");
    stack.add("page");
    //print("stack now $stack ${stack.length}");
    //print("texgen sending page to super\n");
    super.acceptPage(pageNode, verbose: verbose, buffer: buffer, treated: treated);
    String removed = stack.removeLast();
    if (removed != "page") {
      print("AYEEEHH??? stack got back $removed instead of page??");
    }
    return this;
  }

  @override
  Visitor acceptPara(XmlElement paraNode,
      {bool verbose = false, String tag = "Para", StringBuffer? buffer, List<String> treated =const []}) {
    if(buffer == null) throw Exception("textgen para can't have null buffer...");
    String restriction = paraNode.getAttribute("restriction") ?? "all";
      if(!(restriction == "all" || restriction == selection)) {
      print("textgen para $restriction != all of '$selection' bailing out");
      return this;
    }

    //print("accept Para, $stack for $paraNode");
    super.acceptPara(paraNode, verbose: verbose, buffer: buffer, treated: treated);
    add("\n\n", buffer: buffer);
    //print("para returns $buffer");
    return this;
  }

  @override
  Visitor acceptPrerequisite(XmlElement prereqNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen prerequisite can't have null buffer...");
    //print("accept Prerequisites, should treat stuff??");
    //super.acceptPrerequisite(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptProofreaders(XmlElement proofRead,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen proofreader can't have null buffer...");
    //print("accept proofreader, should treat stuff??");
    //super.acceptProofreaders(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptQuestion(XmlElement questNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen question can't have null buffer...");
    //print("accept question, should treat stuff??");
    super.acceptQuestion(questNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRatio(XmlElement ratioNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen ratio can't have null buffer...");
    super.acceptRatio(ratioNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRef(XmlElement refNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen ref can't have null buffer...");
    int level = stack.length;
    if (level == 1) {
      StringBuffer refBuffer = StringBuffer();
      super.acceptRef(refNode, buffer: refBuffer);
      if (refBuffer.isNotEmpty) {
        if (buffer.toString().contains("<SUBJECT>")) {
          String rpl = buffer
              .toString()
              .replaceAll("<SUBJECT>", "\\subject{$refBuffer}");
          buffer.clear();
          buffer.write(rpl);
        }
      }
    }
    return this;
  }

  @override
  Visitor acceptRow(XmlElement rowNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen row can't have null buffer...");
    bool border = ((rowNode.getAttribute("border") ?? "1") == "1");
    if (buffer.toString().contains("<COLDEF>")) {
      String replacement = "${(border) ? "|" : " "}c" * rowNode.children.length;
      String rpl = buffer.toString().replaceAll("<COLDEF>", replacement);
      buffer.clear();
      buffer.write(rpl);
    }
    super.acceptRow(rowNode, verbose: verbose, buffer: buffer);
    String rpl =
        "${buffer.toString().replaceFirst(RegExp(r'&$'), '')} \\\\ \\hline\n";
    buffer.clear();
    buffer.write(rpl);
    return this;
  }

  @override
  Visitor acceptSection(XmlElement secNode,
      {bool verbose = false, int level = 0, StringBuffer? buffer, List<String> treated =const []}) {
    if(buffer == null) throw Exception("textgen section can't have null buffer...");
    String restriction = secNode.getAttribute("restriction") ?? "all";
      if(!(restriction == "all" || restriction == selection)) {
      print("textgen section $restriction != all of '$selection' bailing out");
      return this;
    }
    level = stack.length;
    stack.add("section");
    //print("txtgen lvl: $level st: $stack");
    //print("accept section[$level], should treat stuff??i $stack $secNode");
    super
        .acceptSection(secNode, verbose: verbose, buffer: buffer, level: level, treated: treated);
    String removed = stack.removeLast();
    if (removed != "section") {
      print("AYEEEHH??? stack got back $removed instead of section??");
    }
    return this;
  }

  @override
  Visitor acceptSlide(XmlElement slidNode,
      {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if(buffer == null) throw Exception("textgen slide can't have null buffer...");
    stack.add("slide");
    super.acceptSlide(slidNode, verbose: verbose, buffer: buffer);
    String removed = stack.removeLast();
    if (removed != "slide") {
      print("AYEEEHH??? stack got back $removed instead of slide??");
    }
    return this;
  }

  @override
  Visitor acceptSlideShow(XmlElement show,
      {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if(buffer == null) throw Exception("textgen slideshow can't have null buffer...");
    //print("accept slideshow, should treat stuff??");
    stack.add("slideshow");
    super.acceptSlideShow(show, verbose: verbose, buffer: buffer);
    String removed = stack.removeLast();
    if (removed != "slideshow") {
      print("AYEEEHH??? stack got back $removed instead of slideshow??");
    }
    return this;
  }

  @override
  Visitor acceptState(XmlElement stateNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen state can't have null buffer...");
    int level = stack.length;
    if (level == 1) {
      super.acceptState(stateNode, verbose: verbose, buffer: buffer);
    } else if (level == 2 && stack.last == "theme") {
    } else if (level == 3 && stack.last == "module") {
    } else {
      //print("accept State[$level], should treat stuff?? $stack");
      super.acceptState(stateNode, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptSubTitle(XmlElement subtitle,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen subtitle can't have null buffer...");
    if(stack.length == 1) {
      //TODO check if some other part needs subtitles
    super.acceptSubTitle(subtitle, verbose: verbose, buffer: buffer);
    //print("accept SubTitle : $buffer");
    }
    return this;
  }

  @override
  Visitor acceptSuggestion(XmlElement suggestion,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen suggestion can't have null buffer...");
    //print("accept suggestion, should treat stuff??");
    //super.acceptSuggestion(suggestion, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptTable(XmlElement tblNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen table can't have null buffer...");
    bool border = ((tblNode.getAttribute("border") ?? "1") == "1")
        ? true
        : false; //TODO do something with border
    add("\\begin{tabular}{<COLDEF>|}\n${(border) ? "\\hline" : ""}\n",
        buffer: buffer);
    super.acceptTable(tblNode, verbose: verbose, buffer: buffer);
    add("\\end{tabular}", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptText(XmlText txtNode,
      {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen text can't have null buffer...");
    String txt =
        ((txtNode.value.isNotEmpty) ? txtNode.value : txtNode.innerText).trim();
    txt = txt.replaceAll("&", "\\&");
    if (txtNode.children.isNotEmpty) {
      print("should do something with ${txtNode.children}");
    }

    if (stack.isNotEmpty && stack.last == "description") {
      desc.add(txt);
    } else if (stack.isNotEmpty && stack.last == "objectives") {
      object.add(txt);
    } else {
      this.add(txt, buffer: buffer);
      //if(buffer != null) {
      //  buffer.write("$txt ");
      //} else {
      //  add("$txt ", buffer:buffer);
      //}
    }
    super.acceptText(txtNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptTheme(XmlElement theme,
      {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if(buffer == null) throw Exception("textgen theme can't have null buffer...");
    stack.add("theme");
    super.acceptTheme(theme, verbose: verbose, buffer: buffer);
    String removed = stack.removeLast();
    if (removed != "theme") {
      print("AYEEEHH??? stack got back $removed instead of theme??");
    }
    return this;
  }

  @override
  Visitor acceptTitle(XmlElement title,
      {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen title can't have null buffer...");
    int level = stack.length;
    if (level == 2) {
      //print("----- TODO do something with theme info accept title $level/$sepLvl with $stack $title gives ${separators[sepLvl]}/$separators");
      return this;
    }
    int sepLvl = level - 2;
    if (sepLvl < 1) sepLvl = 0;
    if (sepLvl >= separators.length) sepLvl = separators.length - 1;
    //print("----- accept title $level/$sepLvl with $stack $title gives ${separators[sepLvl]}/$separators");
    if (stack.contains("slideshow")) {
      if (sepLvl < separators.length -1) sepLvl++;
      //print("slideshow detected: $title $level $stack $sepLvl $separators ${separators[sepLvl]}");
      this.add("${separators[sepLvl]}{", buffer: buffer);
      if (title.children.isNotEmpty) {
        //print("accepting tt tile $title");
        super.acceptTitle(title, verbose: verbose, buffer: buffer);
      }
      this.add("}\n", buffer: buffer);
    } else {
      if (level == 1) {
        buffer.write("<SUBJECT>\n \\title{");
      } else {
        this.add("${separators[sepLvl]}{", buffer: buffer);
      }
      if (title.children.isNotEmpty) {
        //print("accepting tt tile $title");
        super.acceptTitle(title, verbose: verbose, buffer: buffer);
      }
      if (level == 1) {
        buffer.write("}\n<SUBTITLE>\n<AUTHOR>\n");
      } else {
        this.add("}\n", buffer: buffer);
      }
    }
    return this;
  }

  @override
  Visitor acceptUrl(XmlElement urlNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen url can't have null buffer...");
    String href = urlNode.getAttribute("href") ?? "";
    String name = urlNode.getAttribute("name") ?? "";
    if (name.isEmpty) name = href;
    if (href.isNotEmpty) {
      add("\\href{$name}{$href}", buffer: buffer);
      //To create a link to another place in your own document
      //\htmlref{text to have highlighted}{Label_name}
    }
    return super.acceptUrl(urlNode, verbose: verbose, buffer: buffer);
  }

  @override
  Visitor acceptVersion(XmlElement version,
      {bool verbose = false, StringBuffer? buffer}) {
    if(buffer == null) throw Exception("textgen version can't have null buffer...");
     int level = stack.length;
     if(level == 1)
     {
       //print("accept version lvl 1");
       super.acceptVersion(version, verbose: verbose, buffer: buffer);

     }
     else if(level == 2 || level == 3) {}
     else {
       //print("accept Version[$level], should treat stuff?? $object and $stack");
       super.acceptVersion(version, verbose: verbose, buffer: buffer);
     }
    return this;
  }

  add(String msg, {required StringBuffer buffer, bool trim = false}) {
      if (trim) {
        String trimmedString = buffer.toString().trim();
        buffer.clear();
        buffer.write(trimmedString);
      }
      buffer.write(msg);
  }

  void clearAll() {
    content.clear();
    abstract.clear();
    answers.clear();
    glossary.clear();
    stack.clear();
  }

  VisitorTexgen({super.charte, super.trainer, super.selection, super.lang, super.cycle});
}
