import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // todas las nuevas animaciones son de esta dependencia
import '../widgets/card_tarea.dart';
import '../widgets/header.dart';
import '../widgets/add_task_sheet.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _tasks = [];
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _addTask(String task) {
    setState(() {
      _tasks.insert(0, {'title': task, 'done': false});
    });
  }

  void _toggleComplete(int index) {
    if (index >= 0 && index < _tasks.length) {
      setState(() {
        _tasks[index]['done'] = !_tasks[index]['done'];
      });
      _iconController.forward(from: 0);
    }
  }

  void _removeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      setState(() {
        _tasks.removeAt(index);
      });
    }
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddTaskSheet(onSubmit: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              // esta previene que las animaciones se repitan cuando se hace scroll en la pantalla (automáticamente actualiza la animación)
              child: AnimationLimiter(
                // estas son las nuevas animaciones que vamos a usar en nuestra pantalla
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _tasks.length, // cantidad de tareas que tenemos
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    // aquí se define la posición y la duración de la animación
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      // permite que cada una de las tareas entren deslizando desde abajo
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        // permite que cada una de las tareas entren con un efecto de desvanecimiento
                        child: FadeInAnimation(
                          // se define widget para deslizar tareas a la izquierda
                          child: Dismissible(
                            key: ValueKey(task['title']),
                            direction:
                                DismissDirection
                                    .endToStart, // deslizar de derecha a izquierda
                            onDismissed: (_) {
                              final removedTask = task;
                              _removeTask(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${removedTask['title']} eliminado',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: TaskCard(
                              title: task['title'],
                              isDone: task['done'],
                              onToggle: () => _toggleComplete(index),
                              onDelete: () => _removeTask(index),
                              iconRotation: _iconController,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        // aquí se define el icono que se va a mostrar en el botón flotante
        // y se le asigna la animación que se va a usar
        // y necesita de un AnimationController para poder animar el icono. un cambio entre iconos evento y agregar tarea
        child: AnimatedIcon(
          // -CAMBIO DE ICONO ANIMADO-
          // cambié el add_event por ellipsis_search
          // para que el icono cambie de un icono de agregar tarea a un icono de búsqueda
          icon: AnimatedIcons.search_ellipsis,
          progress: _iconController,
        ),
      ),
    );
  }
}
