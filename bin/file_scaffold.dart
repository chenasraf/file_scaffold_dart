import 'dart:io';
import 'package:file_scaffold/file_scaffold.dart';

void main(List<String> args) {
  var res = FileScaffoldConfig.argParser.parse(args);

  if (res['help']) {
    print(FileScaffoldConfig.argParser.usage);
    exit(0);
  }
  try {
    var config = FileScaffoldConfig.fromArgs(args);
    FileScaffold(config).run();
  } on ArgumentError {
    print('Problem parsing the input arguments.');
    print(FileScaffoldConfig.argParser.usage);
    exit(0);
  }
}
