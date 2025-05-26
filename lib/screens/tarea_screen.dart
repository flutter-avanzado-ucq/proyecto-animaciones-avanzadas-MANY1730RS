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
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
    _iconController.forward(from: 0);
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
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
              //esta previene que las animaciones se repitan cuando se hace scroll en la pantalla (automaticamente actualia la animacion)
              child: AnimationLimiter(
                //estas son las nuevas animaciones que vamos a usar en nuestra pantalla
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _tasks.length, //cantidad de tareas que tenemos
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    //aqui se define la posicion y la duracion de la animacion
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      //permite que cada  una de las tareas entren deslizando desde abajo
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        //permite que cada una de las tareas entren con un efecto de desvanecimiento
                        child: FadeInAnimation(
                          child: TaskCard(
                            title: task['title'],
                            isDone: task['done'],
                            onToggle: () => _toggleComplete(index),
                            onDelete: () => _removeTask(index),
                            iconRotation: _iconController,
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
        // aqui se define el icono que se va a mostrar en el boton flotante
        // y se le asigna la animacion que se va a usar
        // y necesita de un AnimationController para poder animar el icono. un cambio entre iconos evento y agregar tarea
        child: AnimatedIcon(
          //-CAMBIO DE ICONO ANIMADO-
          //cambie el add_event por ellipsis_search
          //para que el icono cambie de un icono de agregar tarea a un icono de busqueda
          icon: AnimatedIcons.search_ellipsis,
          progress: _iconController,
        ),
      ),
    );
  }
}
