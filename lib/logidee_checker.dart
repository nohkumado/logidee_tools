import 'package:logidee_tools/visitor.dart';
import 'package:xml/src/xml/nodes/document.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/xml.dart';

class LogideeChecker {
  bool valid = true;
  LogideeChecker(XmlDocument document, Visitor visit,{bool verbose: false})
  {
    for (var child in document.children) {
      if(child is XmlDeclaration) {
        DeclarationChecker(child, visit);
      }
      else if(child is XmlDoctype) {
          DoctypeChecker(child,visit);
      }
      else if(child is XmlElement) {
        if(child.name.toString() == "formation")
          FormationChecker(child,visit);
        else {
          print("found unknown element ${child.name}");
          valid = false;
        }
      }
    }
    valid &= visit.valid;
    if(verbose && !valid) print("we got errors....");
  }
}

class FormationChecker {
  FormationChecker(XmlElement desc, Visitor visit)
  {
    visit.acceptFormation(desc);
  }
}

class DeclarationChecker {
  DeclarationChecker(XmlDeclaration desc, Visitor visit)
  {
    visit.accept(desc);
  }
}
class DoctypeChecker {
  DoctypeChecker(XmlDoctype desc, Visitor visit)
  {
    for (var element in desc.attributes) {
      print("doctype att: $element");
    }
    for (var child in desc.children) {
      print("doctype found child : ${child.runtimeType}");
    }
  }
}
