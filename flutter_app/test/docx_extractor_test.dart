import 'dart:typed_data';

import 'package:echoly_flutter/services/docx_extractor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocxExtractor', () {
    test('throws format exception for invalid docx bytes', () {
      const extractor = DocxExtractor();

      expect(
        () => extractor.extractText(Uint8List.fromList([1, 2, 3, 4, 5])),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
