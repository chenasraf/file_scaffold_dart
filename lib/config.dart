import 'dart:convert';

import 'package:args/args.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

class TemplateConfig {
  final String pattern;
  final String baseDirectory;

  TemplateConfig({
    @required this.pattern,
    @required this.baseDirectory,
  });
}

class FileScaffoldConfig {
  /// Template name.
  ///
  /// This will automatically be available inside your templates as
  /// `{{Name}}` for exact value, or `{{name}}` for the name as a lower
  /// case string.
  ///
  /// This will also be the subfolder created when `createSubfolder == true`.
  String name;

  /// List of template configurations.
  List<TemplateConfig> templates;

  /// Directory to output to. Omit the template name. If you want it to be added
  /// to the path, use `createSubfolder` argument in your scaffold config
  String outputDirectory;

  /// Set this to `true` to create a subfolder to contain your files, using the `name` as
  /// the folder name. Default: `false`
  bool createSubfolder;

  /// Map of strings to use as replacement tokens. Your strings will be then available
  /// in the template as `{{key}}`. For example, if your key was `"version"`, your replacement
  /// token would be `{{version}}`. See [TemplateParser] for more information.
  Map<String, dynamic> locals;

  static ArgParser argParser = _createArgsParser();

  /// Config for creating a scaffold.
  ///
  /// You may specify glob strings as items in the `templates` list, which
  /// will create [TemplateConfig]s from these patterns.
  ///
  /// The `outputDirectory` argument is a path to the output directory in which
  /// to scaffold files inside. Omit the template name. If you want it to be added
  /// to the path, use `createSubfolder = true`.
  FileScaffoldConfig({
    @required this.name,
    @required Iterable<dynamic> templates,
    @required String outputDirectory,
    this.createSubfolder = false,
    this.locals = const {},
  })  : templates = _mapTemplates(templates),
        outputDirectory = _getAbsolute(outputDirectory);

  static String _getAbsolute(String path) =>
      isAbsolute(path) ? path : absolute(path);

  static _mapTemplates(Iterable<dynamic> templates) => [
        for (dynamic template in templates)
          template is TemplateConfig
              ? TemplateConfig(
                  pattern: _getAbsolute(template.pattern),
                  baseDirectory: _getAbsolute(template.baseDirectory),
                )
              : TemplateConfig(
                  pattern: _getAbsolute(template),
                  baseDirectory: _getAbsolute(dirname(template)),
                )
      ];

  /// Makes a copy of this config, with the specified properties overridden.
  copyWith({
    String name,
    List<String> templates,
    String outputDirectory,
    bool createSubfolder,
    Map<String, dynamic> locals,
  }) =>
      FileScaffoldConfig(
        name: name ?? this.name,
        templates: templates ?? this.templates,
        outputDirectory: outputDirectory ?? this.outputDirectory,
        createSubfolder: createSubfolder ?? this.createSubfolder,
        locals: locals ?? this.locals,
      );

  factory FileScaffoldConfig.fromArgs(List<String> args) {
    var parser = FileScaffoldConfig.argParser;
    var results = parser.parse(args);
    Map<String, dynamic> locals = {};
    for (String local in results['locals']) {
      var k = local.substring(0, local.indexOf('='));
      var v = local.substring(local.indexOf('=') + 1);
      try {
        v = json.decode(v);
      } catch (e) {
        //
      }
      locals[k] = v;
    }
    String name = results['name'] ?? results.rest.join(' ');
    if (results['output-dir'] == null ||
        results['templates'].isEmpty ||
        name.isEmpty) {
      throw ArgumentError.value(args, 'args', 'arguments are not valid');
    }

    return FileScaffoldConfig(
      name: name,
      templates: _mapTemplates(results['templates']),
      locals: locals,
      outputDirectory: results['output-dir'],
      createSubfolder: results['create-subfolder'],
    );
  }

  static void printHelp() {

  }

  static ArgParser _createArgsParser() {
    var argParser = ArgParser();
    argParser.addOption('name', abbr: 'n');
    argParser.addOption('output-dir', abbr: 'o');
    argParser.addFlag(
      'create-subfolder',
      abbr: 'C',
      defaultsTo: false,
      help:
          "Create subfolder at the output directory, using the scaffold's name.",
      negatable: true,
    );
    argParser.addMultiOption('templates',
        abbr: 't',
        help:
            'List of templates to get files from. You may supply a glob string to include only files using that pattern.',
        valueHelp: 'path/to/templates/**.json');
    argParser.addMultiOption(
      'locals',
      abbr: 'l',
      help: 'List of key-value mappings of locals to pass to the scaffold.',
      valueHelp: 'key="value" [, ...]',
    );
    argParser.addFlag(
      'help',
      abbr: 'h',
      help: 'This usage text.',
      negatable: false,
    );
    return argParser;
  }
}
