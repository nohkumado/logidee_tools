# Dart Logidee tools parser

an attempt to continue to use the [logidee tools](http://www.logidee.com/doku.php/outils/start) to maintain my presentations

ATM the dart xml library does not support validation, so with errors you are on your own....
The parser will try to report if there is malformed XML, i tried to report on missing or invalid envs
but there are still errors you might make that aren't accounted for


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

### Unit testing and function reference

in the test library are unit tests that allow to check if the compiler works correctly
used for testing but also for your convenience, sample formations with all available functionality  are in the
assets directory


### Usage

if you run the thing for the first time, you need to run with --install so as to install the conf files.
Other wise go to the directory you want your new formation installed, and create it.

This will create formation.xml, a module file and completions. you might want to edit completions (its a json structure) and run with reinstall to adjust the files and contents 
with what you put into completions, in case your editor isn't able to prettyprint the json:

```
#!/usr/bin/perl
use strict;
use warnings;

use JSON;

local $/;
print to_json ( decode_json ( <> ), {pretty => 1 });
```

or 

```
#!/usr/bin/env ruby
require 'json'

# filename present as argument?
if ARGV.empty?
  puts "Usage: #{$PROGRAM_NAME} <filename>"
  exit 1
end

filename = ARGV[0]

json_data = File.read(filename)

parsed_data = JSON.parse(json_data)
formatted_json = JSON.pretty_generate(parsed_data)

puts formatted_json
```

once you are in a directory with a formation.xml file you can run 

for example:

```
TRAINER=true logidee -f formation.xml 
```

The parser will evenutally report if it doesn't like the xml and where, and otherwise guide you for the rest
