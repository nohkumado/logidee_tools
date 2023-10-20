import 'package:logidee_tools/visitor_treetraversor.dart';
import 'package:xml/xml.dart';


class VisitorCheck extends VisitorTreeTraversor
{

  @override
  acceptFormation(XmlElement formation,{bool verbose = false})
  {
    List<String> check = ["info","shortinfo","theme"];
    valid &= structureCheck(formation,check, verbose:verbose, tag: "Formation");
    super.acceptFormation(formation, verbose: verbose);
  }
  @override
  void acceptInfo(XmlElement info, {bool verbose = false})
  {
    List<String> check = ["title","ref","description", "objectives","ratio", "duration", "prerequisite", "dependency","suggestion","version","level","state","proofreaders"];
    valid &= structureCheck(info,check, verbose:verbose, tag: "Info");
    super.acceptFormation(info, verbose: verbose);
  }

  @override
  void acceptTheme(XmlElement theme, {bool verbose = false})
  {
    List<String> check = ["info","shortinfo","module", "slideshow"];
    valid &= structureCheck(theme,check, verbose:verbose, tag: "Theme");
    super.acceptTheme(theme, verbose: verbose);
  }

  @override
  void acceptModule(XmlElement module, {bool verbose = false})
  {
    List<String> check = ["info","shortinfo","page"];
    valid &= structureCheck(module,check, verbose:verbose, tag: "Module");
    super.acceptModule(module, verbose: verbose);
  }
  bool structureCheck(XmlElement module,List<String> check, {bool verbose = false, tag="unkown node"}) {
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
        module.children.forEach((p0) {
          if (p0 is XmlElement) msg += "${p0.name},";
        });
        msg += "]";
        print(msg);
      }
    }
    return ret;
  }

  @override
  void acceptAuthor(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptAuthor
    super.acceptAuthor(node, verbose: verbose);
  }

  @override
  void acceptComment(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptComment
    super.acceptComment(node, verbose: verbose);
  }

  @override
  void acceptDate(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptDate
    super.acceptDate(node, verbose: verbose);
  }

  @override
  void acceptDependency(XmlElement node, {bool verbose = false}) {
    List<String> check = ["ref"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Dependency");
    super.acceptDependency(node, verbose: verbose);
  }

  @override
  void acceptDescription(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptDescription
    List<String> check = ["para"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Description");
    super.acceptDescription(node, verbose: verbose);
  }

  @override
  void acceptEmail(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptEmail
    super.acceptEmail(node, verbose: verbose);
  }

  @override
  void acceptItem(XmlElement node, {bool verbose = false}) {
    List<String> check = ["txt","list","para","cmd","url"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Item");
    super.acceptItem(node, verbose: verbose);
  }

  @override
  void acceptObjectives(XmlElement node, {bool verbose = false}) {
    List<String> check = ["item"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Objectives");
    super.acceptObjectives(node, verbose: verbose);
  }

  @override
  void acceptPara(XmlElement node, {bool verbose = false, String tag= "Para"}) {
    valid &= checkAttributes(node,{"icon": {"option": true},"restriction": {"option": true}});
    List<String> check = ["txt","url", "image", "list", "em", "cmd", "menu", "file", "code", "table", "math", "glossary"];
    valid &= structureCheck(node,check, verbose:verbose, tag: tag);
    super.acceptPara(node, verbose: verbose);
  }

  @override
  void acceptProofreaders(XmlElement node, {bool verbose = false}) {
    List<String> check = ["item"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Proofreaders");
    super.acceptProofreaders(node, verbose: verbose);
  }

  @override
  void acceptRatio(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptRatio
    super.acceptRatio(node, verbose: verbose);
  }

  @override
  void acceptRef(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptRef
    super.acceptRef(node, verbose: verbose);
  }

  @override
  void acceptSlideShow(XmlElement show, {bool verbose = false}) {
    List<String> check = ["info","shortinfo","slide"];
    valid &= structureCheck(show,check, verbose:verbose, tag: "SlideShow");
    super.acceptSlideShow(show, verbose: verbose);
  }

  @override
  void acceptSuggestion(XmlElement node, {bool verbose = false}) {
    List<String> check = ["ref"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Suggestion");
    super.acceptSuggestion(node, verbose: verbose);
  }

  @override
  void acceptTitle(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptTitle
    super.acceptTitle(node, verbose: verbose);
  }

  @override
  void acceptVersion(XmlElement node, {bool verbose = false}) {
    List<String> check = ["author", "email", "comment", "date"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "version");
    super.acceptVersion(node, verbose: verbose);
  }

  @override
  void acceptAnswer(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptAnswer
    super.acceptAnswer(node, verbose: verbose);
  }

  @override
  void acceptCmd(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptCmd
    super.acceptCmd(node, verbose: verbose);
  }

  @override
  void acceptCode(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptCode
    super.acceptCode(node, verbose: verbose);
  }

  @override
  void acceptCol(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptCol
    super.acceptCol(node, verbose: verbose);
  }

  @override
  void acceptDuration(XmlElement node, {bool verbose = false}) {
    // TODO: implement acceptDuration
    super.acceptDuration(node, verbose: verbose);
  }

  @override
  void acceptEm(XmlElement node, {bool verbose = false}) {
    super.acceptEm(node, verbose: verbose);
    // TODO: implement acceptEm
  }

  @override
  void acceptExercice(XmlElement module, {bool verbose = false}) {
    valid &= checkAttributes(module,{"restriction": {"option": true}});
    super.acceptExercice(module, verbose: verbose);
    // TODO: implement acceptExercice
  }

  @override
  void acceptFile(XmlElement node, {bool verbose = false}) {
    super.acceptFile(node, verbose: verbose);
    // TODO: implement acceptFile
  }

  @override
  void acceptGlossary(XmlElement node, {bool verbose = false}) {
    super.acceptGlossary(node, verbose: verbose);
    // TODO: implement acceptGlossary
  }

  @override
  void acceptImage(XmlElement node, {bool verbose = false}) {
    super.acceptImage(node, verbose: verbose);
    // TODO: implement acceptImage
  }

  @override
  void acceptLegend(XmlElement node, {bool verbose = false}) {
    super.acceptLegend(node, verbose: verbose);
    // TODO: implement acceptLegend
  }

  @override
  void acceptLevel(XmlElement node, {bool verbose = false}) {
    valid &= checkAttributes(node,{"value": {"option": false}});
    super.acceptLevel(node, verbose: verbose);
    // TODO: implement acceptLevel
  }

  @override
  void acceptList(XmlElement node, {bool verbose = false}) {
    List<String> check = ["item","list"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "List");
    super.acceptList(node, verbose: verbose);
    // TODO: implement acceptList
  }

  @override
  void acceptMath(XmlElement node, {bool verbose = false}) {
    super.acceptMath(node, verbose: verbose);
    // TODO: implement acceptMath
  }

  @override
  void acceptMenu(XmlElement node, {bool verbose = false}) {
    super.acceptMenu(node, verbose: verbose);
    // TODO: implement acceptMenu
  }

  @override
  void acceptNote(XmlElement note, {bool verbose = false}) {
    valid &= checkAttributes(note,{"restriction": {"option": true}});
    super.acceptNote(note, verbose: verbose);
    // TODO: implement acceptNote
  }

  @override
  void acceptPage(XmlElement page, {bool verbose = false}) {
    valid &= checkAttributes(page,{"restriction": {"option": true}});
    List<String> check = ["slide", "title", "section", "exercise"];
    valid &= structureCheck(page,check, verbose:verbose, tag: "Page");
    super.acceptPage(page, verbose: verbose);
  }

  @override
  void acceptPrerequisite(XmlElement node, {bool verbose = false}) {
    List<String> check = ["para"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Prerequisite");
    super.acceptPrerequisite(node, verbose: verbose);
  }

  @override
  void acceptQuestion(XmlElement node, {bool verbose = false}) {
    List<String> check = ["para"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Question");
    super.acceptQuestion(node, verbose: verbose);
  }

  @override
  void acceptRow(XmlElement node, {bool verbose = false}) {
    List<String> check = ["col"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Question");
    super.acceptRow(node, verbose: verbose);
  }

  @override
  void acceptSection(XmlElement section, {bool verbose = false, int level = 0}) {
    valid &= checkAttributes(section,{"restriction": {"option": true}});
    List<String> check = ["title","section", "para", "note", "exercice"];
    valid &= structureCheck(section,check, verbose:verbose, tag: "Section");
    super.acceptSection(section, verbose: verbose);
  }

  @override
  void acceptSlide(XmlElement slide, {bool verbose = false}) {
    valid &= checkAttributes(slide,{"background": {"option": true}});
    List<String> check = ["section", "title", "subtitle", "list", "para", "note", "exercice"];
    valid &= structureCheck(slide,check, verbose:verbose, tag: "SlideShow");
    super.acceptSlide(slide, verbose: verbose);
  }

  @override
  void acceptState(XmlElement node, {bool verbose = false}) {
    valid &= checkAttributes(node,{"finished": {"option": true},"proofread": {"option": true}});
    super.acceptState(node, verbose: verbose);
  }

  @override
  void acceptSubTitle(XmlElement node, {bool verbose = false}) {
    super.acceptSubTitle(node, verbose: verbose);
    // TODO: implement acceptSubTitle
  }

  @override
  void acceptTable(XmlElement node, {bool verbose = false}) {
    List<String> check = ["row"];
    valid &= structureCheck(node,check, verbose:verbose, tag: "Table");
    super.acceptTable(node, verbose: verbose);
  }

  @override
  void acceptText(XmlText node, {bool verbose = false}) {
    super.acceptText(node, verbose: verbose);
    // TODO: implement acceptText
  }

  @override
  void acceptUrl(XmlElement node, {bool verbose = false}) {
    valid &= checkAttributes(node,{"href": {"option": false},"name": {"option": true}});
    super.acceptUrl(node, verbose: verbose);
    // TODO: implement acceptUrl
  }

  bool checkAttributes(XmlElement node, Map<String, Map<String, bool>> map) {
    bool ret = true;
    List<String> obligatory = [];
    map.forEach((key, value) {
      if(value["option"] == "false") obligatory.add(key);
    });
    node.attributes.forEach((p0) {
      if(!map.containsKey(p0.name.toString()))
        {
          ret = false;
          errmsg += "${node.name} attribute problems: ${p0.name} is not a valid attribute\n";
        }
      if(obligatory.contains(p0.name.toString())) obligatory.remove(p0.name.toString());
    });
    ret &= obligatory.isEmpty;
    if(!ret) errmsg += "${node.name} attribute problems: missing required attributes : ${obligatory}\n";

    return ret;
  }
}
