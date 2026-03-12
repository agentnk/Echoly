import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../models/script_document.dart';
import '../models/script_load_result.dart';
import 'docx_extractor.dart';

class ScriptLoader {
  ScriptLoader({DocxExtractor? docxExtractor})
      : _docxExtractor = docxExtractor ?? const DocxExtractor();

  static const List<String> supportedExtensions = ['txt', 'docx'];

  final DocxExtractor _docxExtractor;

  Future<ScriptLoadResult> pickAndLoad() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: supportedExtensions,
      );

      if (result == null || result.files.isEmpty) {
        return const ScriptLoadResult.cancelled();
      }

      final file = result.files.single;
      final filePath = file.path;
      if (filePath == null) {
        return const ScriptLoadResult.failure('Could not resolve selected file path.');
      }

      final rawText = await _readFile(filePath);
      final lines = rawText
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      return ScriptLoadResult.success(
        ScriptDocument(
          fileName: p.basename(filePath),
          lines: lines.isEmpty ? const ['The selected file is empty.'] : lines,
        ),
      );
    } on FormatException catch (error) {
      return ScriptLoadResult.failure(error.message);
    } catch (_) {
      return const ScriptLoadResult.failure('Unable to open the selected file.');
    }
  }

  Future<String> _readFile(String path) async {
    final extension = p.extension(path).toLowerCase();

    if (extension == '.txt') {
      return File(path).readAsString();
    }

    if (extension == '.docx') {
      final bytes = await File(path).readAsBytes();
      return _docxExtractor.extractText(bytes);
    }

    throw const FormatException('Unsupported file type. Please choose .txt or .docx');
  }
}
