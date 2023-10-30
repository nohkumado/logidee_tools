import 'package:logidee_tools/visitor_treetraversor.dart';
import 'package:xml/xml.dart';

import 'visitor.dart';


class VisitorCheck extends VisitorTreeTraversor
{

  @override
  acceptFormation(XmlElement formation,{bool verbose = false, StringBuffer? buffer})
  {
    List<String> check = ["info","shortinfo","theme"];
    valid &= structureCheck(formation,check, verbose:verbose, tag: "Formation");
    super.acceptFormation(formation, verbose: verbose, buffer: buffer);
    return this;
  }
  @override
  Visitor acceptInfo(XmlElement info, {bool verbose = false, StringBuffer? buffer})
  {
    List<String> check = ["title","ref","description", "objectives","ratio", "duration", "prerequisite", "dependency","suggestion","version","level","state","proofreaders"];
    valid &= structureCheck(info,check, verbose:verbose, tag: "Info");
    super.acceptInfo(info, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptTheme(XmlElement theme, {bool verbose = false, StringBuffer? buffer})
  {
    List<String> check = ["info","shortinfo","module", "slideshow"];
    valid &= structureCheck(theme,check, verbose:verbose, tag: "Theme");
    super.acceptTheme(theme, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptModule(XmlElement module, {bool verbose = false, StringBuffer? buffer})
  {
    List<String> check = ["info","shortinfo","page"];
    valid &= structureCheck(module,check, verbose:verbose, tag: "Module");
    super.acceptModule(module, verbose: verbose, buffer: buffer);
    return this;
  }
  bool structureCheck(XmlElement module,List<String> check, {bool verbose = false, tag="unknown node"}) {
    bool ret = true;
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : (p0 is XmlText) ? "txt" :"node";
      if(value == "txt" && p0.toString().trim().isEmpty) continue;
      ret &= check.any((key) => key == value);
      if (!ret) {
        if(value == "txt") print("####### Found problem text: '${p0.toString().trim()}' ${p0.parent}");
        String msg = "$tag problem with ";
        msg += "$value = '";
        msg += (p0.toString().length > 80) ? ""+p0.toString().substring(0, 80).trim() + "' ..." : p0 .toString()+"'";
        msg += "\nallowed tags: $check\nfound tags: [";
        for (var p0 in module.children) {
          if (p0 is XmlElement) msg += "${p0.name},";
        }
        msg += "]";
        if(verbose) print(msg);
      }
    }
    return ret;
  }

  @override
  Visitor acceptAuthor(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptAuthor
    super.acceptAuthor(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptComment(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptComment
    super.acceptComment(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDate(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptDate
    super.acceptDate(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDependency(XmlElement dependency, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["ref"];
    valid &= structureCheck(dependency,check, verbose:verbose, tag: "Dependency");
    super.acceptDependency(dependency, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDescription(XmlElement desc, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptDescription
    List<String> check = ["para"];
    valid &= structureCheck(desc,check, verbose:verbose, tag: "Description");
    super.acceptDescription(desc, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptEmail(XmlElement emailNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptEmail
    super.acceptEmail(emailNode, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptItem(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["txt","list","para","cmd","url"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Item");
    super.acceptItem(node, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptObjectives(XmlElement object, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["item"];
    valid &= structureCheck(object,check, verbose:verbose, tag: "Objectives");
    super.acceptObjectives(object, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptPara(XmlElement node, {bool verbose = false, String tag= "Para", StringBuffer? buffer}) {
    valid &= checkAttributes(node,{"icon": {"option": true},"restriction": {"option": true}});
    List<String> check = ["txt","url", "image", "list", "em", "cmd", "menu", "file", "code", "table", "math", "glossary"];
    valid &= structureCheck(node,check, verbose:verbose, tag: tag);
    super.acceptPara(node, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptProofreaders(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["item"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Proofreaders");
    super.acceptProofreaders(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRatio(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptRatio
    super.acceptRatio(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRef(XmlElement refNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptRef
    super.acceptRef(refNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptSlideShow(XmlElement show, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["info","shortinfo","slide"];
    valid &= structureCheck(show,check, verbose:verbose, tag: "SlideShow");
    super.acceptSlideShow(show, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptSuggestion(XmlElement suggestion, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["ref"];
    valid &= structureCheck(suggestion,check, verbose:verbose, tag: "Suggestion");
    super.acceptSuggestion(suggestion, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptTitle(XmlElement title, {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    // TODO: implement acceptTitle
    super.acceptTitle(title, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptVersion(XmlElement version, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["author", "email", "comment", "date"];
    valid &= structureCheck(version,check, verbose:verbose, tag: "version");
    super.acceptVersion(version, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptAnswer(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptAnswer
    super.acceptAnswer(node, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCmd(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptCmd
    super.acceptCmd(node, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCode(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptCode
    super.acceptCode(node, verbose: verbose,buffer:buffer);
    return this;
  }

  @override
  Visitor acceptCol(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptCol
    super.acceptCol(node, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDuration(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptDuration
    super.acceptDuration(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptEm(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptEm(node, verbose: verbose,buffer: buffer);
    // TODO: implement acceptEm
    return this;
  }

  @override
  Visitor acceptExercice(XmlElement module, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(module,{"restriction": {"option": true}});
    super.acceptExercice(module, verbose: verbose, buffer: buffer);
    // TODO: implement acceptExercice
    return this;
  }

  @override
  Visitor acceptFile(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptFile(node, verbose: verbose,buffer: buffer);
    // TODO: implement acceptFile
    return this;
  }

  @override
  Visitor acceptGlossary(XmlElement glosNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptGlossary(glosNode, verbose: verbose, buffer: buffer);
    // TODO: implement acceptGlossary
    return this;
  }

  @override
  Visitor acceptImage(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptImage(node, verbose: verbose,buffer: buffer);
    // TODO: implement acceptImage
    return this;
  }

  @override
  Visitor acceptLegend(XmlElement legend, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptLegend(legend, verbose: verbose,buffer: buffer);
    // TODO: implement acceptLegend
    return this;
  }

  @override
  Visitor acceptLevel(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(node,{"value": {"option": false}});
    super.acceptLevel(node, verbose: verbose, buffer: buffer);
    // TODO: implement acceptLevel
    return this;
  }

  @override
  Visitor acceptList(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["item","list"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "List");
    super.acceptList(node, verbose: verbose,buffer: buffer);
    // TODO: implement acceptList
    return this;
  }

  @override
  Visitor acceptMath(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptMath(node, verbose: verbose,buffer: buffer);
    // TODO: implement acceptMath
    return this;
  }

  @override
  Visitor acceptMenu(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptMenu(node, verbose: verbose,buffer: buffer);
    // TODO: implement acceptMenu
    return this;
  }

  @override
  Visitor acceptNote(XmlElement module, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(module,{"restriction": {"option": true}});
    super.acceptNote(module, verbose: verbose, buffer: buffer);
    // TODO: implement acceptNote
    return this;
  }

  @override
  Visitor acceptPage(XmlElement module, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(module,{"restriction": {"option": true}});
    List<String> check = ["slide", "title", "section", "exercise"];
    valid &= structureCheck(module,check, verbose:verbose, tag: "Page");
    super.acceptPage(module, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptPrerequisite(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["para"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Prerequisite");
    super.acceptPrerequisite(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptQuestion(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["para","txt"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Question");
    super.acceptQuestion(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRow(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["col"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Row");
    super.acceptRow(node, verbose: verbose,buffer:buffer);
    return this;
  }

  @override
  Visitor acceptSection(XmlElement module, {bool verbose = false, int level = 0, StringBuffer? buffer}) {
    valid &= checkAttributes(module,{"restriction": {"option": true}});
    List<String> check = ["title","section", "para", "note", "exercice"];
    valid &= structureCheck(module,check, verbose:verbose, tag: "Section");
    super.acceptSection(module, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptSlide(XmlElement module, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(module,{"background": {"option": true}});
    List<String> check = ["section", "title", "subtitle", "list", "para", "note", "exercice"];
    valid &= structureCheck(module,check, verbose:verbose, tag: "SlideShow");
    super.acceptSlide(module, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptState(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(node,{"finished": {"option": true},"proofread": {"option": true}});
    super.acceptState(node, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptSubTitle(XmlElement subtitle, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptSubTitle(subtitle, verbose: verbose, buffer: buffer);
    // TODO: implement acceptSubTitle
    return this;
  }

  @override
  Visitor acceptTable(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["row"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Table");
    super.acceptTable(node, verbose: verbose,buffer:buffer);
    return this;
  }

  @override
  Visitor acceptText(XmlText node, {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    super.acceptText(node, verbose: verbose, buffer: buffer);
    // TODO: implement acceptText
    return this;
  }

  @override
  Visitor acceptUrl(XmlElement node, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(node,{"href": {"option": false},"name": {"option": true}});
    super.acceptUrl(node, verbose: verbose,buffer:buffer);
    return this;
    // TODO: implement acceptUrl
  }

  bool checkAttributes(XmlElement node, Map<String, Map<String, bool>> map) {
    bool ret = true;
    List<String> obligatory = [];
    map.forEach((key, value) {
      if(value["option"] == "false") obligatory.add(key);
    });
    for (var p0 in node.attributes) {
      if(!map.containsKey(p0.name.toString()))
        {
          ret = false;
          errmsg += "${node.name} attribute problems: ${p0.name} is not a valid attribute\n";
        }
      if(obligatory.contains(p0.name.toString())) obligatory.remove(p0.name.toString());
    }
    ret &= obligatory.isEmpty;
    if(!ret) errmsg += "${node.name} attribute problems: missing required attributes : $obligatory\n";

    return ret;
  }
}
