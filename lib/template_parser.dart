class TemplateParser {
  Map<String, dynamic> locals;
  String _name;

  TemplateParser(
    String name, {
    this.locals = const {},
  }) {
    _name = name;
    _initLocals();
  }

  String get name => _name;
  set name(String value) {
    _name = value;
    _initLocals();
  }

  void _initLocals() {
    locals.addAll({
      'Name': _name,
      'name': _name.toLowerCase(),
    });
  }

  String parse(String string) {
    var replacementMap = {
      for (var key in locals.keys) '{{$key}}': locals[key],
    };

    for (var key in replacementMap.keys) {
      string = string.replaceAll(key, replacementMap[key]);
    }

    return string;
  }
}
