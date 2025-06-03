import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String title;
  bool done;
  DateTime? vencimiento; // Agregado para la fecha

  //practica se agrega parametro de fecha
  Task({required this.title, this.done = false, this.vencimiento});
}

//Es como el set state, cuando se llame desde otro widget se va a actualizar el dise;o
class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String title, {DateTime? vencimiento}) {
    _tasks.insert(0, Task(title: title));
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].done = !_tasks[index].done;
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTaskTitle(int index, String nuevoTitulo) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index].title = nuevoTitulo;
      notifyListeners();
    }
  }
}
