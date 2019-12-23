import 'package:file_scaffold/file_scaffold.dart';

void main(List<String> args) async {
  /// Create the configuration for your scaffold.
  ///
  /// If you only need to directly parse aruments from
  /// command line, you can use the `fromArgs` method,
  /// which will create a scaffold from the  regular arguments.
  var parsed = FileScaffoldConfig.fromArgs(args); // ignore: unused_local_variable

  /// Otherwise, you can supply the needed arguments yourself,
  /// in case you need to manipulate them in any way:
  var config = FileScaffoldConfig(
    name: 'Test',
    outputDirectory: 'sample_files/output',
    templates: ['sample_files/**'],
    locals: {'version': '1.0.0'},
  );

  /// Then, create the scaffold object:
  var scaffold = FileScaffold(config);

  /// And then run it:
  await scaffold.run();
}
