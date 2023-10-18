class Installer
{

  void createConfig({required String path})
  {
    String content = '''
    { 
      "theme": "Berlin",
	"formation": {
	  "title": "Default formation title",·
	    "author": "Author name",·
	    "formation_ref": "Default formation reference",·
	    "globaldescription": "Default formation description",·
	    "objectives": [ "default objective" ],
	    "comment": "comment",
	    "theme":
	    {
	      "title": "Default formation title",·
		"author": "Author name",·
		"comment": "comment",
	      "ref": "Default theme reference",·
		"desc": "Default theme description",·
		"objectives": [ "default objective" ],
	    }
	}
    }
    ''';
    File outp = new File(path);
    var outsink = outp.openWrite();
    outsink.write(content);
    outsink.close();
  }
}
