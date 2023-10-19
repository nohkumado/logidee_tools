import 'dart:io';
import 'dart:convert';

class Installer
{
  String configDir = ".";
  String lang = "de";
Map<String,dynamic> decoded = {};

  Installer({String? configdir, this.lang = "de"})
  {
    if(configdir != null && configdir.isNotEmpty) configDir = configdir;
    Directory outp = new Directory(configDir);
    if(!outp.existsSync()) {
      outp.create(recursive: true);
      print("created conf dir $configDir");
    }
  }

  void createConfig({bool rewrite = false})
  {
    String content = '''
{
  "slidetheme": "Berlin",
  "formation": {
    "title": "Default formation title",
    "author": "Author name",
    "formation_ref": "Default formation reference",
    "globaldescription": "Default formation description",
    "objectives": [ "default objective" ],
    "comment": "comment",
    "theme":
      [
        {
          "inline": true,
          "title": "Default formation title",
          "stitle": "notinlinefilename",
          "author": "Author name",
          "comment": "comment",
          "ref": "Default theme reference",
          "desc": "Default theme description",
          "objectives": [ "default objective" ],
          "module": [
            {
              "inline":false,
              "title": "Default module title",
              "stitle": "notinlinefilename",
              "author": "Author name",
              "comment": "comment",
              "ref": "Default theme reference",
              "desc": "Default theme description",
              "prerequisites": [ "requisite" ],
              "objectives": [ "default objective" ],
              "proofreaders": [ "someone" ]
           }
         ]
       }
    ]
  }
}
    ''';
    File outp = new File("$configDir/completions");
    if(rewrite)
    {
      print("overwriting $outp");
    var outsink = outp.openWrite();
    outsink.write(content);
    outsink.close();
    }
    else   print("file $outp exists, use -r to force rewrite");
  }
  void readConfig({String? path})
  {
    String locComp = "${(path != null && path.isNotEmpty)?"$path/":''}completions";
    print("checking existence of $locComp");
    File outp = new File(locComp);
    if(!outp.existsSync()) 
    { 
    print("$locComp not found.... switching to $configDir/completions");
      outp = new File("$configDir/completions"); 
    }
    if(!outp.existsSync()) {
      print("you should at least run install once..., and then ideally copy $configDir/completions into the local dir");
      return;
    }

    String content = outp.readAsStringSync();
    try{
    decoded = jsonDecode(content) as Map<String,dynamic>;
    }
    catch (e) { print("decoding of outp failed: $e, fix it!");}
  }

  void createFormation({required String projectName, bool rewrite = false})
  {
    print("about to create new formation $projectName!!");
    Directory outp = new Directory(projectName);
    if(!outp.existsSync()) {
      outp.createSync(recursive: true);
      print("created project dir $projectName");
    }
    else print("formation dir exists!");
    File conffile = File("$projectName/completions");
    print("######### does '$projectName/completions' exists! rewrite: $rewrite");
    if(!conffile.existsSync() || rewrite) 
    {
      print("no, creating configfile");
       readConfig();
       //var outsink = conffile.openWrite();
       //outsink.writeSync(jsonEncode(decoded));
       conffile.writeAsStringSync(jsonEncode(decoded));
    }
      else print("yes, reading local configfile");
    readConfig(path: projectName);
    String content = startFormation();
    //print("NEED to add : ${decoded["theme"]} from $decoded");
    List themes;
    if( decoded["formation"]["theme"] is String) 
    {
      themes = [];
      themes.add(decoded["formation"]["theme"]);
    }
    else themes = decoded["formation"]["theme"];
    //print("themes to add : $themes");
    for(Map<String,dynamic> one in themes)
    {
      if(one.containsKey("inline") && one["inline"])
	content += startTheme(theme: one, rewrite: rewrite)+endTheme();
      else
      {
      String fname = (one.containsKey("stitle"))?one["stitle"]: one["stitle"].trim().replaceAll(' ','_');
      fname += ".xml";
      print("need to write into $fname");
	content += "<xi:include href=\"$fname\"/>";
	File themeFile = File(fname);
	if(rewrite || !themeFile.exists()) themeFile.writeAsStringSync(startTheme(theme: one, rewrite: rewrite)+endTheme());
	else print("can't rewrite $fname");
      }
    }
    //print("content so far: $content");

  }
  String startFormation()
  {
    String result =  """
      <?xml version="1.0" encoding="UTF-8" standalone="no" lang="$lang" theme="${decoded["slidetheme"]}"?>
<!DOCTYPE formation PUBLIC "-//Logidee//DTD logidee-tools V1.2//EN" "../dtd/module.dtd">
<formation>
  <info>
    <title>${decoded["formation"]["title"]}</title>
    <ref>${decoded["formation"]["formation_ref"]}</ref>
    <description>
    """;
    if(decoded["formation"]["globaldescription"] is String)
      result += " <para>${decoded["formation"]["globaldescription"]}</para>\n";
    else if(decoded["formation"]["globaldescription"] is List)
      for(String para in decoded["formation"]["globaldescription"])
      result += " <para>${decoded["formation"]["globaldescription"]}</para>\n";
    else
      result += " <para>${decoded["formation"]["globaldescription"]}</para>\n";
    result += " </description>\n  <objectives>\n";
    if(decoded["formation"]["objectives"] is String)
      result += " <item>${decoded["formation"]["objectives"]}</item>\n";
    else if(decoded["formation"]["objectives"] is List)
      for(String item in decoded["formation"]["objectives"])
      result += " <item>${decoded["formation"]["objectives"]}</item>\n";
    result += """</objectives>
    <ratio value="50/50"/>
    <duration value="30" unit="h"/>
    <version number="0.0">
      <author>${decoded["formation"]["author"]}</author>
      <comment>${decoded["formation"]["comment"]}</comment>
    </version>
    <level value="1"/>
    <state finished="true" proofread="true"/>
  </info>
    """
      ;
    return result;
  }
  String endFormation() => "</formation>\n";

