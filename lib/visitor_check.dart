import 'package:logidee_tools/visitor.dart';
import 'package:xml/xml.dart';

class VisitorCheck extends Visitor
{

  acceptFormation(XmlElement formation,{bool verbose: false})
  {
    print("accept formation checker-visitor");
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

    void acceptTheme(XmlElement node, {bool verbose = false})
    {
      print("accept theme checker-visitor");
      for (var p0 in node.children) {
        //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
        String value = (p0 is XmlElement)?p0.name.toString():"node";
        List<String> check = ["info","shortinfo","module", "slideshow"];
        valid &= check.any((listElement) => listElement.contains(value));
        if(!valid) print("theme problem with $p0");
      }
      super.acceptTheme(node, verbose: verbose);
    }
  }

  void acceptModule(XmlElement module, {bool verbose: false})
  {
    print("accept module checker-visitor");
    for (var p0 in module.children) {
      //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
      String value = (p0 is XmlElement)?p0.name.toString():"node";
      List<String> check = ["info","shortinfo","page"];
      valid &= check.any((listElement) => listElement.contains(value));
      if(!valid) print("Module problem with $p0");
      super.acceptModule(module, verbose: verbose);
    }
  }
  void acceptSlideshow(XmlElement module, {bool verbose: false})
  {
    print("accept slideshow checker-visitor");
    for (var p0 in module.children) {
      //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
      String value = (p0 is XmlElement)?p0.name.toString():"node";
      List<String> check = ["info","shortinfo","slide"];
      valid &= check.any((listElement) => listElement.contains(value));
      if(!valid) print("Slideshow problem with $p0");
      super.acceptModule(module, verbose: verbose);
    }
  }
}
