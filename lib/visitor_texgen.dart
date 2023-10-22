import 'package:logidee_tools/visitor_treetraversor.dart';
import 'package:xml/xml.dart';

class VisitorTexgen extends VisitorTreeTraversor {
  String content = "";

  @override
  void acceptAnswer(XmlElement node, {bool verbose = false}) {
      print("accept amswer, should treat stuff??");
      super.acceptAnswer(node,verbose: verbose);
  }

  @override
  void acceptAuthor(XmlElement node, {bool verbose = false}) {
    print("accept author, should treat stuff??");
    super.acceptAuthor(node,verbose: verbose);
  }

  @override
  void acceptCmd(XmlElement node, {bool verbose = false}) {
    print("accept cmd, should treat stuff??");
    super.acceptCmd(node,verbose: verbose);
  }

  @override
  void acceptCode(XmlElement node, {bool verbose = false}) {
    print("accept code, should treat stuff??");
    super.acceptCode(node,verbose: verbose);
  }

  @override
  void acceptCol(XmlElement node, {bool verbose = false}) {
    print("accept col, should treat stuff??");
    super.acceptCol(node,verbose: verbose);
  }

  @override
  void acceptComment(XmlElement node, {bool verbose = false}) {
    print("accept comment, should treat stuff??");
    super.acceptComment(node,verbose: verbose);
  }

  @override
  void acceptDate(XmlElement node, {bool verbose = false}) {
    print("accept date, should treat stuff??");
    super.acceptDate(node,verbose: verbose);
  }

  @override
  void acceptDependency(XmlElement dependency, {bool verbose = false}) {
    print("accept dependency, should treat stuff??");
    super.acceptDependency(dependency,verbose: verbose);
  }

  @override
  void acceptDescription(XmlElement desc, {bool verbose = false}) {
    print("accept description, should treat stuff??");
    super.acceptDependency(desc,verbose: verbose);
  }

  @override
  void acceptDuration(XmlElement node, {bool verbose = false}) {
    print("accept duration, should treat stuff??");
    super.acceptDuration(node,verbose: verbose);
  }

  @override
  void acceptEm(XmlElement node, {bool verbose = false}) {
    content += "\\emph{";
    super.acceptEm(node,verbose: verbose);
   content = content.trim();
    content += "} ";
  }

  @override
  void acceptEmail(XmlElement node, {bool verbose = false}) {
    print("accept email, should treat stuff??");
    super.acceptEmail(node,verbose: verbose);
  }

  @override
  void acceptExercice(XmlElement module, {bool verbose = false}) {
    print("accept exercice, should treat stuff??");
    super.acceptExercice(module,verbose: verbose);
  }

  @override
  void acceptFile(XmlElement node, {bool verbose = false}) {
    print("accept file, should treat stuff??");
    super.acceptFile(node,verbose: verbose);
  }

  @override
  acceptFormation(XmlElement formation, {bool verbose = false}) {
    print("accept formation, should treat stuff??");
    super.acceptFormation(formation,verbose: verbose);
  }

  @override
  void acceptGlossary(XmlElement node, {bool verbose = false}) {
    print("accept glossary, should treat stuff??");
    super.acceptGlossary(node,verbose: verbose);
  }

  @override
  void acceptImage(XmlElement node, {bool verbose = false}) {
    print("accept Image, should treat stuff??");
    super.acceptImage(node,verbose: verbose);
  }

  @override
  void acceptInfo(XmlElement info, {bool verbose = false}) {
    print("accept Info, should treat stuff??");
    super.acceptInfo(info,verbose: verbose);
  }

  @override
  void acceptItem(XmlElement node, {bool verbose = false}) {
    print("accept Item, should treat stuff??");
    super.acceptItem(node,verbose: verbose);
  }

  @override
  void acceptLegend(XmlElement node, {bool verbose = false}) {
    print("accept Legend, should treat stuff??");
    super.acceptLegend(node,verbose: verbose);
  }

  @override
  void acceptLevel(XmlElement node, {bool verbose = false}) {
    print("accept Level, should treat stuff??");
    super.acceptLevel(node,verbose: verbose);
  }

  @override
  void acceptList(XmlElement node, {bool verbose = false}) {
    print("accept List, should treat stuff??");
    super.acceptList(node,verbose: verbose);
  }

  @override
  void acceptMath(XmlElement node, {bool verbose = false}) {
    print("accept Mathe, should treat stuff??");
    super.acceptMath(node,verbose: verbose);
  }

  @override
  void acceptMenu(XmlElement node, {bool verbose = false}) {
    print("accept Menu, should treat stuff??");
    super.acceptMenu(node,verbose: verbose);
  }