  String startTheme({required Map<String,dynamic> theme, bool rewrite = false})
  {
    String result =  """
<theme>
  <info>
    <title>${theme["title"]}</title>
    <ref>${theme["ref"]}</ref>
    <description>
    """;
    if(theme["desc"] is String)
      result += " <para>${theme["desc"]}</para>\n";
    else if(theme["desc"] is List)
      for(String para in theme["desc"])
      result += " <para>${theme["desc"]}</para>\n";
    else
      result += " <para>${theme["desc"]}</para>\n";
    result += " </description>\n  <objectives>\n";
    if(theme["objectives"] is String)
      result += " <item>${theme["objectives"]}</item>\n";
    else if(theme["objectives"] is List)
      for(String item in theme["objectives"])
      result += " <item>${theme["objectives"]}</item>\n";
    result += """</objectives>
    <ratio value="50/50"/>
    <duration value="30" unit="h"/>
    <version number="0.0">
      <author>${theme["author"]}</author>
      <comment>${theme["comment"]}</comment>
    </version>
    <level value="1"/>
    <state finished="true" proofread="true"/>
  </info>
    """
      ;
    List modules;
    if( theme["module"] is String) 
    {
      modules = [];
      modules.add(theme["module"]);
    }
    else modules = theme["module"];
    //print("themes to add : $themes");
    for(Map<String,dynamic> one in modules)
    {
      if(one.containsKey("inline") && one["inline"])
	content += startModule(module: one, rewrite: rewrite)+endModule();
      else
      {
      String fname = (one.containsKey("stitle"))?one["stitle"]: one["stitle"].trim().replaceAll(' ','_');
      fname += ".xml";
      print("need to write into $fname");
	content += "<xi:include href=\"$fname\"/>";
	File moduleFile = File(fname);
	if(rewrite || !moduleFile.exists()) moduleFile.writeAsStringSync(startModule(module: one, rewrite: rewrite)+endTheme());
	else print("can't rewrite $fname");
      }
    }
    return result;
  }
  String endTheme() => "</theme>\n";



  String startModule({required Map<String,dynamic> module, bool rewrite = false})
  {
    String result =  """
<module>
  <info>
    <title>${module["title"]}</title>
    <ref>${module["ref"]}</ref>
    <description>
    """;
    if(module["desc"] is String)
      result += " <para>${module["desc"]}</para>\n";
    else if(module["desc"] is List)
      for(String para in module["desc"])
      result += " <para>${module["desc"]}</para>\n";
    else
      result += " <para>${module["desc"]}</para>\n";
    result += " </description>\n  <objectives>\n";
    if(module["objectives"] is String)
      result += " <item>${module["objectives"]}</item>\n";
    else if(module["objectives"] is List)
      for(String item in module["objectives"])
      result += " <item>${module["objectives"]}</item>\n";
    result += """</objectives>
    <ratio value="50/50"/>
    <duration value="30" unit="h"/>
    <prerequisite>
    """;
    if(module["prerequisite"] is String)
      result += " <para>${module["prerequisite"]}</para>\n";
    else if(module["prerequisite"] is List)
      for(String para in module["prerequisite"])
      result += " <para>${module["prerequisite"]}</para>\n";
    result += """</prerequisite>
      result += """
      <dependency>
      </dependency>
      <suggestion>
      </suggestion>
    <version number="0.0">
      <author>${module["author"]}</author>
      <comment>${module["comment"]}</comment>
    </version>
    <level value="1"/>
    <state finished="true" proofread="true"/>
""";
    result += "<proofreaders>\n";
    if(module["proofreaders"] is String)
      result += " <item>${module["proofreaders"]}</item>\n";
    else if(module["proofreaders"] is List)
      for(String item in module["proofreaders"])
      result += " <item>${module["proofreaders"]}</item>\n";
    result += """
</proofreaders>
 </info>
    """ ;
    return result;
  }
  String endModule() => "</module>\n";
}
