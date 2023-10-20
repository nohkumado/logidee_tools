import 'dart:convert';
import 'dart:io';

class Installer {
  String configDir = ".";
  String lang = "de";
  Map<String, dynamic> decoded = {};

  Installer({String? configdir, this.lang = "de"}) {
    if (configdir != null && configdir.isNotEmpty) configDir = configdir;
    Directory outp = Directory(configDir);
    if (!outp.existsSync()) {
      outp.create(recursive: true);
      if (!outp.existsSync()) {
        print(
            "failed to create conf dir $configDir, run mkdir -p $configDir manually");
        exit(0);
      } else
        print("created conf dir $configDir");
    }
  }

  void createConfig({bool rewrite = false}) {
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
    File outp = File("$configDir/completions");
    if (rewrite) {
      print("overwriting $outp");
      var outsink = outp.openWrite();
      outsink.write(content);
      outsink.close();
    } else {
      print("file $outp exists, use -r to force rewrite");
    }
  }

  bool readConfig({String? path}) {
    String locComp =
        "${(path != null && path.isNotEmpty) ? "$path/" : ''}completions";
    File outp = File(locComp);
    if (!outp.existsSync()) {
      outp = File("$configDir/completions");
    }
    if (!outp.existsSync()) {
      print(
          "you should at least run install once..., and then ideally copy $configDir/completions into the project dir");
      return false;
    }

    String content = outp.readAsStringSync();
    try {
      decoded = jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      print("decoding of outp failed: $e, fix it!");
      return false;
    }
    return true;
  }

  void createFormation({required String projectName, bool rewrite = false}) {
    //print("about to create new formation $projectName!!");
    Directory outp = Directory(projectName);
    if (!outp.existsSync()) {
      outp.createSync(recursive: true);
      if (!outp.existsSync()) {
        print(
            "failed to create project dir $projectName, run mkdir -p $projectName manually");
        exit(0);
      } else
        print("created project dir $projectName");
    }
    File conffile = File("$projectName/completions");
    if (!conffile.existsSync() || rewrite) {
      if (!readConfig()) exit(0);
      conffile.writeAsStringSync(jsonEncode(decoded));
    }
    if (!readConfig(path: projectName)) exit(0);
    String content = startFormation();
    List themes;
    if (decoded["formation"]["theme"] is String) {
      themes = [];
      themes.add(decoded["formation"]["theme"]);
    } else {
      themes = decoded["formation"]["theme"];
    }
    //print("themes to add : $themes");
    for (Map<String, dynamic> one in themes) {
      if (one.containsKey("inline") && one["inline"]) {
        content += startTheme(path: projectName, theme: one, rewrite: rewrite) +
            endTheme();
      } else {
        String fname = (one.containsKey("stitle"))
            ? one["stitle"]
            : one["stitle"].trim().replaceAll(' ', '_');
        fname += ".xml";
        content += '<xi:include href="$fname"/>\n';
        File themeFile = File("$projectName/$fname");
        if (rewrite || !(themeFile.existsSync())) {
          themeFile.writeAsStringSync(
              startTheme(path: projectName, theme: one, rewrite: rewrite) +
                  endTheme());
        } else {
          print("can't rewrite $projectName/$fname");
        }
      }
    }
    content += endFormation();
    File formationFile = File("$projectName/formation.xml");
    if (rewrite || !(formationFile.existsSync())) {
      formationFile.writeAsStringSync(content);
      print("now cd into $projectName, fill out the xml file(s) and then run  logidee -f formation.xml");
    } else {
      print("can't rewrite $projectName/formation.xml");
    }
  }

