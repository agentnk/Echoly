import 'dart:collection';

class ScriptDocument {
  ScriptDocument({
    required this.fileName,
    required List<String> lines,
  }) : lines = UnmodifiableListView(lines);

  final String fileName;
  final List<String> lines;

  int get totalLines => lines.length;

  bool get isEmpty => lines.isEmpty;
}
