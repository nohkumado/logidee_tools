import 'package:xml/xml.dart';

abstract class Visitor
{
  String encoding = "UTF-8";
  String lang = "fr";
  String theme = "default";
  bool valid = true;
  String errmsg = "";


  void accept(XmlDeclaration desc)
  {
    encoding = desc.getAttribute("encoding")??"";
    lang = desc.getAttribute("lang")??"";
    theme = desc.getAttribute("lang")??"";
  }

  acceptFormation(XmlElement formation,{bool verbose = false});

  void acceptInfo(XmlElement info, {bool verbose = false});

  void acceptTheme(XmlElement theme, {bool verbose = false});

  void acceptTitle(XmlElement title, {bool verbose = false});
  void acceptSubTitle(XmlElement subtitle, {bool verbose = false});

  void acceptDescription(XmlElement desc, {bool verbose = false});

  void acceptObjectives(XmlElement object, {bool verbose = false});

  void acceptDependency(XmlElement dependency, {bool verbose = false});

  void acceptSuggestion(XmlElement suggestion, {bool verbose = false});

  void acceptVersion(XmlElement version, {bool verbose = false});

  void acceptProofreaders(XmlElement node, {bool verbose = false});

  void acceptRatio(XmlElement node, {bool verbose = false});

  void acceptPara(XmlElement node, {bool verbose = false, String tag= "Para"});

  void acceptList(XmlElement node, {bool verbose = false});
  void acceptItem(XmlElement node, {bool verbose = false});

  void acceptRef(XmlElement node, {bool verbose = false}) ;

  void acceptAuthor(XmlElement node, {bool verbose = false}) ;
  void acceptEmail(XmlElement node, {bool verbose = false}) ;
  void acceptComment(XmlElement node, {bool verbose = false}) ;

  void acceptDate(XmlElement node, {bool verbose = false}) ;
  void acceptLevel(XmlElement node, {bool verbose = false}) ;
  void acceptState(XmlElement node, {bool verbose = false}) ;
  void acceptDuration(XmlElement node, {bool verbose = false}) ;
  void acceptPrerequisite(XmlElement node, {bool verbose = false}) ;

  void acceptSlideShow(XmlElement show, {bool verbose = false}) ;
  void acceptModule(XmlElement module, {bool verbose = false}) ;
  void acceptPage(XmlElement module, {bool verbose = false}) ;
  void acceptSection(XmlElement module, {bool verbose = false, int level=0}) ;
  void acceptExercice(XmlElement module, {bool verbose = false}) ;
  void acceptNote(XmlElement module, {bool verbose = false}) ;
  void acceptSlide(XmlElement module, {bool verbose = false}) ;
  void acceptEm(XmlElement node, {bool verbose = false}) ;
  void acceptMenu(XmlElement node, {bool verbose = false}) ;
  void acceptCmd(XmlElement node, {bool verbose = false}) ;
  void acceptFile(XmlElement node, {bool verbose = false}) ;
  void acceptUrl(XmlElement node, {bool verbose = false}) ;
  void acceptCode(XmlElement node, {bool verbose = false}) ;
  void acceptImage(XmlElement node, {bool verbose = false}) ;
  void acceptTable(XmlElement node, {bool verbose = false}) ;
  void acceptRow(XmlElement node, {bool verbose = false}) ;
  void acceptCol(XmlElement node, {bool verbose = false}) ;
  void acceptLegend(XmlElement node, {bool verbose = false}) ;
  void acceptText(XmlText node, {bool verbose = false}) ;
  void acceptMath(XmlElement node, {bool verbose = false}) ;
  void acceptQuestion(XmlElement node, {bool verbose = false}) ;
  ///add this at the end of the file
  void acceptAnswer(XmlElement node, {bool verbose = false}) ;
  void acceptGlossary(XmlElement node, {bool verbose = false}) ;
}