  String startFormation() {
    String result = """
<?xml version="1.0" encoding="UTF-8" standalone="no" lang="$lang" theme="${decoded["slidetheme"]}"?>
<!DOCTYPE formation PUBLIC "-//Logidee//DTD logidee-tools V1.2//EN" "../dtd/module.dtd">
<formation>
  <info>
    <title>${decoded["formation"]["title"]}</title>
    <ref>${decoded["formation"]["formation_ref"]}</ref>
    <description>
    """;
    if (decoded["formation"]["globaldescription"] is String) {
      result += " <para>${decoded["formation"]["globaldescription"]}</para>\n";
    } else if (decoded["formation"]["globaldescription"] is List)
      for (String para in decoded["formation"]["globaldescription"]) {
        result += " <para>$para</para>\n";
      }
    else
      result += " <para>${decoded["formation"]["globaldescription"]}</para>\n";
    result += " </description>\n  <objectives>\n";
    if (decoded["formation"]["objectives"] is String) {
      result += " <item>${decoded["formation"]["objectives"]}</item>\n";
    } else if (decoded["formation"]["objectives"] is List)
      for (String item in decoded["formation"]["objectives"]) {
        result += " <item>$item</item>\n";
      }
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
    """;
    return result;
  }

  String endFormation() => "</formation>\n";

  String startTheme(
      {required Map<String, dynamic> theme,
      bool rewrite = false,
      required String path}) {
    String result = """
<theme>
  <info>
    <title>${theme["title"]}</title>
    <ref>${theme["ref"]}</ref>
    <description>
    """;
    if (theme["desc"] is String) {
      result += " <para>${theme["desc"]}</para>\n";
    } else if (theme["desc"] is List)
      for (String para in theme["desc"]) {
        result += " <para>$para</para>\n";
      }
    else
      result += " <para>${theme["desc"]}</para>\n";
    result += " </description>\n  <objectives>\n";
    if (theme["objectives"] is String) {
      result += " <item>${theme["objectives"]}</item>\n";
    } else if (theme["objectives"] is List)
      for (String item in theme["objectives"]) {
        result += " <item>$item</item>\n";
      }
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
    """;
    List modules;
    if (theme["module"] is String) {
      modules = [];
      modules.add(theme["module"]);
    } else {
      modules = theme["module"];
    }
    //print("themes to add : $themes");
    for (Map<String, dynamic> one in modules) {
      if (one.containsKey("inline") && one["inline"]) {
        result += startModule(module: one, rewrite: rewrite) + endModule();
      } else {
        String fname = (one.containsKey("stitle"))
            ? one["stitle"]
            : one["stitle"].trim().replaceAll(' ', '_');
        fname += ".xml";
        result += '<xi:include href="$fname"/>\n';
        File moduleFile = File("$path/$fname");
        if (rewrite || !moduleFile.existsSync()) {
          moduleFile.writeAsStringSync(
              startModule(module: one, rewrite: rewrite) + endModule());
        } else {
          print("can't rewrite $fname");
        }
      }
    }
    return result;
  }

  String endTheme() => "</theme>\n";

  String startModule(
      {required Map<String, dynamic> module, bool rewrite = false}) {
    String result = """
<module>
  <info>
    <title>${module["title"]}</title>
    <ref>${module["ref"]}</ref>
    <description>
    """;
    if (module["desc"] is String) {
      result += " <para>${module["desc"]}</para>\n";
    } else if (module["desc"] is List)
      for (String para in module["desc"]) {
        result += " <para>$para</para>\n";
      }
    else
      result += " <para>${module["desc"]}</para>\n";
    result += " </description>\n  <objectives>\n";
    if (module["objectives"] is String) {
      result += " <item>${module["objectives"]}</item>\n";
    } else if (module["objectives"] is List)
      for (String item in module["objectives"]) {
        result += " <item>$item</item>\n";
      }
    result += """</objectives>
    <ratio value="50/50"/>
    <duration value="30" unit="h"/>
    <prerequisite>
    """;
    if (module["prerequisite"] is String) {
      result += " <para>${module["prerequisite"]}</para>\n";
    } else if (module["prerequisite"] is List)
      for (String para in module["prerequisite"]) {
        result += " <para>$para</para>\n";
      }
    result += """
      </prerequisite>
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
    if (module["proofreaders"] is String) {
      result += " <item>${module["proofreaders"]}</item>\n";
    } else if (module["proofreaders"] is List)
      for (String item in module["proofreaders"]) {
        result += " <item>$item</item>\n";
      }
    result += """
</proofreaders>
 </info>
 <page>
         <title>Welcome</title>
         <section>
         <title>Introduction</title>
            <section>
              <title>Generated slide</title>
              <para>
              each section givs a line on our slide.
              </para>
            </section>
            <section>
              <title>next line on the slide </title>
              <para>fill up the page</para>
            </section>
          </section>
         </page>
         <page> 
            <title>using slide</title>
           <slide>
            <title>Create a slide manually</title>
            <para>
              <image src="image1.eps" visible="true"/>
              <image src="image2.eps" visible="true"/>
            </para>
            <list>
                <item> item1 </item>
                <item> item2 </item>
                <item><para><url href="https://en.wikipedia.org/"/></para></item>
            </list>
           </slide>
         </page>
    """;
    return result;
  }

  String endModule() => "</module>\n";
}
