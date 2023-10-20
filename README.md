# Dart Logidee tools parser

an attempt to continue to use the logidee tools to maintain my presentations

ATM the dart xml library does not support validation, so with errors you are on your own....
still shipping the dtd though, in case one day this functionality appears


```dart bin/logidee_tools.dart --help
-f, --file    the xml file to parse
-l, --lang    override preferred language
-c, --create            create a project
-m, --module            create a module in a project
-i, --[no-]install      install sample project files
-r, --[no-]reinstall    force reinstall sample project files
```

### compile for your platform

```
dart compile exe bin/logidee_tools.dart -o ~/bin/logidee
```

