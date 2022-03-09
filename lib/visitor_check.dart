import 'package:logidee_tools/visitor.dart';
import 'package:xml/xml.dart';

class VisitorCheck extends visitor
{

  acceptFormation(XmlElement formation,{bool verbose: false})
  {
    for (var p0 in formation.children) {
      //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
      String value = (p0 is XmlElement)?p0.name.toString():"node";
      List<String> check = ["info","shortinfo","theme"];
      valid &= check.any((listElement) => listElement.contains(value));
      if(!valid) print("Formation problem with $p0");
      super.acceptFormation(formation, verbose: verbose);
    }
  }
  void acceptInfo(XmlElement node, {bool verbose: false})
  {
    for (var p0 in node.children) {
      //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
      String value = (p0 is XmlElement)?p0.name.toString():"node";
      List<String> check = ["title","ref","description", "objectives","ratio", "duration", "prerequisites", "dependency","suggestion","version","level","state","proofreaders"];
      valid &= check.any((listElement) => listElement.contains(value));
      if(!valid) print("Info problem with $p0");
      super.acceptFormation(node, verbose: verbose);
    }

  }
}
