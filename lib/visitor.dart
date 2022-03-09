import 'package:xml/src/xml/nodes/declaration.dart';
import 'package:xml/src/xml/nodes/element.dart';
import 'package:xml/src/xml/nodes/node.dart';

class visitor
{
  String encoding = "UTF-8";
  String lang = "fr";
  String theme = "default";

  bool valid = true;

  void accept(XmlDeclaration desc)
  {
    encoding = desc.getAttribute("encoding")??"";
    lang = desc.getAttribute("lang")??"";
    theme = desc.getAttribute("lang")??"";
  }

   acceptFormation(XmlElement formation,{bool verbose: false})
   {
     for (var p0 in formation.children) {
       //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
       String value = (p0 is XmlElement)?p0.name.toString():"node";
       if(p0 is XmlElement)
       {
         if(value == "info") acceptInfo(p0,verbose:verbose);
         else if(value == "shortinfo") acceptInfo(p0,verbose:verbose);
         else if(value == "theme") acceptTheme(p0,verbose:verbose);
       }
       else
         {
           valid = false;
           print("formation unknown stuff: ${p0.runtimeType} $p0");
         }
     }
   }

  void acceptInfo(XmlElement node, {bool verbose: false})
  {
    for (var p0 in node.children) {
      //(p0 is XmlElement)? print("formation child: ${p0.name.toString()}"):print("formation unknown: $p0 of ${p0.runtimeType}");
      String value = (p0 is XmlElement)?p0.name.toString():"node";
      if(p0 is XmlElement)
      {
        if(value == "title") acceptTitle(p0,verbose:verbose);
        else if(value == "description") acceptDescription(p0,verbose:verbose);
        else if(value == "objectives") acceptObjectives(p0,verbose:verbose);
        else if(value == "dependency") acceptDependency(p0,verbose:verbose);
        else if(value == "suggestion") acceptSuggestion(p0,verbose:verbose);
        else if(value == "version") acceptVersion(p0,verbose:verbose);
        else if(value == "proofreades") acceptProofreaders(p0,verbose:verbose);
        else if(value == "ratio") acceptRatio(p0,verbose:verbose);
        else print("info unknown stuff: ${p0.runtimeType} $p0");
      }
      else
      {
        valid = false;
        print("info unknown stuff: ${p0.runtimeType} $p0");
      }
    }

  }

  void acceptTheme(XmlElement node, {bool verbose: false})
  {

  }

  void acceptTitle(XmlElement node, {bool verbose: false}) {}

  void acceptDescription(XmlElement node, {bool verbose: false})
  {
    for (var node in node.children) {
      //(node is XmlElement)? print("formation child: ${node.name.toString()}"):print("formation unknown: $node of ${node.runtimeType}");
      String value = (node is XmlElement)?node.name.toString():"node";
      if(node is XmlElement)
      {
        if(value == "para") acceptPara(node,verbose:verbose);
        else print("Description unknown stuff: ${node.runtimeType} $node");
      }
      else
      {
        valid = false;
        print("Description unknown stuff: ${node.runtimeType} $node");
      }
    }
  }

  void acceptObjectives(XmlElement node, {bool verbose: false})
  {
    for (var node in node.children) {
      //(node is XmlElement)? print("formation child: ${node.name.toString()}"):print("formation unknown: $node of ${node.runtimeType}");
      String value = (node is XmlElement)?node.name.toString():"node";
      if(node is XmlElement)
      {
        if(value == "item") acceptItem(node,verbose:verbose);
        else print("Objectives unknown stuff: ${node.runtimeType} $node");
      }
      else
      {
        valid = false;
        print("Objectives unknown stuff: ${node.runtimeType} $node");
      }
    }
  }

  void acceptDependency(XmlElement node, {bool verbose: false})
  {
  for (var node in node.children) {
  //(node is XmlElement)? print("formation child: ${node.name.toString()}"):print("formation unknown: $node of ${node.runtimeType}");
  String value = (node is XmlElement)?node.name.toString():"node";
  if(node is XmlElement)
  {
  if(value == "ref") acceptRef(node,verbose:verbose);
  else print("Dependency unknown stuff: ${node.runtimeType} $node");
  }
  else
  {
  valid = false;
  print("Dependency unknown stuff: ${node.runtimeType} $node");
  }
  }
  }

  void acceptSuggestion(XmlElement node, {bool verbose: false})
  {
  for (var node in node.children) {
  //(node is XmlElement)? print("formation child: ${node.name.toString()}"):print("formation unknown: $node of ${node.runtimeType}");
  String value = (node is XmlElement)?node.name.toString():"node";
  if(node is XmlElement)
  {
  if(value == "ref") acceptRef(node,verbose:verbose);
  else print("Suggestion unknown stuff: ${node.runtimeType} $node");
  }
  else
  {
  valid = false;
  print("Suggestion unknown stuff: ${node.runtimeType} $node");
  }
  }
  }

  void acceptVersion(XmlElement node, {bool verbose: false})
  {
    String number = node.getAttribute("number")??"";
    if(number.isEmpty)
      {
        valid = false;
    print("tag version needs a number");
      }
  for (var node in node.children) {
  //(node is XmlElement)? print("formation child: ${node.name.toString()}"):print("formation unknown: $node of ${node.runtimeType}");
  String value = (node is XmlElement)?node.name.toString():"node";
  if(node is XmlElement)
  {
  if(value == "author") acceptAuthor(node,verbose:verbose);
  else if(value == "email") acceptEmail(node,verbose:verbose);
  else if(value == "comment") acceptComment(node,verbose:verbose);
  else if(value == "date") acceptDate(node,verbose:verbose);
  else print("Version unknown stuff: ${node.runtimeType} $node");
  }
  else
  {
  valid = false;
  print("Version unknown stuff: ${node.runtimeType} $node");
  }
  }
}

void acceptProofreaders(XmlElement node, {bool verbose: false})
  {
  for (var node in node.children) {
  //(node is XmlElement)? print("formation child: ${node.name.toString()}"):print("formation unknown: $node of ${node.runtimeType}");
  String value = (node is XmlElement)?node.name.toString():"node";
  if(node is XmlElement)
  {
  if(value == "item") acceptItem(node,verbose:verbose);
  else print("Proofreades unknown stuff: ${node.runtimeType} $node");
  }
  else
  {
  valid = false;
  print("Proofreades unknown stuff: ${node.runtimeType} $node");
  }
  }
  }

  void acceptRatio(XmlElement node, {bool verbose: false}) {}

  void acceptPara(XmlElement node, {bool verbose: false}) {}

  void acceptItem(XmlElement node, {bool verbose: false}) {}

  void acceptRef(XmlElement node, {bool verbose: false}) {}

  void acceptAuthor(XmlElement node, {bool verbose: false}) {}
  void acceptEmail(XmlElement node, {bool verbose: false}) {
  }

  void acceptComment(XmlElement node, {bool verbose: false}) {}

  void acceptDate(XmlElement node, {bool verbose: false}) {}

}
