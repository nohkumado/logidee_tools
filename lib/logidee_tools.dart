import 'package:xml/xml.dart';
//import 'dart:html';
import 'dart:io';

class LogideeTools
{
  void parse(String fname)
  {
    final file= File(fname);
    final document = XmlDocument.parse(file.readAsStringSync());

  }

}