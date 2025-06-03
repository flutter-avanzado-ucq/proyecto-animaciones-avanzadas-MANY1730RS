// main.dart
import 'package:flutter/material.dart';
import 'screens/tarea_screen.dart';
import 'tema/tema_app.dart';
import 'package:provider/provider.dart';
import 'provider_task/task_provider.dart' as task_provider;

void main() {
  runApp(
    ChangeNotifierProvider(
      create:
          (_) => task_provider.TaskProvider(), //aqui se inicializa el provider
      child: const MyApp(), //aqui manda a llamar a la clase MyApp
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tareas Pro',
      theme: AppTheme.theme,
      home: const TaskScreen(), //aqui manda a llamar a la clase TaskScreen
    );
  }
}
