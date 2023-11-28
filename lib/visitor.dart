import 'package:xml/xml.dart';

abstract class Visitor
{
  String encoding = "UTF-8";
  String lang = "fr";
  String theme = "default";
  bool valid = true;
  String errmsg = "";
  String charte = "default";
  bool trainer = false;
  String selection  = "all";
  bool cycle = false;

  Visitor({String? charte, bool? trainer, String? selection, String? lang, bool? cycle}) {
    if(charte!= null && charte.isNotEmpty) this.charte = charte;
    if(selection!= null && selection.isNotEmpty) this.selection = selection;
    if(lang!= null && lang.isNotEmpty) this.lang = lang;
    if(trainer!= null) this.trainer = trainer;
    if(cycle!= null) this.cycle = cycle;
  }

  Visitor accept(XmlDeclaration desc)
  {
    encoding = desc.getAttribute("encoding")??"";
    lang = desc.getAttribute("lang")??"";
    theme = desc.getAttribute("theme")??"";
    return this;
  }

  Visitor acceptFormation(XmlElement formation,{bool verbose = false, StringBuffer? buffer});

  Visitor acceptInfo(XmlElement info, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptTheme(XmlElement theme, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []});

  Visitor acceptTitle(XmlElement title, {bool verbose = false, StringBuffer? buffer});
  Visitor acceptSubTitle(XmlElement subtitle, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptDescription(XmlElement desc, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptObjectives(XmlElement object, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptDependency(XmlElement dependency, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptSuggestion(XmlElement suggestion, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptVersion(XmlElement version, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptProofreaders(XmlElement proofRead, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptRatio(XmlElement ratioNode, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptPara(XmlElement paraNode, {bool verbose = false, String tag= "Para", StringBuffer? buffer});

  Visitor acceptList(XmlElement listNode, {bool verbose = false, StringBuffer? buffer});
  Visitor acceptItem(XmlElement itemNode, {bool verbose = false, StringBuffer? buffer});

  Visitor acceptRef(XmlElement refNode, {bool verbose = false, StringBuffer? buffer}) ;

  Visitor acceptAuthor(XmlElement authorNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptEmail(XmlElement mailNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptComment(XmlElement cmtNode, {bool verbose = false, StringBuffer? buffer}) ;

  Visitor acceptDate(XmlElement dateNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptLevel(XmlElement lvlNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptState(XmlElement stateNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptDuration(XmlElement durNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptPrerequisite(XmlElement prereqNode, {bool verbose = false, StringBuffer? buffer}) ;

  Visitor acceptSlideShow(XmlElement show, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) ;
  Visitor acceptModule(XmlElement module, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptPage(XmlElement pageNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptSection(XmlElement secNode, {bool verbose = false, int level=0, StringBuffer? buffer}) ;
  Visitor acceptExercise(XmlElement exNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptNote(XmlElement notNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptSlide(XmlElement slidNode, {bool verbose = false, StringBuffer? buffer, List<String> treated =const []}) ;
  Visitor acceptEm(XmlElement emNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptMenu(XmlElement menNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptCmd(XmlElement cmdNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptFile(XmlElement fileNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptUrl(XmlElement urlNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptCode(XmlElement codeNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptImage(XmlElement imgNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptTable(XmlElement tblNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptRow(XmlElement rowNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptCol(XmlElement colNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptLegend(XmlElement legNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptText(XmlText txtNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptMath(XmlElement mathNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptQuestion(XmlElement questNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptAnswer(XmlElement answNode, {bool verbose = false, StringBuffer? buffer}) ;
  Visitor acceptGlossary(XmlElement gloNode, {bool verbose = false, StringBuffer? buffer}) ;
}
