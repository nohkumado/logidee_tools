import 'package:logidee_tools/visitor.dart';
import 'package:xml/xml.dart';

class VisitorTreeTraversor extends Visitor {
  @override
  acceptFormation(XmlElement formation, {bool verbose = false}) {
    if(formation.name.toString() != "formation") throw UnsupportedError("wrong node adressed expected formation got ${formation.name}...");
    for (var p0 in formation.children) {
      //(p0 is XmlElement)? errmsg += "formation child: ${p0.name.toString()}"):errmsg += "formation unknown: $p0 of ${p0.runtimeType}");
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "theme") {
          acceptTheme(p0, verbose: verbose);
        }
      } else {
        valid = false;
        errmsg += "formation unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptInfo(XmlElement info, {bool verbose = false}) {
    if(info.name.toString() != "info") throw UnsupportedError("wrong node adressed expected info got ${info.name}...");
    for (var p0 in info.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "title") {
          acceptTitle(p0, verbose: verbose);
        } else if (value == "ref") {
          acceptRef(p0, verbose: verbose);
        } else if (value == "description") {
          acceptDescription(p0, verbose: verbose);
        } else if (value == "objectives") {
          acceptObjectives(p0, verbose: verbose);
        } else if (value == "ratio") {
          acceptRatio(p0, verbose: verbose);
        } else if (value == "duration") {
          acceptDuration(p0, verbose: verbose);
        } else if (value == "prerequisite") {
          acceptPrerequisite(p0, verbose: verbose);
        } else if (value == "dependency") {
          acceptDependency(p0, verbose: verbose);
        } else if (value == "suggestion") {
          acceptSuggestion(p0, verbose: verbose);
        } else if (value == "version") {
          acceptVersion(p0, verbose: verbose);
        } else if (value == "level") {
          acceptLevel(p0, verbose: verbose);
        } else if (value == "state") {
          acceptState(p0, verbose: verbose);
        } else if (value == "proofreaders") {
          acceptProofreaders(p0, verbose: verbose);
        } else {
          errmsg += "info unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "info unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptTheme(XmlElement theme, {bool verbose = false}) {
    if(theme.name.toString() != "theme") throw UnsupportedError("wrong node adressed expected theme got ${theme.name}...");
    for (var p0 in theme.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "module") {
          acceptModule(p0, verbose: verbose);
        } else if (value == "slideshow") {
          acceptSlideShow(p0, verbose: verbose);
        }
      } else {
        valid = false;
        errmsg += "Theme unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptTitle(XmlElement title, {bool verbose = false, bool add= true}) {
    if(title.name.toString() != "title") throw UnsupportedError("wrong node adressed expected title got ${title.name}...");
    for (var node in title.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if(node is XmlText) acceptText(node as XmlText, verbose: verbose);
      else print("found in title spourious stuff $node");
    }
  }

  @override
  void acceptDescription(XmlElement desc, {bool verbose = false}) {
    for (var node in desc.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "para") {
          acceptPara(node, verbose: verbose);
        } else {
          errmsg += "Description unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Description unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptObjectives(XmlElement object, {bool verbose = false}) {
    for (var node in object.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "item") {
          acceptItem(node, verbose: verbose);
        } else {
          errmsg += "Objectives unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Objectives unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptDependency(XmlElement dependency, {bool verbose = false}) {
    for (var node in dependency.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "ref") {
          acceptRef(node, verbose: verbose);
        } else {
          errmsg += "Dependency unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Dependency unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptSuggestion(XmlElement suggestion, {bool verbose = false}) {
    for (var node in suggestion.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "ref") {
          acceptRef(node, verbose: verbose);
        } else {
          errmsg += "Suggestion unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Suggestion unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptVersion(XmlElement version, {bool verbose = false}) {
    String number = version.getAttribute("number") ?? "";
    if (number.isEmpty) {
      valid = false;
      errmsg += "Version tag version needs a number";
    }
    for (var node in version.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "author") {
          acceptAuthor(node, verbose: verbose);
        } else if (value == "email") {
          acceptEmail(node, verbose: verbose);
        } else if (value == "comment") {
          acceptComment(node, verbose: verbose);
        } else if (value == "date") {
          acceptDate(node, verbose: verbose);
        } else {
          errmsg += "Version unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Version unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptProofreaders(XmlElement node, {bool verbose = false}) {
    for (var node in node.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement) {
        if (value == "item") {
          acceptItem(node, verbose: verbose);
        } else {
          errmsg += "Proofreaders unknown stuff: ${node.runtimeType} $node";
        }
      } else {
        valid = false;
        errmsg += "Proofreaders unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptRatio(XmlElement node, {bool verbose = false}) {}

  //String icon = module.getAttribute("icon")??""; //para note exercise image link of type
  @override
  void acceptPara(XmlElement node,
      {bool verbose = false, String tag = "Para"}) {
    for (var subnode in node.children) {
      //print("acceptPara child loop treating $node of ${node.runtimeType}");
      if (subnode is XmlText) {
        acceptText(subnode, verbose: verbose);
      } else if (subnode is XmlElement) {
        if (subnode.name.toString() == "url") {
          acceptUrl(
            subnode,
            verbose: verbose,
          );
        } else if (subnode.name.toString() == "image") {
          acceptImage(
            subnode,
            verbose: verbose,
          );
        } else if (subnode.name.toString() == "list") {
          //print("acceptPara calling acceptList $node of ${node.runtimeType}");
          acceptList(subnode, verbose: verbose);
        } else if (subnode.name.toString() == "em") {
          acceptEm(subnode, verbose: verbose);
        } else if (subnode.name.toString() == "cmd") {
          acceptCmd(
            subnode,
            verbose: verbose,
          );
        } else if (subnode.name.toString() == "menu") {
          acceptMenu(
            subnode,
            verbose: verbose,
          );
        } else if (subnode.name.toString() == "file") {
          acceptFile(
            subnode,
            verbose: verbose,
          );
        } else if (subnode.name.toString() == "code") {
          acceptCode(
            subnode,
            verbose: verbose,
          );
        } else if (subnode.name.toString() == "table") {
          acceptTable(subnode, verbose: verbose);
        } else if (subnode.name.toString() == "math") {
          acceptMath(subnode, verbose: verbose);
        } else if (subnode.name.toString() == "glossary") {
          acceptGlossary(subnode, verbose: verbose);
        } else {
          errmsg += "parsing paragraph unknown element ${subnode.name}\n";
          valid = false;
        }
      } else {
        errmsg += "parsing paragraph unknown  ${subnode.runtimeType}\n";
        valid = false;
      }
    }
  }

  @override
  void acceptItem(XmlElement node, {bool verbose = false}) {
    for (var p0 in node.children) {
      String value = (p0 is XmlElement)
          ? p0.name.toString()
          : (p0 is XmlText)
              ? "txt"
              : "node";
      if (p0 is XmlElement) {
        if (value == "txt") {
          acceptPara(p0, verbose: verbose, tag: "Item-para");
        } else if (value == "para") {
          acceptPara(p0, verbose: verbose);
        } else if (value == "list") {
          acceptList(p0, verbose: verbose);
        } else if (value == "cmd") {
          acceptCmd(p0, verbose: verbose);
        } else if (value == "url") {
          acceptUrl(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "Item unknown element: ${p0.runtimeType} $p0\n";
        }
      } else if (p0 is XmlText) {
        acceptText(p0, verbose: verbose);
      } else {
        valid = false;
        errmsg += "Item unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptRef(XmlElement node, {bool verbose = false}) {}

  @override
  void acceptAuthor(XmlElement node, {bool verbose = false}) {
    if(node.name.toString() != "author") throw UnsupportedError("wrong node adressed expected author got ${node.name}...");
    for (var node in node.children) {
      if(node is XmlText) acceptText(node as XmlText, verbose: verbose);
      else print("found in author spourious stuff $node");
    }
  }

  @override
  void acceptEmail(XmlElement node, {bool verbose = false}) {}

  @override
  void acceptComment(XmlElement node, {bool verbose = false}) {}

  @override
  void acceptDate(XmlElement node, {bool verbose = false}) {
    if(node.name.toString() != "date") throw UnsupportedError("wrong node adressed expected date got ${node.name}...");
    for (var node in node.children) {
      if(node is XmlText) acceptText(node as XmlText, verbose: verbose);
      else print("found in date spourious stuff $node");
    }
  }

  @override
  void acceptSlideShow(XmlElement show, {bool verbose = false}) {
    for (var p0 in show.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "slide") {
          acceptSlide(p0, verbose: verbose);
        }
      } else {
        valid = false;
        errmsg += "SlideShow unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptModule(XmlElement module, {bool verbose = false}) {
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "info") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "shortinfo") {
          acceptInfo(p0, verbose: verbose);
        } else if (value == "page") {
          acceptPage(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "module unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "module unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptPage(XmlElement module, {bool verbose = false}) {
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "slide") {
          acceptSlide(p0, verbose: verbose);
        } else if (value == "title") {
          acceptTitle(p0, verbose: verbose);
        } else if (value == "section") {
          acceptSection(p0, verbose: verbose);
        } else if (value == "exercise") {
          acceptExercice(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "page unknown element: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "page unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptSlide(XmlElement module, {bool verbose = false}) {
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "section") {
          acceptSection(p0, verbose: verbose);
        } else if (value == "title") {
          acceptTitle(p0, verbose: verbose);
        } else if (value == "subtitle") {
          acceptSubTitle(p0, verbose: verbose);
        } else if (value == "list") {
          acceptList(p0, verbose: verbose);
        } else if (value == "para") {
          acceptPara(p0, verbose: verbose);
        } else if (value == "note") {
          acceptNote(p0, verbose: verbose);
        } else if (value == "exercise") {
          acceptExercice(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "Slide unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "Slide unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptLevel(XmlElement node, {bool verbose = false}) {
    node.getAttribute("value");
  }

  @override
  void acceptState(XmlElement node, {bool verbose = false}) {}

  @override
  void acceptDuration(XmlElement node, {bool verbose = false}) {
    node.getAttribute("value"); //double
    node.getAttribute("unit"); //text
    // TODO: implement acceptDuration
  }

  @override
  void acceptPrerequisite(XmlElement node, {bool verbose = false}) {
    for (var node in node.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "para") {
        acceptPara(node, verbose: verbose);
      } else {
        valid = false;
        errmsg += "Prerequisite unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptCmd(XmlElement node, {bool verbose = false}) {}

  @override
  void acceptCode(XmlElement node, {bool verbose = false}) {}

  @override
  void acceptEm(XmlElement node, {bool verbose = false}) {
    for (var txtnode in node.children)  if(txtnode is XmlText)acceptText(txtnode,verbose: verbose);
    else { print("AAAARGGGHHH non txt node in EM: $txtnode");};
  }

  @override
  void acceptFile(XmlElement node, {bool verbose = false}) {}

  @override
  void acceptImage(XmlElement node, {bool verbose = false}) {
    String src = node.getAttribute("src") ?? "";
    //String scale = node.getAttribute("src")??"";
    if (src.isEmpty) {
      valid = false;
      errmsg += "image: src is empty";
    }
    for (var node in node.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "legend") {
        acceptLegend(node, verbose: verbose);
      } else {
        valid = false;
        errmsg += "Image unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptMenu(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptMenu
  }

  @override
  void acceptTable(XmlElement node, {bool verbose = false}) {
    for (var node in node.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "row") {
        acceptRow(node, verbose: verbose);
      } else {
        valid = false;
        errmsg += "Table unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptUrl(XmlElement node, {bool verbose = false}) {
    String href = node.getAttribute("href") ?? "";
    if (href.isEmpty) {
      valid = false;
      errmsg += "url: href is empty";
    }
  }

  @override
  void acceptLegend(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptLegend
  }

  @override
  void acceptCol(XmlElement node, {bool verbose = false}) {
    for (var node in node.children) {
      if (node is XmlElement) {
        acceptPara(node, verbose: verbose);
      } else if (node is XmlText) {
        acceptText(node, verbose: verbose);
      } else {
        valid = false;
        errmsg += "Table Col unknown stuff: ${node.runtimeType} $node\n";
      }
    }
  }

  @override
  void acceptRow(XmlElement node, {bool verbose = false}) {
    for (var node in node.children) {
      String value = (node is XmlElement) ? node.name.toString() : "node";
      if (node is XmlElement && value == "col") {
        acceptCol(node, verbose: verbose);
      } else {
        valid = false;
        errmsg += "Table Row unknown stuff: ${node.runtimeType} $node";
      }
    }
  }

  @override
  void acceptExercice(XmlElement module, {bool verbose = false}) {
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "question") {
          acceptQuestion(p0, verbose: verbose);
        } else if (value == "answer") {
          acceptAnswer(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "exercise unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "exercise unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptList(XmlElement node, {bool verbose = false}) {
    for (var p0 in node.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "item") {
          acceptItem(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "List unknown stuff: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "List unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptNote(XmlElement module, {bool verbose = false}) {
    String trainerAtt = module.getAttribute("trainer") ?? "true";
    bool trainer = (trainerAtt == "true") ? true : false;
    if (trainer) acceptPara(module, verbose: verbose);
  }

  @override
  void acceptSection(XmlElement module, {bool verbose = false, int level = 0}) {
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : "node";
      if (p0 is XmlElement) {
        if (value == "title") {
          acceptTitle(p0, verbose: verbose);
        } else if (value == "section") {
          if (level == 0) {
            acceptSection(p0, verbose: verbose, level: level + 1);
          } else {
            valid = false;
            errmsg += "Section too deep indentation: ${p0.runtimeType} $p0\n";
          }
        } else if (value == "para") {
          acceptPara(p0, verbose: verbose);
        } else if (value == "note") {
          acceptNote(p0, verbose: verbose);
        } else if (value == "exercise") {
          acceptExercice(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "Section unknown element: ${p0.runtimeType} $p0\n";
        }
      } else {
        valid = false;
        errmsg += "Section unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptSubTitle(XmlElement subtitle, {bool verbose = false}) {
    // TODO: implement acceptSubTitle
  }

  @override
  void acceptText(XmlText node, {bool verbose = false, bool add=true}) {
    // TODO: implement acceptText
  }

  @override
  void acceptMath(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptMath
  }

  @override
  void acceptAnswer(XmlElement node, {bool verbose = false}) {
    for (var p0 in node.children) {
      String value = (p0 is XmlElement)
          ? p0.name.toString()
          : (p0 is XmlText)
              ? "txt"
              : "node";
      if (p0 is XmlElement) {
        if (value == "para") {
          acceptPara(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "answer unknown element: ${p0.runtimeType} $p0\n";
        }
      } else if (p0 is XmlText) {
        acceptText(p0, verbose: verbose);
      } else {
        valid = false;
        errmsg += "answer unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
    // TODO: implement acceptAnswer
  }

  @override
  void acceptQuestion(XmlElement node, {bool verbose = false}) {
    for (var p0 in node.children) {
      String value = (p0 is XmlElement)
          ? p0.name.toString()
          : (p0 is XmlText)
              ? "txt"
              : "node";
      if (p0 is XmlElement) {
        if (value == "para") {
          acceptPara(p0, verbose: verbose);
        } else {
          valid = false;
          errmsg += "question unknown element: ${p0.runtimeType} $p0\n";
        }
      } else if (p0 is XmlText) {
        acceptText(p0, verbose: verbose);
      } else {
        valid = false;
        errmsg += "question unknown stuff: ${p0.runtimeType} $p0\n";
      }
    }
  }

  @override
  void acceptGlossary(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptGlossary
  }
}
