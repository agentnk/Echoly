import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'pages/teleprompter_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    final titleBarStyle = Platform.isMacOS ? TitleBarStyle.hidden : TitleBarStyle.normal;

    final options = WindowOptions(
      size: const Size(1400, 860),
      minimumSize: const Size(980, 620),
      center: true,
      title: 'Echoly (Flutter)',
      backgroundColor: const Color(0xFFD9D9D9),
      titleBarStyle: titleBarStyle,
    );

    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setAlwaysOnTop(true);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const EcholyApp());
}

class EcholyApp extends StatelessWidget {
  const EcholyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Echoly',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFD9D9D9),
      ),
      home: const TeleprompterPage(),
    );
  }
}
