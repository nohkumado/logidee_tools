import 'dart:collection';
import 'dart:io';

import 'package:logidee_tools/visitor_treetraversor.dart';
import 'package:xml/xml.dart';

import 'visitor.dart';

class VisitorSlideGen extends VisitorTreeTraversor {
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

  String background = "";

  @override
  Visitor acceptAnswer(XmlElement answNode,
      {bool verbose = false, StringBuffer? buffer}) {
    super.acceptAnswer(answNode, verbose: verbose, buffer: buffer);
    return this;
  }


  @override
  Visitor acceptCDATA(XmlCDATA cnode,
      {required bool verbose, StringBuffer? buffer}) {
    //print("CDATA : '${cnode.value}' ${cnode.innerText} ");
    add(cnode.value.trim() + "\n", buffer: buffer);
    super.acceptCDATA(cnode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCmd(XmlElement cmdNode,
      {bool verbose = false, StringBuffer? buffer}) {
    add("{\\texttt ", buffer: buffer);
    super.acceptCmd(cmdNode, verbose: verbose, buffer: buffer);
    add("} ", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCode(XmlElement codeNode,
      {bool verbose = false, StringBuffer? buffer}) {
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
    super.acceptCol(colNode, verbose: verbose, buffer: buffer);
    add("&", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptComment(XmlElement cmtNode,
      {bool verbose = false, StringBuffer? buffer}) {
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
    //print("accept dependency, should treat stuff??");
    //super.acceptDependency(dependency, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDescription(XmlElement desc,
      {bool verbose = false, StringBuffer? buffer}) {
    if (buffer == null) throw Exception("description can't have null buffer...");
      super.acceptDescription(desc, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDuration(XmlElement durNode,
      {bool verbose = false, StringBuffer? buffer}) {
    super.acceptDuration(durNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptEm(XmlElement emNode,
      {bool verbose = false, StringBuffer? buffer}) {
    add("\\emph{", buffer: buffer);
    super.acceptEm(emNode, verbose: verbose, buffer: buffer);
    //buffer = StringBuffer(buffer.toString().trim());
    add("} ", buffer: buffer, trim: true);
    return this;
  }

  @override
  Visitor acceptEmail(XmlElement mailNode,
      {bool verbose = false, StringBuffer? buffer}) {
    //super.acceptEmail(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptExercise(XmlElement exNode,
      {bool verbose = false, StringBuffer? buffer}) {
    String restriction = exNode.getAttribute("restriction") ?? "all";
    if(!(restriction == "all" || restriction == selection)) {
      print("textgen exercise $restriction != all or '$selection' bailing out");
      return this;
    }
    StringBuffer questBuf = StringBuffer();
    exNode.findElements("question").forEach((quest) {
      acceptQuestion(quest, verbose: verbose, buffer: questBuf);
    });

    if (questBuf.isNotEmpty && questBuf.toString().trim().isNotEmpty) {
      String question = "\\begin{exampleblock}{Exercise}\n${questBuf}\n\\end{exampleblock}\n";
      add(question, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptFile(XmlElement fileNode,
      {bool verbose = false, StringBuffer? buffer}) {
    add("{\\texttt ${fileNode.children.map((child) => child.toString().trim()).where((child) => child.isNotEmpty).join(" ")}}",
        buffer: buffer, trim: false);
    super.acceptFile(fileNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  acceptFormation(XmlElement formation,
      {bool verbose = false, StringBuffer? buffer}) {
    String background = formation.getAttribute("background") ?? "";
    if(background.isNotEmpty) this.background = background;
    buffer ??= content;
    stack.add("formation");
    super.acceptFormation(formation, verbose: verbose, buffer: buffer);
    String removed = stack.removeLast();
    if (removed != "formation") {
      print("AYEEEHH??? stack got back $removed instead of formation??");
    }
    add("\\end{document}\n",buffer: buffer);
        String txt = buffer.toString().replaceAll("<GLOSSARY>", "");
        buffer.clear();
        buffer.write(txt);
    return this;
  }

  @override
  Visitor acceptGlossary(XmlElement gloNode,
      {bool verbose = false, StringBuffer? buffer}) {
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
    String src = imgNode.getAttribute("src") ?? "";
    String scale = imgNode.getAttribute("scale") ?? "1";
    bool visible =
        ((imgNode.getAttribute("visible") ?? "true") == "true") ? true : false;
    bool captionVisible = true;

    if (visible) {
      print("image has scale $scale for $imgNode");
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
    int level = stack.length;
    //print("==============called acceptInfo with $level $stack");
    StringBuffer title = StringBuffer();
    StringBuffer subtitle = StringBuffer();
    StringBuffer author = StringBuffer();
    StringBuffer date = StringBuffer();
    info.findElements('title').firstOrNull?.let((element) => acceptTitle(element!, buffer: title));
    info.findElements('subtitle').firstOrNull?.let((element) => acceptSubTitle(element!, buffer: subtitle));
    info.findElements('author').firstOrNull?.let((element) => acceptAuthor(element!, buffer: author));
    if(subtitle.isEmpty){
      info.findElements('description').firstOrNull?.let((element) => acceptDescription(element!, buffer: subtitle));
      treated = [... treated,"description"];
    }
    if(author.isEmpty){
      info.findElements('version').firstOrNull?.findElements('author').firstOrNull?.let((element) => acceptAuthor(element!, buffer: author));
      treated = [... treated,"version"];
    }
    info.findElements('version').firstOrNull?.findElements('date').firstOrNull?.let((element) => acceptDate(element!, buffer: date));


 //  for (var p0 in info.children) {
 //    String value = (p0 is XmlElement) ? p0.name.toString() : "node";
 //    if (p0 is XmlElement && value == "title") acceptTitle(p0, buffer: title);
 //    else if (p0 is XmlElement && value == "subtitle") acceptSubTitle(p0, buffer: subtitle);
 //    else if (p0 is XmlElement && value == "author") acceptAuthor(p0, buffer: author);
 //  }
    treated = [... treated,"title","subtitle","author", "date"];

    if (level == 1) {
      add("""\\chapter*{\\centering \\begin{normalsize}Abstract\\end{normalsize}}
  \\begin{quotation};
  <DESC>
  <OBJ>
  \\end{quotation}
  \\clearpage
  
  """, buffer: abstract);
      add('''\\documentclass{beamer}
\\usepackage[T1]{fontenc}
\\usepackage[francais]{babel}
\\usepackage{graphicx}
\\usepackage{epstopdf}
\\usepackage{hyperref}
\\usepackage[most]{tcolorbox}
\\usepackage{listings}

\\title{${title.toString().trim()}}
\\subtitle{${subtitle.toString().trim()}}
\\author{${author.toString().trim()}}
${date.toString().trim()}
''', buffer: buffer);
      if(background.isNotEmpty) {
        add("\\setbeamertemplate{background}\n {\n \\includegraphics[width=\\paperwidth,height=\\paperheight]{$background}\n}\n" ,buffer: buffer);
      }
 if(File("logo.png").existsSync()) {
        add(
            "\\logo{\\includegraphics[width=2.5cm,height=2.5cm]{logo.png}}\n",buffer: buffer);
      }

  //    super.acceptInfo(info, verbose: verbose, buffer: buffer, treated: treated);

      add("\\begin{document}\n", buffer: buffer);
      add("\\begin{frame}\n", buffer: buffer); //% Print the title page as the first slide\n"), buffer: buffer);
      add("\\titlepage\n", buffer: buffer);
      add("\\end{frame}\n", buffer: buffer); //% Presentation outline\n"), buffer: buffer);
      add("\\begin{frame}{Outline}\n", buffer: buffer);
      add("\\tableofcontents\n", buffer: buffer);
      add("\\end{frame}\n", buffer: buffer); //open not formation info

      add("\\section{Abstract}\n", buffer: buffer); //open not formation info
      add("\\begin{frame}{Objectives}\n", buffer: buffer); //open not formation info
      StringBuffer objBuf = StringBuffer();
      info.findElements('objectives').firstOrNull?.let((element) => acceptObjectives(element!, buffer: objBuf));
      // Convert the list into a TeX-formatted string
      String formattedObjectives =
          object.map((item) => "\\item $item").join("\n");
      // Construct the final string with TeX formatting
      String itemized =
          "\\begin{itemize}\n$formattedObjectives\n\\end{itemize}";
      add("$itemized\n", buffer: buffer); //open not formation info
      add("\\end{frame}\n", buffer: buffer); //open not formation info
      treated.add("title");

    } else if (level == 2) {
      //print("acceptInfo lvl 2 $info");
      //print("TODO make a part page with the additional info $level");
      super.acceptInfo(info, verbose: verbose, buffer: buffer);
    } else if (level == 3) {
      //print("acceptInfo lvl 3 $info");
      super.acceptInfo(info, verbose: verbose, buffer: buffer);
    } else {
      print("don't know wjhat to do with info lvl $level $info");
      super.acceptInfo(info, verbose: verbose, buffer: buffer);
    }
    return this;
  }

  @override
  Visitor acceptItem(XmlElement itemNode,
      {bool verbose = false, StringBuffer? buffer}) {
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
    super.acceptLegend(legNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptLevel(XmlElement lvlNode,
      {bool verbose = false, StringBuffer? buffer}) {
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
    add("\\begin{itemize}\n", buffer: buffer);
    super.acceptList(listNode, verbose: verbose, buffer: buffer);
    add("\\end{itemize}\n", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptMath(XmlElement mathNode,
      {bool verbose = false, StringBuffer? buffer}) {
    String notation = mathNode.getAttribute("notation") ?? "html";
    add((notation == "tex") ? "\\begin{eqnarray}\n" : "{\\texttt ", buffer: buffer);
    super.acceptMath(mathNode, verbose: verbose, buffer: buffer);

    add((notation == "tex") ? "\\end{eqnarray}\n" : "}", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptMenu(XmlElement menNode,
      {bool verbose = false, StringBuffer? buffer}) {
    add("{\\bfseries \\large ", buffer: buffer);
    super.acceptMenu(menNode, verbose: verbose, buffer: buffer);
    add("} ", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptModule(XmlElement module,
      {bool verbose = false, StringBuffer? buffer, List<String> treated = const []}) {
    stack.add("module");
    treated = [...treated, "module","info","shortinfo"];
    super.acceptModule(module, verbose: verbose, buffer: buffer,treated: treated);
    String removed = stack.removeLast();
    if (removed != "module") {
      print("AYEEEHH??? stack got back $removed instead of module??");
    }
    return this;
  }

  @override
  Visitor acceptNote(XmlElement notNode,
      {bool verbose = false, StringBuffer? buffer}) {
    String restriction = notNode.getAttribute("restriction") ?? "all";
    if(!(restriction == "all" || restriction == selection)) {
      print("textgen note $restriction != all or '$selection' bailing out");
      return this;
    }
    String icon = notNode.getAttribute("icon") ?? "";
    bool trainer = ((notNode.getAttribute("trainer") ?? "0") == "1") ||
        ((notNode.getAttribute("trainer") ?? "0") == "true");

    if (trainer) {
      add("\\begin{alertblock}{Note}\n", buffer: buffer);
      super.acceptNote(notNode, verbose: verbose, buffer: buffer);
      add("\n\\end{alertblock}\n", buffer: buffer);
    } else {
      print("suppressed note $notNode, not a trainer");
    }
    return this;
  }

  @override
  Visitor acceptObjectives(XmlElement object,
      {bool verbose = false, StringBuffer? buffer}) {
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
    //if(treated.isEmpty())
    treated = [];
    String restriction = pageNode.getAttribute("restriction") ?? "all";
    if(!(restriction == "all" || restriction == selection)) {
      print("textgen page $restriction != all or '$selection' bailing out");
      return this;
    }
    //print("accept Page, should treat stuff??");
    stack.add("page");
    //print("stack now $stack ${stack.length}");

   bool collate = false;
    if(pageNode.findElements('slide').isNotEmpty) {
      treated.add('section');//ignore all besides the slide
      treated.add('exercise');//ignore all besides the slide
    } else {
      collate = true;
    }
    final titleElement = pageNode.findElements('title').firstOrNull;
    String title = "";
    if (titleElement != null) {
      StringBuffer titlebuf = StringBuffer();
      acceptTitle(titleElement, buffer: titlebuf);
      title = titlebuf.toString().trim();
    }
    treated = [... treated,"title","para"];
    if(collate) {
      buffer?.write("\\begin{frame}");
      if (title.isNotEmpty) buffer?.write("{${title}}");
      if (title.isNotEmpty) buffer?.write("\n");
      if (collate) {
        buffer?.write("\\begin{itemize}\n");
      }
    }
        super.acceptPage(pageNode, verbose: verbose, buffer: buffer, treated: treated);
        if(collate) {
          buffer?.write("\\end{itemize}\n");
          buffer?.write("\\end{frame}\n");
        }
        String removed = stack.removeLast();
        if (removed != "page") {
          print("AYEEEHH??? stack got back $removed instead of page??");
        }
        return this;
  }

  @override
  Visitor acceptPara(XmlElement paraNode,
      {bool verbose = false, String tag = "Para", StringBuffer? buffer, List<String> treated =const []}) {
    String restriction = paraNode.getAttribute("restriction") ?? "all";
    if(!(restriction == "all" || restriction == selection)) {
      print("textgen para $restriction != all or '$selection' bailing out");
      return this;
    }

    //print("accept Para, $stack for $paraNode");
    super.acceptPara(paraNode, verbose: verbose, buffer: buffer, treated: treated);
    add("\n", buffer: buffer);
    return this;
  }

  @override
  Visitor acceptPrerequisite(XmlElement prereqNode,
      {bool verbose = false, StringBuffer? buffer}) {
    //print("accept Prerequisites, should treat stuff??");
    //super.acceptPrerequisite(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptProofreaders(XmlElement proofRead,
      {bool verbose = false, StringBuffer? buffer}) {
    //print("accept proofreader, should treat stuff??");
    //super.acceptProofreaders(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptQuestion(XmlElement questNode,
      {bool verbose = false, StringBuffer? buffer}) {
    //print("accept question, should treat stuff??");
    super.acceptQuestion(questNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRatio(XmlElement ratioNode,
      {bool verbose = false, StringBuffer? buffer}) {
    super.acceptRatio(ratioNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRef(XmlElement refNode,
      {bool verbose = false, StringBuffer? buffer}) {
    if (buffer == null) throw Exception("slidegen can't have null buffer...");
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
    bool border = ((rowNode.getAttribute("border") ?? "1") == "1");
    if (buffer == null) {
      throw Exception("buffer has to be set!");
    }
    if (buffer.toString().contains("<COLDEF>")) {
      String replacement = "${(border) ? "|" : " "}c" * rowNode.children.length;
      String rpl = buffer.toString().replaceAll("<COLDEF>", replacement);
      buffer.clear();
      buffer.write(rpl);
    }
    super.acceptRow(rowNode, verbose: verbose, buffer: buffer);
    String rpl =
        buffer.toString().replaceFirst(RegExp(r'&$'), '') + " \\\\ \\hline\n";
    buffer.clear();
    buffer.write(rpl);
    return this;
  }

  @override
  Visitor acceptSection(XmlElement secNode,
      {bool verbose = false, int level = 0, StringBuffer? buffer, List<String> treated =const []}) {
    String restriction = secNode.getAttribute("restriction") ?? "all";
    if(!(restriction == "all" || restriction == selection)) {
      print("textgen section $restriction != all or '$selection' bailing out");
      return this;
    }
    level = stack.length;
    bool stacked = false;
    if(stack.last == "section"){//ok, we are delving deeper into the itemize
      add("\\item \\begin{itemize}\n",buffer: buffer);
      stacked = true;
    };
    stack.add("section");
    //print("entering section with stack as $stack");

    final titleElement = secNode.findElements('title').firstOrNull;
    String title = "";
    if (titleElement != null) {
      StringBuffer titlebuf = StringBuffer();
      acceptTitle(titleElement, buffer: titlebuf);
      title = titlebuf.toString().trim();
    }
    treated = [...treated,"title","para"];

    buffer?.write("\\item ${title}\n");

    super.acceptSection(secNode, verbose: verbose, buffer: buffer, level: level, treated: treated);
    if(stacked){
      add("\\end{itemize}\n",buffer: buffer);
    };
    String removed = stack.removeLast();
    if (removed != "section") {
      print("AYEEEHH??? stack got back $removed instead of section??");
    }
    return this;
  }

  @override
  Visitor acceptSlide(XmlElement slidNode,
      {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    stack.add("slide");
    String background = slidNode.getAttribute("background") ?? "";
    if (background.isNotEmpty) {
      //print("gound background $background");
      buffer?.write("{\n\\setbeamertemplate{background}\n{\n\\includegraphics[width=\\paperwidth,height=\\paperheight]{$background}\n}\n");
    }

    //print("checking for title in $slidNode");
    final titleElement = slidNode.findElements('title').firstOrNull;
    String title = "";
    if (titleElement != null) {
      StringBuffer titlebuf = StringBuffer();
      acceptTitle(titleElement, buffer: titlebuf);
      title = titlebuf.toString().trim();
    }
    treated = [... treated,"title"];
    buffer?.write("\\begin{frame}");
    if(title.isNotEmpty) buffer?.write("{${title}}");
    if(title.isNotEmpty) buffer?.write("\n");

    super.acceptSlide(slidNode, verbose: verbose, buffer: buffer, treated: treated);
    buffer?.write("\\end{frame}\n");
    if (background.isNotEmpty) {
      buffer?.write("}\n");
    }
    String removed = stack.removeLast();
    if (removed != "slide") {
      print("AYEEEHH??? stack got back $removed instead of slide??");
    }
    return this;
  }

  @override
  Visitor acceptSlideShow(XmlElement show,
      {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    //print("accept slideshow, should treat stuff??");
    stack.add("slideshow");
    treated = [... treated, "info", "shortinfo"];//TODO add a nice presentation page also for a slideshow....
    super.acceptSlideShow(show, verbose: verbose, buffer: buffer, treated: treated);
    String removed = stack.removeLast();
    if (removed != "slideshow") {
      print("AYEEEHH??? stack got back $removed instead of slideshow??");
    }
    return this;
  }

  @override
  Visitor acceptTable(XmlElement tblNode,
      {bool verbose = false, StringBuffer? buffer}) {
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
    stack.add("theme");
    treated = [... treated, "info", "shortinfo"];
    super.acceptTheme(theme, verbose: verbose, buffer: buffer, treated: treated);
    String removed = stack.removeLast();
    if (removed != "theme") {
      print("AYEEEHH??? stack got back $removed instead of theme??");
    }
    return this;
  }


  @override
  Visitor acceptUrl(XmlElement urlNode,
      {bool verbose = false, StringBuffer? buffer}) {
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

  add(String msg, {StringBuffer? buffer, bool trim = false}) {
    if (buffer != null) {
      if (trim) {
        String trimmedString = buffer.toString().trim();
        buffer.clear();
        buffer.write(trimmedString);
      }
      buffer.write(msg);
    } else {
      throw UnsupportedError("add needs a buffer to write to!");
    }
  }

  void clearAll() {
    content.clear();
    abstract.clear();
    answers.clear();
    glossary.clear();
    stack.clear();
  }

  VisitorSlideGen({String? charte, bool? trainer, String? selection, String? lang, bool? cycle}):super( charte:charte, trainer: trainer, selection: selection, lang: lang, cycle: cycle);

}

extension Let<T> on T? {
  R let<R>(R Function(T?) apply) {
    return this != null ? apply(this!) : apply(null); // Pass null if the receiver is null
  }
}
