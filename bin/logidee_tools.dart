import 'dart:io';
import 'package:posix/posix.dart';
import 'package:path/path.dart' as path;

import 'package:logidee_tools/logidee_tools.dart';
import 'package:args/args.dart';

final separator = '/';
void main(List<String> arguments) {
  ArgParser args = ArgParser();
  LogideeTools parser = LogideeTools();

  args..addOption('file',
      abbr: 'f',
      help:
      "the xml file to parse");

  Map<String,dynamic> data = {};
  String usage = args.usage;
  data["error"] = false;
  List<String> rest = [];

  try {
    var argResults = args.parse(arguments);
    //print("applying args: lang:${argResults["lang"]} base:${argResults["base"]} out:${argResults["output"]} help:${argResults["help"]} strict:${argResults["strict"]}  rest: ${argResults.rest}");
    argResults.options.forEach((key) {
      var val = argResults[key];
      data["$key"] = (val == null) ? "null" : val;
    });
    rest = argResults.rest;
    //postprocessing
    if (data.containsKey("file") && data["file"].isNotEmpty) {
    }
  } catch (e) {
    //print("unknown arguments, please stick to:\n"+parser.usage);
    data["error"] = true;
    print(usage);
    exit(0);
  }
  if (data.containsKey("file")) {
    String fname = data['file'];
    fname = tildeExpansion(fname);
    fname = path.canonicalize(fname);
    parser.parse(fname);
  }
}
String tildeExpansion(String path){
  if(path.startsWith('~'))
  {
    List<String> parts = path.split(separator);
    if(parts[0] == '~') parts[0] = ((Platform.environment.containsKey('HOME'))?Platform.environment['HOME']:"")!;
    else {
      String user = parts[0].replaceAll('~', '');
      try {
        parts[0] = getpwnam(user).homePathTo;
      }
      catch(e){
        //print("failed to find user $user");
      }
    }
    path = parts.join(separator);
  }
  return path;
}
