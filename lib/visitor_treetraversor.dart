import 'package:logidee_tools/visitor.dart';
import 'package:xml/xml.dart';

class VisitorTreeTraversor extends Visitor {
  VisitorTreeTraversor({String? charte, bool? trainer, String? selection, String? lang, bool? cycle}):super( charte:charte, trainer: trainer, selection: selection, lang: lang, cycle: cycle);

  @override
  Visitor acceptFormation(XmlElement formation, {bool verbose = false, StringBuffer? buffer}) {
    if (formation.name.toString() != "formation") {
      throw UnsupportedError(
        "wrong node adressed expected formation got ${formation.name}...");
    }
    for (var p0 in formation.children) {
      //(p0 is XmlElement)? errmsg += "formation child: ${p0.name.toString()}"):errmsg += "formation unknown: $p0 of ${p0.runtimeType}");
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
        errmsg += "formation unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptInfo(XmlElement info, {bool verbose = false, StringBuffer? buffer}) {
    if (!(info.name.toString() == "info" || info.name.toString() == "shortinfo")) {
      throw UnsupportedError(
        "wrong node adressed expected info got ${info.name}...");
    }
    for (var p0 in info.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "title") {
          acceptTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "subtitle") {
          acceptSubTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "ref") {
          acceptRef(p0, verbose: verbose, buffer: buffer);
        } else if (value == "description") {
          acceptDescription(p0, verbose: verbose, buffer: buffer);
        } else if (value == "objectives") {
          acceptObjectives(p0, verbose: verbose, buffer: buffer);
        } else if (value == "ratio") {
          acceptRatio(p0, verbose: verbose, buffer: buffer);
        } else if (value == "duration") {
          acceptDuration(p0, verbose: verbose, buffer: buffer);
        } else if (value == "prerequisite") {
          acceptPrerequisite(p0, verbose: verbose, buffer: buffer);
        } else if (value == "dependency") {
          acceptDependency(p0, verbose: verbose, buffer: buffer);
        } else if (value == "suggestion") {
          acceptSuggestion(p0, verbose: verbose, buffer: buffer);
        } else if (value == "version") {
          acceptVersion(p0, verbose: verbose, buffer: buffer);
        } else if (value == "level") {
          acceptLevel(p0, verbose: verbose, buffer: buffer);
        } else if (value == "state") {
          acceptState(p0, verbose: verbose, buffer: buffer);
        } else if (value == "proofreaders") {
          acceptProofreaders(p0, verbose: verbose, buffer: buffer);
        } else {
          errmsg += "info unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "info unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptTheme(XmlElement theme, {bool verbose = false, StringBuffer? buffer}) {
    if (theme.name.toString() != "theme") {
      throw UnsupportedError(
        "wrong node adressed expected theme got ${theme.name}...");
    }
    for (var p0 in theme.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "module") {
          acceptModule(p0, verbose: verbose, buffer: buffer);
        } else if (value == "slideshow") {
          acceptSlideShow(p0, verbose: verbose, buffer: buffer);
        }
      } else {
        valid = false;
        errmsg += "Theme unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptTitle(XmlElement title, {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    if (title.name.toString() != "title") {
      throw UnsupportedError(
        "wrong node adressed expected title got ${title.name}...");
    }
    for (var node in title.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in title spourious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptDescription(XmlElement desc, {bool verbose = false, StringBuffer? buffer}) {
    if (desc.name.toString() != "description") {
      throw UnsupportedError(
          "wrong node adressed expected description got ${desc.name}...");
    }
    for (var node in desc.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "para") {
          acceptPara(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg += "Description unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Description unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptObjectives(XmlElement object, {bool verbose = false, StringBuffer? buffer}) {
    if (object.name.toString() != "objectives") {
      throw UnsupportedError(
          "wrong node adressed expected objectives got ${object.name}...");
    }
    for (var node in object.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "item") {
          acceptItem(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg += "Objectives unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Objectives unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptDependency(XmlElement dependency, {bool verbose = false, StringBuffer? buffer}) {
    if (dependency.name.toString() != "dependency") {
      throw UnsupportedError(
          "wrong node adressed expected dependency got ${dependency.name}...");
    }
    for (var node in dependency.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "ref") {
          acceptRef(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg += "Dependency unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Dependency unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptSuggestion(XmlElement suggestion, {bool verbose = false, StringBuffer? buffer}) {
if (suggestion.name.toString() != "suggestion") {
  throw UnsupportedError(
      "wrong node adressed expected suggestion got ${suggestion.name}...");
}
    for (var node in suggestion.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "ref") {
          acceptRef(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg += "Suggestion unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Suggestion unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptVersion(XmlElement version, {bool verbose = false, StringBuffer? buffer}) {

    if (version.name.toString() != "version") {
      throw UnsupportedError(
          "wrong node adressed expected version got ${version.name}...");
    }
    String number = version.getAttribute("number") ?? "";
    if (number.isEmpty) {
      valid = false;
      errmsg += "Version tag version needs a number";
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
          errmsg += "Version unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Version unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptProofreaders(XmlElement proofRead, {bool verbose = false, StringBuffer? buffer}) {

    if (proofRead.name.toString() != "proofreaders") {
      throw UnsupportedError(
          "wrong node adressed expected proofreader got ${proofRead.name}...");
    }
    for (var node in proofRead.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "item") {
          acceptItem(node, verbose: verbose, buffer: buffer);
        } else {
          errmsg += "Proofreaders unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Proofreaders unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptRatio(XmlElement ratioNode, {bool verbose = false, StringBuffer? buffer}) {

    if (ratioNode.name.toString() != "ratio") {
      throw UnsupportedError(
          "wrong node adressed expected ratio got ${ratioNode.name}...");
    }
    return this;
  }

  //String icon = module.getAttribute("icon")??""; //para note exercise image link of type
  @override
  Visitor acceptPara(XmlElement paraNode,
      {bool verbose = false, String tag = "Para", StringBuffer? buffer}) {
    if (paraNode.name.toString() != "para") {
      throw UnsupportedError(
          "wrong node ?? expected para got  ${paraNode.name}...");
    }
    for (var subnode in paraNode.children) {
      //print("acceptPara child loop treating $node of ${node.runtimeType}");
      if (subnode is XmlText) {
        acceptText(subnode, verbose: verbose,buffer: buffer);
      } else if (subnode is XmlElement) {
        if (subnode.name.toString() == "url") {
          acceptUrl(
            subnode,
            verbose: verbose,buffer: buffer
          );
        } else if (subnode.name.toString() == "image") {
          acceptImage(
            subnode,
            verbose: verbose,buffer: buffer
          );
        } else if (subnode.name.toString() == "list") {
          //print("acceptPara calling acceptList $node of ${node.runtimeType}");
          acceptList(subnode, verbose: verbose,buffer: buffer);
        } else if (subnode.name.toString() == "em") {
          acceptEm(subnode, verbose: verbose,buffer: buffer);
        } else if (subnode.name.toString() == "cmd") {
          acceptCmd(
            subnode,
            verbose: verbose,buffer: buffer
          );
        } else if (subnode.name.toString() == "menu") {
          acceptMenu(
            subnode,
            verbose: verbose,buffer: buffer
          );
        } else if (subnode.name.toString() == "file") {
          acceptFile(
            subnode,
            verbose: verbose,buffer: buffer
          );
        } else if (subnode.name.toString() == "code") {
          acceptCode(
            subnode,
            verbose: verbose,buffer: buffer
          );
        } else if (subnode.name.toString() == "table") {
          acceptTable(subnode, verbose: verbose,buffer: buffer);
        } else if (subnode.name.toString() == "math") {
          acceptMath(subnode, verbose: verbose,buffer: buffer);
        } else if (subnode.name.toString() == "glossary") {
          acceptGlossary(subnode, verbose: verbose,buffer: buffer);
        } else if (subnode.name.toString() == "note") {
          acceptNote(subnode, verbose: verbose,buffer: buffer);
        } else{
          errmsg += "parsing paragraph unknown element ${subnode.name}\n";
          valid = false;
        }
      } else {
        errmsg += "parsing paragraph unknown  ${subnode.runtimeType}\n";
        valid = false;
      }
    }
return this;
  }

  @override
  Visitor acceptItem(XmlElement itemNode, {bool verbose = false, StringBuffer? buffer}) {

    if (itemNode.name.toString() != "item") {
      throw UnsupportedError(
          "wrong node adressed expected item got ${itemNode.name}...");
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
          errmsg += "Item unknown element: ${p0.runtimeType} $p0\n";
        }

      } else {
        valid = false;
        errmsg += "Item unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptRef(XmlElement refNode, {bool verbose = false, StringBuffer? buffer}) {
    if (refNode.name.toString() != "ref") {
      throw UnsupportedError(
          "wrong node adressed expected ref ${refNode.name}...");
    }
    for (var node in refNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in ref spourious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptAuthor(XmlElement authorNode, {bool verbose = false, StringBuffer? buffer}) {
    if (authorNode.name.toString() != "author") {
      throw UnsupportedError(
        "wrong node adressed expected author got ${authorNode.name}...");
    }
    for (var node in authorNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in author spourious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptEmail(XmlElement mailNode, {bool verbose = false, StringBuffer? buffer})
  {
    if (mailNode.name.toString() != "email") {
      throw UnsupportedError(
          "wrong node adressed expected email got ${mailNode.name}...");
    }
    for (var node in mailNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose,buffer: buffer);
      } else {
        print("found in email spourious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptComment(XmlElement cmtNode, {bool verbose = false, StringBuffer? buffer}) {
    if (cmtNode.name.toString() != "comment") {
      throw UnsupportedError(
          "wrong node adressed expected comment got ${cmtNode.name}...");
    }
    return this;}

  @override
  Visitor acceptDate(XmlElement dateNode, {bool verbose = false, StringBuffer? buffer}) {
    if (dateNode.name.toString() != "date") {
      throw UnsupportedError(
        "wrong node adressed expected date got ${dateNode.name}...");
    }
    for (var node in dateNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in date spourious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptSlideShow(XmlElement show, {bool verbose = false, StringBuffer? buffer}) {
    if (show.name.toString() != "slideshow") {
      throw UnsupportedError(
          "wrong node adressed expected slideshow got ${show.name}...");
    }
    for (var p0 in show.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "slide") {
          acceptSlide(p0, verbose: verbose, buffer: buffer);
        }
      } else {
        valid = false;
        errmsg += "SlideShow unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptModule(XmlElement module, {bool verbose = false, StringBuffer? buffer}) {
    if (module.name.toString() != "module") {
      throw UnsupportedError(
          "wrong node adressed expected module got ${module.name}...");
    }
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose, buffer: buffer);
        } else if (value == "page") {
          acceptPage(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg += "module unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "module unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptPage(XmlElement pageNode, {bool verbose = false, StringBuffer? buffer}) {
    if (pageNode.name.toString() != "page") {
      throw UnsupportedError(
          "wrong node adressed expected page got ${pageNode.name}...");
    }
    for (var p0 in pageNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "slide") {
          acceptSlide(p0, verbose: verbose, buffer: buffer);
        } else if (value == "title") {
          acceptTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "section") {
          acceptSection(p0, verbose: verbose, buffer: buffer);
        } else if (value == "exercise") {
          acceptExercise(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg += "page unknown element: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "page unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptSlide(XmlElement slidNode, {bool verbose = false, StringBuffer? buffer}) {
    if (slidNode.name.toString() != "slide") {
      throw UnsupportedError(
          "wrong node adressed expected slide got ${slidNode.name}...");
    }
    for (var p0 in slidNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "section") {
          acceptSection(p0, verbose: verbose, buffer: buffer);
        } else if (value == "title") {
          acceptTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "subtitle") {
          acceptSubTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "list") {
          acceptList(p0, verbose: verbose, buffer: buffer);
        } else if (value == "para") {
          acceptPara(p0, verbose: verbose, buffer: buffer);
        } else if (value == "note") {
          acceptNote(p0, verbose: verbose, buffer: buffer);
        } else if (value == "exercise") {
          acceptExercise(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg += "Slide unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "Slide unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptLevel(XmlElement lvlNode, {bool verbose = false, StringBuffer? buffer}) {
    if (lvlNode.name.toString() != "level") {
      throw UnsupportedError(
          "wrong node adressed expected level got ${lvlNode.name}...");
    }
    lvlNode.getAttribute("value");
    return this;
  }

  @override
  Visitor acceptState(XmlElement stateNode, {bool verbose = false, StringBuffer? buffer}) {
    if (stateNode.name.toString() != "state") {
      throw UnsupportedError(
          "wrong node adressed expected state got ${stateNode.name}...");
    }
    return this;}

  @override
  Visitor acceptDuration(XmlElement durNode, {bool verbose = false, StringBuffer? buffer}) {
    if (durNode.name.toString() != "duration") {
      throw UnsupportedError(
          "wrong node adressed expected duration got ${durNode.name}...");
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
          "wrong node adressed expected prereqation got ${prereqNode.name}...");
    }
    for (var node in prereqNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "para") {
        acceptPara(node, verbose: verbose, buffer: buffer);
      } else {
        valid = false;
        errmsg += "Prerequisite unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptCmd(XmlElement cmdNode, {bool verbose = false, StringBuffer? buffer}) {
    if (cmdNode.name.toString() != "cmd") {
      throw UnsupportedError(
          "wrong node adressed expected cmd got ${cmdNode.name}...");
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
          "wrong node adressed expected code got ${codeNode.name}...");
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
          "wrong node adressed expected em got ${emNode.name}...");
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
          "wrong node adressed expected file got ${fileNode.name}...");
    }
    return this;}

  @override
  Visitor acceptImage(XmlElement imgNode, {bool verbose = false, StringBuffer? buffer}) {
    if (imgNode.name.toString() != "image") {
      throw UnsupportedError(
          "wrong node adressed expected img got ${imgNode.name}...");
    }
    String src = imgNode.getAttribute("src") ?? "";
    //String scale = node.getAttribute("src")??"";
    if (src.isEmpty) {
      valid = false;
      errmsg += "image: src is empty";
    }
    for (var node in imgNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "legend") {
        acceptLegend(node, verbose: verbose,buffer:buffer);
      } else {
        valid = false;
        errmsg += "Image unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptMenu(XmlElement menNode, {bool verbose = false, StringBuffer? buffer}) {
    if (menNode.name.toString() != "menu") {
      throw UnsupportedError(
          "wrong node adressed expected menu got ${menNode.name}...");
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
          "wrong node adressed expected table got ${tblNode.name}...");
    }
    for (var node in tblNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "row") {
        acceptRow(node, verbose: verbose,buffer: buffer);
      } else {
        valid = false;
        errmsg += "Table unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptUrl(XmlElement urlNode, {bool verbose = false, StringBuffer? buffer}) {
    if (urlNode.name.toString() != "url") {
      throw UnsupportedError(
          "wrong node adressed expected url got ${urlNode.name}...");
    }
    String href = urlNode.getAttribute("href") ?? "";
    if (href.isEmpty) {
      valid = false;
      errmsg += "url: href is empty";
    }
    return this;
  }

  @override
  Visitor acceptLegend(XmlElement legNode, {bool verbose = false, StringBuffer? buffer}) {
    if (legNode.name.toString() != "legend") {
      throw UnsupportedError(
          "wrong node adressed expected title got ${legNode.name}...");
    }
    for (var node in legNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose,buffer: buffer);
      } else {
        print("found in legend spourious stuff $node");
      }
    }
    return this;
  }

  @override
  Visitor acceptCol(XmlElement colNode, {bool verbose = false, StringBuffer? buffer}) {
    if (colNode.name.toString() != "col") {
      throw UnsupportedError(
          "wrong node adressed expected col got ${colNode.name}...");
    }
    for (var node in colNode.children) {
      if (node is XmlElement) {
        acceptPara(node, verbose: verbose,buffer: buffer);
      } else if (node is XmlText) {
        acceptText(node, verbose: verbose,buffer:buffer );
      } else {
        valid = false;
        errmsg += "Table Col unknown stuff: ${node.runtimeType} $node\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptRow(XmlElement rowNode, {bool verbose = false, StringBuffer? buffer}) {
    if (rowNode.name.toString() != "row") {
      throw UnsupportedError(
          "wrong node adressed expected row got ${rowNode.name}...");
    }
    for (var node in rowNode.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "col") {
        acceptCol(node, verbose: verbose,buffer: buffer);
      } else {
        valid = false;
        errmsg += "Table Row unknown stuff: ${node.runtimeType} $node";
      }
    }
    return this;
  }

  @override
  Visitor acceptExercise(XmlElement exNode, {bool verbose = false, StringBuffer? buffer}) {
    if (exNode.name.toString() != "exercise") {
      throw UnsupportedError(
          "wrong node adressed expected exercise got ${exNode.name}...");
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
          errmsg += "exercise unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "exercise unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptList(XmlElement listNode, {bool verbose = false, StringBuffer? buffer}) {
    if (listNode.name.toString() != "list") {
      throw UnsupportedError(
          "wrong node adressed expected list got ${listNode.name}...");
    }
    for (var p0 in listNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "item") {
          acceptItem(p0, verbose: verbose,buffer: buffer );
        } else {
          valid = false;
          errmsg += "List unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "List unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptNote(XmlElement notNode, {bool verbose = false, StringBuffer? buffer}) {
    if (notNode.name.toString() != "note") {
      throw UnsupportedError(
          "wrong node adressed expected note got ${notNode.name}...");
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
  Visitor acceptSection(XmlElement secNode, {bool verbose = false, int level = 0, StringBuffer? buffer}) {
    if (secNode.name.toString() != "section") {
      throw UnsupportedError(
          "wrong node adressed expected section got ${secNode.name}...");
    }
    for (var p0 in secNode.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      //print("tt sec lvl: $level child[$value]: $p0");
      if (p0 is XmlElement) {
        if (value == "title") {
          //print("tt sec title lvl: $level child: $p0");
          acceptTitle(p0, verbose: verbose, buffer: buffer);
        } else if (value == "section") {
          //print("tt sec section lvl: $level child: $p0");
          //if (level == 0) {
            acceptSection(p0, verbose: verbose, level: level + 1, buffer: buffer);
          //} else {
          //  valid = false;
          //  errmsg += "Section too deep indentation: ${p0.runtimeType} $p0\n";
          //}
        } else if (value == "para") {
          //print("tt sec para lvl: $level child: $p0");
          acceptPara(p0, verbose: verbose, buffer: buffer);
        } else if (value == "note") {
         // print("tt sec note lvl: $level child: $p0");
          acceptNote(p0, verbose: verbose, buffer: buffer);
        } else if (value == "exercise") {
          //print("tt sec exerc lvl: $level child: $p0");
          acceptExercise(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg += "Section unknown element: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "Section unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptSubTitle(XmlElement subtitle, {bool verbose = false, StringBuffer? buffer}) {
    if (subtitle.name.toString() != "subtitle") {
      throw UnsupportedError(
          "wrong node adressed expected title got ${subtitle.name}...");
    }
    for (var node in subtitle.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer: buffer);
      } else {
        print("found in subtitle spourious stuff $node");
      }
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
          "wrong node adressed expected math got ${mathNode.name}...");
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
          "wrong node adressed expected answer got ${answNode.name}...");
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
          errmsg += "answer unknown element: ${p0.runtimeType} $p0\n";
        }
      } else if (p0 is XmlText) {
        acceptText(p0, verbose: verbose, buffer: buffer);
      } else {
        valid = false;
        errmsg += "answer unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    // TODO: implement acceptAnswer
    return this;
  }

  @override
  Visitor acceptQuestion(XmlElement questNode, {bool verbose = false, StringBuffer? buffer}) {
    if (questNode.name.toString() != "question") {
      throw UnsupportedError(
          "wrong node adressed expected questNode got ${questNode.name}...");
    }
    for (var p0 in questNode.children) {
      String value = (p0 is XmlElement)? p0.name.toString() : (p0 is XmlText)? "txt" : "node";
      if (p0 is XmlText) { acceptText(p0, verbose: verbose, buffer: buffer);}
    else if (p0 is XmlElement) {
        if (value == "para") {
          acceptPara(p0, verbose: verbose, buffer: buffer);
        } else {
          valid = false;
          errmsg += "question unknown element: ${p0.runtimeType} $p0\n";
        }
      }  else {
        valid = false;
        errmsg += "question unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    return this;
  }

  @override
  Visitor acceptGlossary(XmlElement gloNode, {bool verbose = false, StringBuffer? buffer}) {
    if (gloNode.name.toString() != "glossary") {
      throw UnsupportedError(
          "wrong node adressed expected glossary got ${gloNode.name}...");
    }
    for (var node in gloNode.children) {
      if (node is XmlText) {
        acceptText(node, verbose: verbose, buffer:buffer);
      } else {
        print("found in glosNode spourious stuff $node");
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
