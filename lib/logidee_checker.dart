import 'package:logidee_tools/visitor.dart';
import 'package:xml/src/xml/nodes/document.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/xml.dart';

class LogideeChecker {
  bool valid = true;
  LogideeChecker(XmlDocument document, visitor visit,{bool verbose: false})
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
          print("found unknwon element ${child.name}");
          valid = false;
        }
      }
    }
    valid &= visit.valid;
    if(verbose && !valid) print("we got errors....");
  }
}

class FormationChecker {
  FormationChecker(XmlElement desc, visitor visit)
  {
    visit.acceptFormation(desc);
  }
}

class DeclarationChecker {
  DeclarationChecker(XmlDeclaration desc, visitor visit)
  {
    visit.accept(desc);
  }
}
class DoctypeChecker {
  DoctypeChecker(XmlDoctype desc, visitor visit)
  {
    print("called checker on ${desc.runtimeType}");
    for (var element in desc.attributes) {
      print("doctype att: $element");
    }
    for (var child in desc.children) {
      print("doctype found child : ${child.runtimeType}");
    }
  }
}