  @override
  void acceptModule(XmlElement module, {bool verbose = false}) {
    print("accept Module, should treat stuff??");
    super.acceptModule(module,verbose: verbose);
  }

  @override
  void acceptNote(XmlElement module, {bool verbose = false}) {
    print("accept Note, should treat stuff??");
    super.acceptNote(module,verbose: verbose);
  }

  @override
  void acceptObjectives(XmlElement object, {bool verbose = false}) {
    print("accept Objective, should treat stuff??");
    super.acceptObjectives(object,verbose: verbose);
  }

  @override
  void acceptPage(XmlElement module, {bool verbose = false}) {
    print("accept Paage, should treat stuff??");
    super.acceptPage(module,verbose: verbose);
  }

  @override
  void acceptPara(XmlElement node,
      {bool verbose = false, String tag = "Para"}) {
    print("accept Para, should treat stuff??");
    super.acceptPara(node,verbose: verbose);
  }

  @override
  void acceptPrerequisite(XmlElement node, {bool verbose = false}) {
    print("accept Prerequisites, should treat stuff??");
    super.acceptPrerequisite(node,verbose: verbose);
  }

  @override
  void acceptProofreaders(XmlElement node, {bool verbose = false}) {
    print("accept proofreader, should treat stuff??");
    super.acceptProofreaders(node,verbose: verbose);
  }

  @override
  void acceptQuestion(XmlElement node, {bool verbose = false}) {
    print("accept question, should treat stuff??");
    super.acceptQuestion(node,verbose: verbose);
  }

  @override
  void acceptRatio(XmlElement node, {bool verbose = false}) {
    print("accept ratio, should treat stuff??");
    super.acceptRatio(node,verbose: verbose);
  }

  @override
  void acceptRef(XmlElement node, {bool verbose = false}) {
    print("accept ref, should treat stuff??");
    super.acceptRef(node,verbose: verbose);
  }

  @override
  void acceptRow(XmlElement node, {bool verbose = false}) {
    print("accept row, should treat stuff??");
    super.acceptRow(node,verbose: verbose);
  }

  @override
  void acceptSection(XmlElement module, {bool verbose = false, int level = 0}) {
    print("accept sextion, should treat stuff??");
    super.acceptSection(module,verbose: verbose);
  }

  @override
  void acceptSlide(XmlElement module, {bool verbose = false}) {
    print("accept slide, should treat stuff??");
    super.acceptSlide(module,verbose: verbose);
  }

  @override
  void acceptSlideShow(XmlElement show, {bool verbose = false}) {
    print("accept slideshow, should treat stuff??");
    super.acceptSlideShow(show,verbose: verbose);
  }

  @override
  void acceptState(XmlElement node, {bool verbose = false}) {
    print("accept state, should treat stuff??");
    super.acceptState(node,verbose: verbose);
  }

  @override
  void acceptSubTitle(XmlElement subtitle, {bool verbose = false}) {
    print("accept subtitle, should treat stuff??");
    super.acceptSubTitle(subtitle,verbose: verbose);
  }

  @override
  void acceptSuggestion(XmlElement suggestion, {bool verbose = false}) {
    print("accept suggestion, should treat stuff??");
    super.acceptSuggestion(suggestion,verbose: verbose);
  }

  @override
  void acceptTable(XmlElement node, {bool verbose = false}) {
    print("accept table, should treat stuff??");
    super.acceptTable(node,verbose: verbose);
  }

  @override
  void acceptText(XmlText node, {bool verbose = false}) {
    String txt = ((node.value != null && node.value.isNotEmpty)
        ? node.value
        : node.innerText)
        .trim();
    if(node.children.isNotEmpty) print("should do something with ${node.children}");
    content += "$txt ";
    super.acceptText(node,verbose: verbose);
  }

  @override
  void acceptTheme(XmlElement theme, {bool verbose = false}) {
    print("accept theme, should treat stuff??");
    super.acceptTheme(theme,verbose: verbose);
  }

  @override
  void acceptTitle(XmlElement title, {bool verbose = false}) {
    print("accept title, should treat stuff??");
    super.acceptTitle(title,verbose: verbose);
  }

  @override
  void acceptUrl(XmlElement node, {bool verbose = false}) {
    String href = node.getAttribute("href") ?? "";
    String name = node.getAttribute("name") ?? "";
    if (name.isEmpty) name = href;
    if (href.isNotEmpty) {
      content += "\\htmladdnormallink{$name}{$href}";
      //To create a link to another place in your own document
      //\htmlref{text to have highlighted}{Label_name}
      }
    super.acceptUrl(node,verbose: verbose);
  }

  @override
  void acceptVersion(XmlElement version, {bool verbose = false}) {
    print("accept version, should treat stuff??");
    super.acceptVersion(version,verbose: verbose);
  }
}
