import 'package:logidee_tools/visitor.dart';
import 'package:xml/xml.dart';

class VisitorTreeTraversor extends Visitor {
  VisitorTreeTraversor({super.charte, super.trainer, super.selection, super.lang, super.cycle});

  @override
  Visitor acceptFormation(XmlElement formation, {bool verbose = false, StringBuffer? buffer}) {
    if (formation.name.toString() != "formation") {
      throw UnsupportedError(
        "wrong node addressed expected formation got ${formation.name}...");
    }
    for (var p0 in formation.children) {
      //(p0 is XmlElement)? errmsg.write("formation child: ${p0.name.toString()}"):errmsg.write("formation unknown: $p0 of ${p0.runtimeType}");
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "theme") {
          acceptTheme(p0, verbose: verbose, buffer: buffer);
        }
      } else {
        valid = false;
        errmsg.write("formation unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptInfo(XmlElement info, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if (!(info.name.toString() == "info" || info.name.toString() == "shortinfo")) {
      throw UnsupportedError(
        "wrong node addressed expected info got ${info.name}...");
    }
    for (var p0 in info.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "title" && !treated.contains("title")) {
          acceptTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "subtitle" && !treated.contains("subtitle")) {
          acceptSubTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "ref" && !treated.contains("ref")) {
          acceptRef(p0, verbose: verbose, buffer: buffer);
        } else if (value == "description" && !treated.contains("description")) {
          acceptDescription(p0, verbose: verbose, buffer: buffer);
        } else if (value == "objectives" && !treated.contains("objectives")) {
          acceptObjectives(p0, verbose: verbose, buffer: buffer);
        } else if (value == "ratio" && !treated.contains("ratio")) {
          acceptRatio(p0, verbose: verbose, buffer: buffer);
        } else if (value == "duration" && !treated.contains("duration")) {
          acceptDuration(p0, verbose: verbose, buffer: buffer);
        } else if (value == "prerequisite" && !treated.contains("prerequisite")) {
          acceptPrerequisite(p0, verbose: verbose, buffer: buffer);
        } else if (value == "dependency" && !treated.contains("dependency")) {
          acceptDependency(p0, verbose: verbose, buffer: buffer);
        } else if (value == "suggestion" && !treated.contains("suggestion")) {
          acceptSuggestion(p0, verbose: verbose, buffer: buffer);
        } else if (value == "version" && !treated.contains("version")) {
          acceptVersion(p0, verbose: verbose, buffer: buffer);
        } else if (value == "level" && !treated.contains("level")) {
          acceptLevel(p0, verbose: verbose, buffer: buffer);
        } else if (value == "state" && !treated.contains("state")) {
          acceptState(p0, verbose: verbose, buffer: buffer);
        } else if (value == "proofreaders" && !treated.contains("proofreaders")) {
          acceptProofreaders(p0, verbose: verbose, buffer: buffer);
        } else {
          errmsg.write("info unknown stuff: ${p0.runtimeType} $p0\n");
        }
      } else {
        valid = false;
        errmsg.write("info unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptTheme(XmlElement theme, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if (theme.name.toString() != "theme") {
      throw UnsupportedError(
        "wrong node addressed expected theme got ${theme.name}...");
    }
    for (var p0 in theme.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          //print("entering theme info");
        if (!treated.contains("info")) {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        }
          //else print("refusing theme info");
        } else if (value == "shortinfo") {
          if (!treated.contains("shortinfo")) {
            acceptInfo(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "module") {
          if (!treated.contains("module")) {
            acceptModule(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "slideshow") {
          if (!treated.contains("slideshow")) {
            acceptSlideShow(p0, verbose: verbose, buffer: buffer);
          }
        }
      } else {
        valid = false;
        errmsg.write("Theme unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptTitle(XmlElement title, {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    if (title.name.toString() != "title") {
      throw UnsupportedError(
        "wrong node addressed expected title got ${title.name}...");
    }
    for (var node in title.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in title spurious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptDescription(XmlElement desc, {bool verbose = false, StringBuffer? buffer}) {
    if (desc.name.toString() != "description") {
      throw UnsupportedError(
          "wrong node addressed expected description got ${desc.name}...");
    }
    for (var node in desc.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "para") {
          acceptPara(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg.write("Description unknown stuff: ${node.runtimeType} $node");
        }
      } else {
        valid = false;
        errmsg.write("Description unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptObjectives(XmlElement object, {bool verbose = false, StringBuffer? buffer}) {
    if (object.name.toString() != "objectives") {
      throw UnsupportedError(
          "wrong node addressed expected objectives got ${object.name}...");
    }
    for (var node in object.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "item") {
          acceptItem(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg.write("Objectives unknown stuff: ${node.runtimeType} $node");
        }
      } else {
        valid = false;
        errmsg.write("Objectives unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptDependency(XmlElement dependency, {bool verbose = false, StringBuffer? buffer}) {
    if (dependency.name.toString() != "dependency") {
      throw UnsupportedError(
          "wrong node addressed expected dependency got ${dependency.name}...");
    }
    for (var node in dependency.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "ref") {
          acceptRef(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg.write("Dependency unknown stuff: ${node.runtimeType} $node");
        }
      } else {
        valid = false;
        errmsg.write("Dependency unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptSuggestion(XmlElement suggestion, {bool verbose = false, StringBuffer? buffer}) {
if (suggestion.name.toString() != "suggestion") {
  throw UnsupportedError(
      "wrong node addressed expected suggestion got ${suggestion.name}...");
}
    for (var node in suggestion.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "ref") {
          acceptRef(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg.write("Suggestion unknown stuff: ${node.runtimeType} $node");
        }
      } else {
        valid = false;
        errmsg.write("Suggestion unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptVersion(XmlElement version, {bool verbose = false, StringBuffer? buffer}) {

    if (version.name.toString() != "version") {
      throw UnsupportedError(
          "wrong node addressed expected version got ${version.name}...");
    }
    String number = version.getAttribute("number") ?? "";
    if (number.isEmpty) {
      valid = false;
      errmsg.write("Version tag version needs a number");
    }
    for (var node in version.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "author") {
          acceptAuthor(node, verbose: verbose, buffer: buffer);
        } else if (value == "email") {
          acceptEmail(node, verbose: verbose, buffer: buffer);
        } else if (value == "comment") {
          acceptComment(node, verbose: verbose, buffer: buffer);
        } else if (value == "date") {
          acceptDate(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg.write("Version unknown stuff: ${node.runtimeType} $node");
        }
      } else {
        valid = false;
        errmsg.write("Version unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptProofreaders(XmlElement proofRead, {bool verbose = false, StringBuffer? buffer}) {

    if (proofRead.name.toString() != "proofreaders") {
      throw UnsupportedError(
          "wrong node addressed expected proofreader got ${proofRead.name}...");
    }
    for (var node in proofRead.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "item") {
          acceptItem(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg.write("Proofreaders unknown stuff: ${node.runtimeType} $node");
        }
      } else {
        valid = false;
        errmsg.write("Proofreaders unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptRatio(XmlElement ratioNode, {bool verbose = false, StringBuffer? buffer}) {

    if (ratioNode.name.toString() != "ratio") {
      throw UnsupportedError(
          "wrong node addressed expected ratio got ${ratioNode.name}...");
    }
    return this;
  }

  //String icon = module.getAttribute("icon")??""; //para note exercise image link of type
  @override
  Visitor acceptPara(XmlElement paraNode,
      {bool verbose = false, String tag = "Para", StringBuffer? buffer, List<String> treated =const []}) {
    if (paraNode.name.toString() != "para") {
      throw UnsupportedError(
          "wrong node ?? expected para got  ${paraNode.name}...");
    }
    for (var subnode in paraNode.children) {
      //print("acceptPara child loop treating $node of ${node.runtimeType}");
      if (subnode is XmlText) {
        if (!treated.contains("text")) {
          acceptText(subnode, verbose: verbose,buffer: buffer);
        }
      } else if (subnode is XmlElement) {
        if (subnode.name.toString() == "url") {
          if (!treated.contains("url")) {
            acceptUrl(
            subnode,
            verbose: verbose,buffer: buffer
          );
          }
        } else if (subnode.name.toString() == "image") {
          if (!treated.contains("image")) {
            acceptImage(
            subnode,
            verbose: verbose,buffer: buffer
          );
          }
        } else if (subnode.name.toString() == "list") {
          if (!treated.contains("list")) {
            //print("acceptPara calling acceptList $node of ${node.runtimeType}");
          acceptList(subnode, verbose: verbose,buffer: buffer);
          }
        } else if (subnode.name.toString() == "em") {
          if (!treated.contains("em")) {
            acceptEm(subnode, verbose: verbose,buffer: buffer);
          }
        } else if (subnode.name.toString() == "cmd") {
          if (!treated.contains("cmd")) {
            acceptCmd(
            subnode,
            verbose: verbose,buffer: buffer
          );
          }
        } else if (subnode.name.toString() == "menu") {
          if (!treated.contains("menu")) {
            acceptMenu(
            subnode,
            verbose: verbose,buffer: buffer
          );
          }
        } else if (subnode.name.toString() == "file") {
          if (!treated.contains("file")) {
            acceptFile(
            subnode,
            verbose: verbose,buffer: buffer
          );
          }
        } else if (subnode.name.toString() == "code") {
          if (!treated.contains("code")) {
            acceptCode(
            subnode,
            verbose: verbose,buffer: buffer
          );
          }
        } else if (subnode.name.toString() == "table") {
          if (!treated.contains("table")) {
            acceptTable(subnode, verbose: verbose,buffer: buffer);
          }
        } else if (subnode.name.toString() == "math") {
          if (!treated.contains("math")) {
            acceptMath(subnode, verbose: verbose,buffer: buffer);
          }
        } else if (subnode.name.toString() == "glossary") {
          if (!treated.contains("glossary")) {
            acceptGlossary(subnode, verbose: verbose,buffer: buffer);
          }
        } else if (subnode.name.toString() == "note") {
          if (!treated.contains("note")) {
            acceptNote(subnode, verbose: verbose,buffer: buffer);
          }
        } else{
          errmsg.write("parsing paragraph unknown element ${subnode.name}\n");
          valid = false;
        }
      } else {
        errmsg.write("parsing paragraph unknown  ${subnode.runtimeType}\n");
        valid = false;
      }
    }
return this;
  }

  @override
  Visitor acceptItem(XmlElement itemNode, {bool verbose = false, StringBuffer? buffer}) {

    if (itemNode.name.toString() != "item") {
      throw UnsupportedError(
          "wrong node addressed expected item got ${itemNode.name}...");
    }
    for (var p0 in itemNode.children) {
      String value = (p0 is XmlElement)
          ? p0.name.toString()
          : (p0 is XmlText)
          ? "txt"
          : "node";
      if (p0 is XmlText) {
        acceptText(p0, verbose: verbose,buffer: buffer);
      } else if (p0 is XmlElement) {
          if (value == "txt" || value == "para") {
          acceptPara(p0, verbose: verbose, tag: "Item-para",buffer: buffer);
        }  else if (value == "list") {
          acceptList(p0, verbose: verbose,buffer: buffer);
        } else if (value == "cmd") {
          acceptCmd(p0, verbose: verbose,buffer: buffer);
        } else if (value == "url") {
          acceptUrl(p0, verbose: verbose,buffer: buffer);
        } else {
          valid = false;
          errmsg.write("Item unknown element: ${p0.runtimeType} $p0\n");
        }

      } else {
        valid = false;
        errmsg.write("Item unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptRef(XmlElement refNode, {bool verbose = false, StringBuffer? buffer}) {
    if (refNode.name.toString() != "ref") {
      throw UnsupportedError(
          "wrong node addressed expected ref ${refNode.name}...");
    }
    for (var node in refNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in ref spurious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptAuthor(XmlElement authorNode, {bool verbose = false, StringBuffer? buffer}) {
    if (authorNode.name.toString() != "author") {
      throw UnsupportedError(
        "wrong node addressed expected author got ${authorNode.name}...");
    }
    for (var node in authorNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in author spurious stuff $node");
      }
    }
    if(buffer != null) {
      String cleaned = buffer.toString().trim();
      buffer.clear();
      buffer.write(cleaned);
    }
    return this;
  }

  @override
  Visitor acceptEmail(XmlElement mailNode, {bool verbose = false, StringBuffer? buffer})
  {
    if (mailNode.name.toString() != "email") {
      throw UnsupportedError(
          "wrong node addressed expected email got ${mailNode.name}...");
    }
    for (var node in mailNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose,buffer: buffer);
      } else {
        print("found in email spurious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptComment(XmlElement cmtNode, {bool verbose = false, StringBuffer? buffer}) {
    if (cmtNode.name.toString() != "comment") {
      throw UnsupportedError(
          "wrong node addressed expected comment got ${cmtNode.name}...");
    }
    return this;}

  @override
  Visitor acceptDate(XmlElement dateNode, {bool verbose = false, StringBuffer? buffer}) {
    if (dateNode.name.toString() != "date") {
      throw UnsupportedError(
        "wrong node addressed expected date got ${dateNode.name}...");
    }
    for (var node in dateNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in date spurious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptSlideShow(XmlElement show, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if (show.name.toString() != "slideshow") {
      throw UnsupportedError(
          "wrong node addressed expected slideshow got ${show.name}...");
    }
    for (var p0 in show.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          if (!treated.contains("info")) {
            acceptInfo(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "shortinfo") {
          if (!treated.contains("shortinfo")) {
            acceptInfo(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "slide") {
          if (!treated.contains("slide")) {
            acceptSlide(p0, verbose: verbose, buffer: buffer);
          }
        }
      } else {
        valid = false;
        errmsg.write("SlideShow unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptModule(XmlElement module, {bool verbose = false, StringBuffer? buffer, List<String> treated = const []}) {
    if (module.name.toString() != "module") {
      throw UnsupportedError(
          "wrong node addressed expected module got ${module.name}...");
    }
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          if (!treated.contains("info")) {
            acceptInfo(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "shortinfo") {
          if (!treated.contains("shortinfo")) {
            acceptInfo(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "page") {
          if (!treated.contains("page")) {
            acceptPage(p0, verbose: verbose, buffer: buffer);
          }
        } else {
          valid = false;
          errmsg.write("module unknown stuff: ${p0.runtimeType} $p0\n");
        }
      } else {
        valid = false;
        errmsg.write("module unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptPage(XmlElement pageNode, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if (pageNode.name.toString() != "page") {
      throw UnsupportedError(
          "wrong node addressed expected page got ${pageNode.name}...");
    }
    for (var p0 in pageNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "slide") {
          if (!treated.contains("slide")) {
            //print("treating slides");
            acceptSlide(p0, verbose: verbose, buffer: buffer);
          }
          //else print("refusing slide");
        } else if (value == "title") {
          //print("treating title");
          if (!treated.contains("title")) {
            acceptTitle(p0, verbose: verbose, buffer: buffer);
          }
          //else print("refusing title");
        } else if (value == "section") {
          if (!treated.contains("section")) {
            acceptSection(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "exercise") {
        if (!treated.contains("exercise")) acceptExercise(p0, verbose: verbose, buffer: buffer);
        //else print("refusing exercise");
        //else print("TT acceptPage no exercise");
        } else {
          valid = false;
          errmsg.write("page unknown element: ${p0.runtimeType} $p0\n");
        }
      } else {
        valid = false;
        errmsg.write("page unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptSlide(XmlElement slidNode, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) {
    if (slidNode.name.toString() != "slide") {
      throw UnsupportedError(
          "wrong node addressed expected slide got ${slidNode.name}...");
    }
    for (var p0 in slidNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "section") {
          if (!treated.contains("section")) {
            acceptSection(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "title") {
          if (!treated.contains("title")) {
            acceptTitle(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "subtitle") {
          if (!treated.contains("subtitle")) {
            acceptSubTitle(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "list") {
          if (!treated.contains("list")) {
            acceptList(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "para") {
          if (!treated.contains("para")) {
            acceptPara(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "note") {
          if (!treated.contains("note")) {
            acceptNote(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "exercise") {
          if (!treated.contains("exercise")) {
            acceptExercise(p0, verbose: verbose, buffer: buffer);
          }
        } else {
          valid = false;
          errmsg.write("Slide unknown stuff: ${p0.runtimeType} $p0\n");
        }
      } else {
        valid = false;
        errmsg.write("Slide unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptLevel(XmlElement lvlNode, {bool verbose = false, StringBuffer? buffer}) {
    if (lvlNode.name.toString() != "level") {
      throw UnsupportedError(
          "wrong node addressed expected level got ${lvlNode.name}...");
    }
    lvlNode.getAttribute("value");
    return this;
  }

  @override
  Visitor acceptState(XmlElement stateNode, {bool verbose = false, StringBuffer? buffer}) {
    if (stateNode.name.toString() != "state") {
      throw UnsupportedError(
          "wrong node addressed expected state got ${stateNode.name}...");
    }
    return this;}

  @override
  Visitor acceptDuration(XmlElement durNode, {bool verbose = false, StringBuffer? buffer}) {
    if (durNode.name.toString() != "duration") {
      throw UnsupportedError(
          "wrong node addressed expected duration got ${durNode.name}...");
    }
    durNode.getAttribute("value"); //double
    durNode.getAttribute("unit"); //text
    // TODO: implement acceptDuration
    return this;
  }

  @override
  Visitor acceptPrerequisite(XmlElement prereqNode, {bool verbose = false, StringBuffer? buffer}) {
    if (prereqNode.name.toString() != "prerequisite") {
      throw UnsupportedError(
          "wrong node addressed expected prerequisite got ${prereqNode.name}...");
    }
    for (var node in prereqNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "para") {
        acceptPara(node, verbose: verbose, buffer: buffer);
      } else {
        valid = false;
        errmsg.write("Prerequisite unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptCmd(XmlElement cmdNode, {bool verbose = false, StringBuffer? buffer}) {
    if (cmdNode.name.toString() != "cmd") {
      throw UnsupportedError(
          "wrong node addressed expected cmd got ${cmdNode.name}...");
    }
    for (var p0 in cmdNode.children) {
      if (p0 is XmlText) {
        acceptText(p0, verbose: verbose,buffer: buffer);
      } else {
        print("AAARGGH you put strange stuff into cmd?? $cmdNode");
      }
    }
    return this;
  }

  @override
  Visitor acceptCode(XmlElement codeNode, {bool verbose = false, StringBuffer? buffer}) {
    if (codeNode.name.toString() != "code") {
      throw UnsupportedError(
          "wrong node addressed expected code got ${codeNode.name}...");
    }
    for (var txtnode in codeNode.children) {
      if (txtnode is XmlText) {
        acceptText(txtnode, verbose: verbose,buffer: buffer);
      } else {
        print("AAAARGGGHHH non txt node in Code: $txtnode");
      }
    }
    return this;
  }

  @override
  Visitor acceptEm(XmlElement emNode, {bool verbose = false, StringBuffer? buffer}) {
    if (emNode.name.toString() != "em") {
      throw UnsupportedError(
          "wrong node addressed expected em got ${emNode.name}...");
    }
    for (var txtnode in emNode.children) {
      if (txtnode is XmlText) {
        acceptText(txtnode, verbose: verbose,buffer: buffer);
      } else {
        print("AAAARGGGHHH non txt node in EM: $txtnode");
      }
    }
    return this;
  }

  @override
  Visitor acceptFile(XmlElement fileNode, {bool verbose = false, StringBuffer? buffer}) {
    if (fileNode.name.toString() != "file") {
      throw UnsupportedError(
          "wrong node addressed expected file got ${fileNode.name}...");
    }
    return this;}

  @override
  Visitor acceptImage(XmlElement imgNode, {bool verbose = false, StringBuffer? buffer}) {
    if (imgNode.name.toString() != "image") {
      throw UnsupportedError(
          "wrong node addressed expected img got ${imgNode.name}...");
    }
    String src = imgNode.getAttribute("src") ?? "";
    //String scale = node.getAttribute("src")??"";
    if (src.isEmpty) {
      valid = false;
      errmsg.write("image: src is empty");
    }
    for (var node in imgNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "legend") {
        acceptLegend(node, verbose: verbose,buffer:buffer);
      } else {
        valid = false;
        errmsg.write("Image unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptMenu(XmlElement menNode, {bool verbose = false, StringBuffer? buffer}) {
    if (menNode.name.toString() != "menu") {
      throw UnsupportedError(
          "wrong node addressed expected menu got ${menNode.name}...");
    }

    for (var p0 in menNode.children) {
      if (p0 is XmlText) {
        acceptText(p0, verbose: verbose, buffer:buffer);
      } else {
        print("AAARGGH you put strange stuff into cmd?? $menNode");
      }
    }
    return this;
  }

  @override
  Visitor acceptTable(XmlElement tblNode, {bool verbose = false,StringBuffer? buffer}) {
    if (tblNode.name.toString() != "table") {
      throw UnsupportedError(
          "wrong node addressed expected table got ${tblNode.name}...");
    }
    for (var node in tblNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "row") {
        acceptRow(node, verbose: verbose,buffer: buffer);
      } else {
        valid = false;
        errmsg.write("Table unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptUrl(XmlElement urlNode, {bool verbose = false, StringBuffer? buffer}) {
    if (urlNode.name.toString() != "url") {
      throw UnsupportedError(
          "wrong node addressed expected url got ${urlNode.name}...");
    }
    String href = urlNode.getAttribute("href") ?? "";
    if (href.isEmpty) {
      valid = false;
      errmsg.write("url: href is empty");
    }
    return this;
  }

  @override
  Visitor acceptLegend(XmlElement legNode, {bool verbose = false, StringBuffer? buffer}) {
    if (legNode.name.toString() != "legend") {
      throw UnsupportedError(
          "wrong node addressed expected title got ${legNode.name}...");
    }
    for (var node in legNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose,buffer: buffer);
      } else {
        print("found in legend spurious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptCol(XmlElement colNode, {bool verbose = false, StringBuffer? buffer}) {
    if (colNode.name.toString() != "col") {
      throw UnsupportedError(
          "wrong node addressed expected col got ${colNode.name}...");
    }
    for (var node in colNode.children) {
      if (node is XmlElement) {
        acceptPara(node, verbose: verbose,buffer: buffer);
      } else if (node is XmlText) {
        acceptText(node, verbose: verbose,buffer:buffer );
      } else {
        valid = false;
        errmsg.write("Table Col unknown stuff: ${node.runtimeType} $node\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptRow(XmlElement rowNode, {bool verbose = false, StringBuffer? buffer}) {
    if (rowNode.name.toString() != "row") {
      throw UnsupportedError(
          "wrong node addressed expected row got ${rowNode.name}...");
    }
    for (var node in rowNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "col") {
        acceptCol(node, verbose: verbose,buffer: buffer);
      } else {
        valid = false;
        errmsg.write("Table Row unknown stuff: ${node.runtimeType} $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptExercise(XmlElement exNode, {bool verbose = false, StringBuffer? buffer}) {
    if (exNode.name.toString() != "exercise") {
      throw UnsupportedError(
          "wrong node addressed expected exercise got ${exNode.name}...");
    }
    for (var p0 in exNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "question") {
          acceptQuestion(p0, verbose: verbose, buffer: buffer);
        } else if (value == "answer") {
          acceptAnswer(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg.write("exercise unknown stuff: ${p0.runtimeType} $p0\n");
        }
      } else {
        valid = false;
        errmsg.write("exercise unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptList(XmlElement listNode, {bool verbose = false, StringBuffer? buffer}) {
    if (listNode.name.toString() != "list") {
      throw UnsupportedError(
          "wrong node addressed expected list got ${listNode.name}...");
    }
    for (var p0 in listNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "item") {
          acceptItem(p0, verbose: verbose,buffer: buffer );
        } else {
          valid = false;
          errmsg.write("List unknown stuff: ${p0.runtimeType} $p0\n");
        }
      } else {
        valid = false;
        errmsg.write("List unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptNote(XmlElement notNode, {bool verbose = false, StringBuffer? buffer}) {
    if (notNode.name.toString() != "note") {
      throw UnsupportedError(
          "wrong node addressed expected note got ${notNode.name}...");
    }
    for (var p0 in notNode.children) {
      if (p0 is XmlText) {
        acceptText(p0, verbose: verbose,buffer: buffer);
      } else {
        print("AAARGGH you put strange stuff into note?? $notNode");
      }
    }
    return this;
  }

  @override
  Visitor acceptSection(XmlElement secNode, {bool verbose = false, int level = 0, StringBuffer? buffer, List<String> treated =const []}) {
    if (secNode.name.toString() != "section") {
      throw UnsupportedError(
          "wrong node addressed expected section got ${secNode.name}...");
    }
    for (var p0 in secNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      //print("tt sec lvl: $level child[$value]: $p0");
      if (p0 is XmlElement) {
        if (value == "title") {
          //print("tt sec title lvl: $level child: $p0");
          if (!treated.contains("title")) {
            acceptTitle(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "section") {
          if (!treated.contains("section")) {
            acceptSection(p0, verbose: verbose, level: level + 1, buffer: buffer);
          }
        } else if (value == "para") {
          //print("tt sec para lvl: $level child: $p0");
          if (!treated.contains("para")) {
            acceptPara(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "note") {
         // print("tt sec note lvl: $level child: $p0");
          if (!treated.contains("note")) {
            acceptNote(p0, verbose: verbose, buffer: buffer);
          }
        } else if (value == "exercise") {
          //print("tt sec exercise lvl: $level child: $p0");
          if (!treated.contains("exercise")) {
            acceptExercise(p0, verbose: verbose, buffer: buffer);
          }
        } else {
          valid = false;
          errmsg.write("Section unknown element: ${p0.runtimeType} $p0\n");
        }
      } else {
        valid = false;
        errmsg.write("Section unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptSubTitle(XmlElement subtitle, {bool verbose = false, StringBuffer? buffer}) {
    if (subtitle.name.toString() != "subtitle") {
      throw UnsupportedError(
          "wrong node addressed expected title got ${subtitle.name}...");
    }
    for (var node in subtitle.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in subtitle spurious stuff $node");
      }
    }
    if(buffer != null) {
      String cleaned = buffer.toString().trim();
      buffer.clear();
      buffer.write(cleaned);
    }
    return this;
  }

  @override
  Visitor acceptText(XmlText txtNode, {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    // TODO: implement acceptText
    return this;
  }

  @override
  Visitor acceptMath(XmlElement mathNode, {bool verbose = false, StringBuffer? buffer}) {

    if (mathNode.name.toString() != "math") {
      throw UnsupportedError(
          "wrong node addressed expected math got ${mathNode.name}...");
    }
    String notation = mathNode.getAttribute("notation") ?? "html";
    for (var txtnode in mathNode.children) {
      if (txtnode is XmlText && notation == "html") {
        acceptText(txtnode, verbose: verbose,buffer: buffer);
      } else if (txtnode is XmlCDATA && notation == "tex")
        { acceptCDATA(txtnode, verbose: verbose,buffer: buffer);}
      else {
        print("AAAARGGGHHH non '$notation' vs  in Math: $txtnode ${txtnode
            .runtimeType}");
      }
    }
    return this;
  }

  @override
  Visitor acceptAnswer(XmlElement answNode, {bool verbose = false, StringBuffer? buffer}) {
    if (answNode.name.toString() != "answer") {
      throw UnsupportedError(
          "wrong node addressed expected answer got ${answNode.name}...");
    }
    for (var p0 in answNode.children) {
      String value = (p0 is XmlElement)
          ? p0.name.toString()
          : (p0 is XmlText)
          ? "txt"
          : "node";
      if (p0 is XmlElement) {
        if (value == "para") {
          acceptPara(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg.write("answer unknown element: ${p0.runtimeType} $p0\n");
        }
      } else if (p0 is XmlText) {
        acceptText(p0, verbose: verbose, buffer: buffer);
      } else {
        valid = false;
        errmsg.write("answer unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    // TODO: implement acceptAnswer
    return this;
  }

  @override
  Visitor acceptQuestion(XmlElement questNode, {bool verbose = false, StringBuffer? buffer}) {
    if (questNode.name.toString() != "question") {
      throw UnsupportedError(
          "wrong node addressed expected questNode got ${questNode.name}...");
    }
    for (var p0 in questNode.children) {
      String value = (p0 is XmlElement)? p0.name.toString() : (p0 is XmlText)? "txt" : "node";
      if (p0 is XmlText) { acceptText(p0, verbose: verbose, buffer: buffer);}
    else if (p0 is XmlElement) {
        if (value == "para") {
          acceptPara(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg.write("question unknown element: ${p0.runtimeType} $p0\n");
        }
      }  else {
        valid = false;
        errmsg.write("question unknown stuff: ${p0.runtimeType} $p0\n");
      }
    }
    return this;
  }

  @override
  Visitor acceptGlossary(XmlElement gloNode, {bool verbose = false, StringBuffer? buffer}) {
    if (gloNode.name.toString() != "glossary") {
      throw UnsupportedError(
          "wrong node addressed expected glossary got ${gloNode.name}...");
    }
    for (var node in gloNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer:buffer);
      } else {
        print("found in glosNode spurious stuff $node");
      }
    }
    // TODO: implement acceptGlossary
    return this;
  }

  Visitor acceptCDATA(XmlCDATA cnode, {required bool verbose, StringBuffer? buffer}) {
   for (var p0 in cnode.children) {
     print("CDATA children: '${p0.value}' ${p0.innerText} ${p0.runtimeType} ");
   }
    return this;
  }
}
