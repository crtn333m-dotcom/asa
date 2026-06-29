import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/canvas_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Color(0xFF0D0700),
  ));
  runApp(const SalalatiApp());
}

class SalalatiApp extends StatelessWidget {
  const SalalatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CanvasProvider(),
      child: MaterialApp(
        title: 'سلالتي',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFFC9A84C),
            surface: const Color(0xFF1A0F00),
          ),
          fontFamily: 'Cairo',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
