import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/controllers/app_controller.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ServisinAjaApp());
}

class ServisinAjaApp extends StatefulWidget {
  const ServisinAjaApp({super.key});

  @override
  State<ServisinAjaApp> createState() => _ServisinAjaAppState();
}

class _ServisinAjaAppState extends State<ServisinAjaApp> {
  final AppController _appController = AppController();

  @override
  void dispose() {
    _appController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appController,
      builder: (context, _) {
        return MaterialApp(
          title: 'ServisinAja',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _appController.themeMode,
          home: MainNavigationScreen(controller: _appController),
        );
      },
    );
  }
}
