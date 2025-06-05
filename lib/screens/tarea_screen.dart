import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/card_tarea.dart';
import '../widgets/header.dart';
import '../widgets/add_task_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tareas/provider_task/task_provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: Dismissible(
                            key: ValueKey(task.title),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => taskProvider.removeTask(index),
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
                                color: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: TaskCard(
                              key: ValueKey(task.title),
                              title: task.title,
                              isDone: task.done,
                              vencimiento: task.vencimiento,
                              onToggle: () {
                                taskProvider.toggleTask(index);
                                _iconController.forward(from: 0);
                              },
                              onDelete: () => taskProvider.removeTask(index),
                              iconRotation: _iconController,
                              onTitleChanged: (nuevoTitulo) {
                                taskProvider.updateTask(index, nuevoTitulo);
                              },
                              onEdit: () {
                                _showEditTaskDialog(context, index, task.title);
                              },
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
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: AnimatedIcon(
          icon: AnimatedIcons.add_event,
          progress: _iconController,
        ),
      ),
    );
  }
}

void _showEditTaskDialog(BuildContext context, int index, String currentTitle) {
  final taskProvider = context.read<TaskProvider>();
  final TextEditingController _controller = TextEditingController(
    text: currentTitle,
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nuevo título'),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              taskProvider.updateTask(index, value.trim());
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = _controller.text.trim();
              if (newTitle.isNotEmpty) {
                taskProvider.updateTask(index, newTitle);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}
