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
    List<String> check = ["title","subtitle","ref","description", "objectives","ratio", "duration", "prerequisite", "dependency","suggestion","version","level","state","proofreaders"];
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
    //print("SC: ${module.name} ret is $ret");
    for (var p0 in module.children) {
      String value = (p0 is XmlElement) ? p0.name.toString() : (p0 is XmlText) ? "txt" :"node";
      if(value == "txt" && p0.toString().trim().isEmpty) continue;
      //print("SC: child ${value} in $check? ${check.any((key) => key == value)}");
      ret &= check.any((key) => key == value);
      //print("SC: ${module.name} ret evolved to  $ret");
      if (!ret) {
        //print("####### Found problem text: '${p0.toString().trim()}' ${p0.parent}");
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
        errmsg += msg;
      }
    }
    if(ret == false  && verbose) print("PROBLEM with $module gave '$errmsg'");
    return ret;
  }

  @override
  Visitor acceptAuthor(XmlElement authorNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptAuthor
    super.acceptAuthor(authorNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptComment(XmlElement cmtNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptComment
    super.acceptComment(cmtNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDate(XmlElement dateNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptDate
    super.acceptDate(dateNode, verbose: verbose, buffer: buffer);
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
  Visitor acceptEmail(XmlElement mailNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptEmail
    super.acceptEmail(mailNode, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptItem(XmlElement itemNode, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["txt","list","para","cmd","url"];
    valid &= structureCheck(itemNode,check, verbose:verbose, tag: "Item");
    super.acceptItem(itemNode, verbose: verbose,buffer: buffer);
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
  Visitor acceptPara(XmlElement paraNode, {bool verbose = false, String tag= "Para", StringBuffer? buffer}) {
    valid &= checkAttributes(paraNode,{"icon": {"option": true},"restriction": {"option": true}});
    List<String> check = ["txt","url", "image", "list", "em", "cmd", "menu", "file", "code", "table", "math", "glossary", "note"];
    valid &= structureCheck(paraNode,check, verbose:verbose, tag: tag);
    super.acceptPara(paraNode, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptProofreaders(XmlElement proofRead, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["item"];
    valid &= structureCheck(proofRead,check, verbose:verbose, tag: "Proofreaders");
    super.acceptProofreaders(proofRead, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRatio(XmlElement ratioNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptRatio
    super.acceptRatio(ratioNode, verbose: verbose, buffer: buffer);
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
  Visitor acceptAnswer(XmlElement answNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptAnswer
    super.acceptAnswer(answNode, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCmd(XmlElement cmdNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptCmd
    super.acceptCmd(cmdNode, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptCode(XmlElement codeNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(codeNode,{"lang": {"option": true}});
    valid &= checkAttributes(codeNode,{"caption": {"option": true}});
    // TODO: implement acceptCode
    super.acceptCode(codeNode, verbose: verbose,buffer:buffer);
    return this;
  }

  @override
  Visitor acceptCol(XmlElement colNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptCol
    super.acceptCol(colNode, verbose: verbose,buffer: buffer);
    return this;
  }

  @override
  Visitor acceptDuration(XmlElement durNode, {bool verbose = false, StringBuffer? buffer}) {
    // TODO: implement acceptDuration
    super.acceptDuration(durNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptEm(XmlElement emNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptEm(emNode, verbose: verbose,buffer: buffer);
    // TODO: implement acceptEm
    return this;
  }

  @override
  Visitor acceptExercise(XmlElement exNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(exNode,{"restriction": {"option": true}});
    super.acceptExercise(exNode, verbose: verbose, buffer: buffer);
    // TODO: implement acceptExercise
    return this;
  }

  @override
  Visitor acceptFile(XmlElement fileNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptFile(fileNode, verbose: verbose,buffer: buffer);
    // TODO: implement acceptFile
    return this;
  }

  @override
  Visitor acceptGlossary(XmlElement gloNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptGlossary(gloNode, verbose: verbose, buffer: buffer);
    // TODO: implement acceptGlossary
    return this;
  }

  @override
  Visitor acceptImage(XmlElement imgNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptImage(imgNode, verbose: verbose,buffer: buffer);
    // TODO: implement acceptImage
    return this;
  }

  @override
  Visitor acceptLegend(XmlElement legNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptLegend(legNode, verbose: verbose,buffer: buffer);
    // TODO: implement acceptLegend
    return this;
  }

  @override
  Visitor acceptLevel(XmlElement lvlNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(lvlNode,{"value": {"option": false}});
    super.acceptLevel(lvlNode, verbose: verbose, buffer: buffer);
    // TODO: implement acceptLevel
    return this;
  }

  @override
  Visitor acceptList(XmlElement listNode, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["item","list"];
    valid &= structureCheck(listNode,check, verbose:verbose, tag: "List");
    super.acceptList(listNode, verbose: verbose,buffer: buffer);
    // TODO: implement acceptList
    return this;
  }

  @override
  Visitor acceptMath(XmlElement mathNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptMath(mathNode, verbose: verbose,buffer: buffer);
    // TODO: implement acceptMath
    return this;
  }

  @override
  Visitor acceptMenu(XmlElement menNode, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptMenu(menNode, verbose: verbose,buffer: buffer);
    // TODO: implement acceptMenu
    return this;
  }

  @override
  Visitor acceptNote(XmlElement notNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(notNode,{
      "restriction": {"option": true},
      "trainer": {"option": true}
    });
    super.acceptNote(notNode, verbose: verbose, buffer: buffer);
    // TODO: implement acceptNote
    return this;
  }

  @override
  Visitor acceptPage(XmlElement pageNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(pageNode,{"restriction": {"option": true}});
    List<String> check = ["slide", "title", "section", "exercise"];
    valid &= structureCheck(pageNode,check, verbose:verbose, tag: "Page");
    super.acceptPage(pageNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptPrerequisite(XmlElement prereqNode, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["para"];
    valid &= structureCheck(prereqNode,check, verbose:verbose, tag: "Prerequisite");
    super.acceptPrerequisite(prereqNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptQuestion(XmlElement questNode, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["para","txt"];
    valid &= structureCheck(questNode,check, verbose:verbose, tag: "Question");
    super.acceptQuestion(questNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptRow(XmlElement rowNode, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["col"];
    valid &= structureCheck(rowNode,check, verbose:verbose, tag: "Row");
    super.acceptRow(rowNode, verbose: verbose,buffer:buffer);
    return this;
  }

  @override
  Visitor acceptSection(XmlElement secNode, {bool verbose = false, int level = 0, StringBuffer? buffer}) {
    valid &= checkAttributes(secNode,{"restriction": {"option": true}});
    List<String> check = ["title","section", "para", "note", "exercise"];
    valid &= structureCheck(secNode,check, verbose:verbose, tag: "Section");
    super.acceptSection(secNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptSlide(XmlElement slidNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(slidNode,{"background": {"option": true}});
    List<String> check = ["section", "title", "subtitle", "list", "para", "note", "exercise"];
    valid &= structureCheck(slidNode,check, verbose:verbose, tag: "SlideShow");
    super.acceptSlide(slidNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptState(XmlElement stateNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(stateNode,{"finished": {"option": true},"proofread": {"option": true}});
    super.acceptState(stateNode, verbose: verbose, buffer: buffer);
    return this;
  }

  @override
  Visitor acceptSubTitle(XmlElement subtitle, {bool verbose = false, StringBuffer? buffer}) {
    super.acceptSubTitle(subtitle, verbose: verbose, buffer: buffer);
    // TODO: implement acceptSubTitle
    return this;
  }

  @override
  Visitor acceptTable(XmlElement tblNode, {bool verbose = false, StringBuffer? buffer}) {
    List<String> check = ["row"];
    valid &= structureCheck(tblNode,check, verbose:verbose, tag: "Table");
    super.acceptTable(tblNode, verbose: verbose,buffer:buffer);
    return this;
  }

  @override
  Visitor acceptText(XmlText txtNode, {bool verbose = false, bool add = true, StringBuffer? buffer}) {
    super.acceptText(txtNode, verbose: verbose, buffer: buffer);
    // TODO: implement acceptText
    return this;
  }

  @override
  Visitor acceptUrl(XmlElement urlNode, {bool verbose = false, StringBuffer? buffer}) {
    valid &= checkAttributes(urlNode,{"href": {"option": false},"name": {"option": true}});
    super.acceptUrl(urlNode, verbose: verbose,buffer:buffer);
    return this;
    // TODO: implement acceptUrl
  }

  bool checkAttributes(XmlElement node, Map<String, Map<String, bool>> map) {
    bool ret = true;
    List<String> obligatory = [];
    map.forEach((key, value) {
      if(value.containsKey("option") && value["option"] == false) obligatory.add(key);
    });
    //if(obligatory.isNotEmpty) print("${node.name} oblig attr: $obligatory");
    for (var p0 in node.attributes) {
      if(!map.containsKey(p0.name.toString()))
        {
          ret = false;
          errmsg += "${node.name} attribute problems: '${p0.name}' is not a valid attribute in  $map\n";
        }
      if(obligatory.contains(p0.name.toString())) obligatory.remove(p0.name.toString());
    }
    ret &= obligatory.isEmpty;
    if(!ret) errmsg += "${node.name} attribute problems: missing required attributes : $obligatory\n";

    return ret;
  }
}
