class ScriptDocument {
  const ScriptDocument({
    required this.fileName,
    required this.lines,
  });

  final String fileName;
  final List<String> lines;

  int get totalLines => lines.length;

  bool get isEmpty => lines.isEmpty;
}
