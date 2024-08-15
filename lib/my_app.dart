import 'package:flutter/material.dart';
import 'package:myapp/list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movie App',
      theme: ThemeData(
        brightness: Brightness.light,
        listTileTheme: ListTileThemeData(
          titleTextStyle: Theme.of(context).textTheme.labelMedium,
          subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const ListScreen(),
    );
  }
}
