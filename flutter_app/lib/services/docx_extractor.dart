import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

class DocxExtractor {
  const DocxExtractor();

  String extractText(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final documentFile = archive.files.firstWhere(
      (item) => item.name == 'word/document.xml',
      orElse: () => ArchiveFile('empty', 0, []),
    );

    if (!documentFile.isFile || documentFile.size == 0) {
      return '';
    }

    final xmlString = String.fromCharCodes(documentFile.content as List<int>);
    final document = XmlDocument.parse(xmlString);
    final paragraphNodes = document.findAllElements('w:p');
    final buffer = StringBuffer();

    for (final paragraph in paragraphNodes) {
      final textNodes = paragraph.findAllElements('w:t');
      final line = textNodes.map((node) => node.innerText).join('').trim();
      if (line.isNotEmpty) {
        buffer.writeln(line);
      }
    }

    return buffer.toString();
  }
}
