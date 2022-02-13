import 'package:xml/xml.dart';
//import 'dart:html';
import 'dart:io';
import 'package:path/path.dart' as path;

class LogideeTools
{
  String dirname = "";
  void parse(String fname)
  {
    dirname = path.dirname(fname);
    if(dirname.isNotEmpty)dirname += path.separator;
    final file= File(fname);
    final document = XmlDocument.parse(file.readAsStringSync());
    //print("parsed doc = $document");
    document.findAllElements('xi:include').forEach((toInc) =>processInclude(toInc));

   bool ignore = true;
   document.descendants.forEach((node) {
     if (ignore) { if (node is XmlDoctype) ignore = false; }
     else processNode(node);
   });

  }
/// replace recursively the xi:include by the file given in the href
  void processInclude(XmlElement toInc) {
    String href = (toInc.getAttribute("href")!= null)?toInc.getAttribute("href")!:"";
    if(href.isNotEmpty)
    {
      final file= File(dirname+href);
      var inclusion = XmlDocument.parse(file.readAsStringSync());
      inclusion.findAllElements('xi:include').forEach((toInc) =>processInclude(toInc));
      List<XmlElement> list = [];
      inclusion.children.forEach((p0) { if(p0 is XmlElement) list.add(p0);});
      if(list.length > 1) print("Error!!! $href contains more than one element!!");
      if(list.length >0) {
        XmlElement replacement =list[0];
        if(replacement.hasParent) replacement.detachParent(replacement.parent!);
        toInc.replace(replacement);
      }
    }
  }

  void processNode(XmlNode node) {
    if (node is XmlAttribute)
      print("found attribute :${node.text}");
    else if (node is XmlCDATA)
      print("found CDATA :${node.text}");
    else if (node is XmlComment) {
      //print("found comment :${node.text}");
    } else if (node is XmlDeclaration)
      print("found Declaration :${node.text}");
    else if (node is XmlDoctype)
      print("found Doctype :${node.text}");
    else if (node is XmlDocument)
      print("found Document :${node.text}");
    else if (node is XmlDocumentFragment)
      print("found DocumentFragment :${node.text}");
    else if (node is XmlElement) processElement(node);
    else if (node is XmlProcessing)
      print("found XmlProcessing :${node.text}");
    else if (node is XmlText) processTxt(node);
    else
      print(
          "found unknown node t:${node.nodeType} txt:${node.text} txt:${node
              .innerText}");
    
    
  }

  void processElement(XmlElement node) {
    print("found XmlElement :${node.name} ");
    node.attributes.forEach((element) {
      print("att: $element");
    });
  }

  void processTxt(XmlText node) {
    //ignore empty nodes
    if(node.text.trim().isNotEmpty) print("found XmlText : '${node.text}'");
  }
}