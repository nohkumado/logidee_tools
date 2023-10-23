import 'dart:io';
import 'package:posix/posix.dart';
import 'package:path/path.dart' as path;

import 'package:logidee_tools/logidee_tools.dart';
import 'package:args/args.dart';
import '../lib/installation.dart';

final separator = '/';
///main entry point
void main(List<String> arguments) {
  ArgParser args = ArgParser();
  LogideeTools parser = LogideeTools();

  args..addOption('file',
      abbr: 'f',
      help: "the xml file to parse")
    ..addOption('lang',
        abbr: 'l',
        help: "override preferred language")
       ..addOption('create',
      abbr: 'c',
      help: "create a project")
       ..addOption('module',
      abbr: 'm',
      help: "create a module in a project")
       ..addFlag('install',
      abbr: 'i',
      help: "install sample project files")
       ..addFlag('reinstall',
      abbr: 'r',
      help: "force reinstall sample project files")
  ;

  Map<String,dynamic> data = {};
  String usage = args.usage;
  data["error"] = false;
  List<String> rest = [];

  try {
    var argResults = args.parse(arguments);
    //print("applying args: lang:${argResults["lang"]} base:${argResults["base"]} out:${argResults["output"]} help:${argResults["help"]} strict:${argResults["strict"]}  rest: ${argResults.rest}");
    for (var key in argResults.options) {
      var val = argResults[key];
      data[key] = (val == null) ? "null" : val;
    }
    rest = argResults.rest;
    //postprocessing
    if (data.containsKey("file") && data["file"].isNotEmpty) {
    }
  } catch (e) {
    print("unknown arguments, please stick to:");
    data["error"] = true;
    print(usage);
    exit(0);
  }
  
bool rewrite = (data.containsKey("reinstall") && data["reinstall"])?true:false;

  if (data.containsKey("file")) {
    String fname = data['file'];
    fname = tildeExpansion(fname);
    fname = path.canonicalize(fname);
    print("treating $fname");
    parser.loadXml(fname);
    print("loaded the xml $fname");
    //parser.parse();
    //print("parsed $fname");
    print("check formation.tex and run it with pdflatex formation");
  }
  else if(data.containsKey("create"))
  {
    String defaultPath = tildeExpansion("~/.config/logidee/");
    Installer installer = Installer(configdir: defaultPath, lang: data["lang"] ?? "en");
    //print("should create ${data["create"]} from $defaultPath");
    installer.createFormation(projectName: data["create"] , rewrite: rewrite);
  }
  else if(data.containsKey("install") && data.containsKey("install"))
  {
    String defaultPath = tildeExpansion("~/.config/logidee/");
    Installer installer = Installer(configdir: defaultPath, lang: data["lang"] ?? "en");
    installer.createConfig(rewrite:rewrite );
    print("should create ${defaultPath} install dir");

  }
  else 
  {
    print("You should at least provide an action to perform:");
    print(usage);
    exit(0);
  }
}
///allow for tile expansion if needed, standard dart is unable to perform it on its own
String tildeExpansion(String path){
  if(path.startsWith('~'))
  {
    List<String> parts = path.split(separator);
    if(parts[0] == '~') {
      parts[0] = ((Platform.environment.containsKey('HOME'))?Platform.environment['HOME']:"")!;
    } else {
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
