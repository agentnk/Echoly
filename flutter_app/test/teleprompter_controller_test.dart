import 'package:echoly_flutter/controllers/teleprompter_controller.dart';
import 'package:echoly_flutter/models/script_document.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeleprompterController', () {
    test('uses default empty state', () {
      final controller = TeleprompterController();

      expect(controller.totalLines, 0);
      expect(controller.currentLineNumber, 0);
      expect(controller.activeLine, TeleprompterController.emptyMessage);
      expect(controller.progress, 0);
      expect(controller.isPlaying, false);
    });

    test('sets document and tracks progress while advancing', () {
      final controller = TeleprompterController();
      controller.setDocument(
        ScriptDocument(fileName: 'demo.txt', lines: ['one', 'two', 'three']),
      );

      expect(controller.fileName, 'demo.txt');
      expect(controller.activeLine, 'one');
      expect(controller.currentLineNumber, 1);
      expect(controller.progress, closeTo(1 / 3, 0.0001));

      controller.togglePlayPause();
      controller.advanceLine();

      expect(controller.currentLineNumber, 2);
      expect(controller.activeLine, 'two');
      expect(controller.progress, closeTo(2 / 3, 0.0001));
    });

    test('advances manually even when paused', () {
      final controller = TeleprompterController();
      controller.setDocument(
        ScriptDocument(fileName: 'demo.txt', lines: ['one', 'two']),
      );

      controller.advanceLine();
      expect(controller.currentLineNumber, 2);
    });

    test('clamps font size limits', () {
      final controller = TeleprompterController();

      for (var i = 0; i < 100; i++) {
        controller.increaseFont();
      }
      expect(controller.fontSize, 96);

      for (var i = 0; i < 100; i++) {
        controller.decreaseFont();
      }
      expect(controller.fontSize, 32);
    });
  });
}
