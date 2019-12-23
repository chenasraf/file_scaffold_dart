library file_scaffold;
import 'dart:io';
import 'package:glob/glob.dart';
import 'package:file_scaffold/config.dart';
import 'package:file_scaffold/template_parser.dart';
import 'package:path/path.dart';
export 'package:file_scaffold/config.dart';
export 'package:file_scaffold/template_parser.dart';
import 'package:pedantic/pedantic.dart';

class FileScaffold {
  FileScaffoldConfig config;
  TemplateParser parser;

  /// Create a scaffold with the given config.
  ///
  /// You can start the scaffolding process by using `run()`.
  FileScaffold(this.config)
      : parser = TemplateParser(
          config.name,
          locals: config.locals,
        );

  /// Lists all file paths for a given [TemplateConfig].
  Stream<String> inputFiles(TemplateConfig template) async* {
    Glob glob = Glob(template.pattern);
    await for (FileSystemEntity file in glob.list()) {
      if (!Directory(file.path).existsSync()) {
        yield absolute(file.path);
      }
    }
  }

  /// Lists all [TemplateConfigs] for this scaffold.
  Iterable<TemplateConfig> get templates => config.templates;

  /// Iterates through all the template files and begins parsing their contents,
  /// then outputting the new contents to the [config.outputDirectory].
  Future<void> run() async {
    for (var template in templates) {
      await for (String file in inputFiles(template)) {
        await _parseFile(template, file);
      }
    }
  }

  String _outputPath(TemplateConfig template, String file) {
    return join(
      config.outputDirectory,
      file.substring(file.indexOf(template.baseDirectory) +
          template.baseDirectory.length +
          1),
      config.createSubfolder ? config.name : null,
    );
  }

  _parseFile(TemplateConfig template, String file) async {
    print('Parsing: $file');

    if (!await File(file).exists()) {
      throw ArgumentError.value(file, 'file', 'does not exist');
    }
    var raw = await File(file).readAsString();
    var outputFilePath = parser.parse(_outputPath(template, file));
    var outputFileDir = Directory(dirname(outputFilePath));
    var contents = parser.parse(raw);
    print('Output path: $outputFilePath');
    print('Contents: ${contents.replaceAll('\n', '\\n').replaceAll('\t', '\\t')}');
    if (!await outputFileDir.exists()) {
      print('Creating directory: ${outputFileDir.path}');
      await outputFileDir.create(recursive: true);
    }
    unawaited(File(outputFilePath).writeAsString(contents));
  }
}
