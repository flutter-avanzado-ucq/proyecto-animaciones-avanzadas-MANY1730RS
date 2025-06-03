import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/provider_task/task_provider.dart';
import 'package:intl/intl.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  //final Function(String) onSubmit;

  //const AddTaskSheet({super.key, required this.onSubmit});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _controller = TextEditingController();
  DateTime? _selectFecha;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //navegar entre pantallas
  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      // widget.onSubmit(text);
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).addTask(text, vencimiento: _selectFecha);
      Navigator.pop(context);
    }
  }
  // Método para mostrar un selector de fecha al usuario y guardar la fecha seleccionada en la variable _selectFecha.
  // Si el usuario selecciona una fecha, se actualiza el estado para reflejar el cambio en la interfaz.

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectFecha ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectFecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Agregar nueva tarea',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Fila que contiene un texto que muestra la fecha seleccionada o un mensaje por defecto si no hay fecha,
          // y un botón para abrir el selector de fecha (_pickDate).
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectFecha == null
                      ? 'Sin fecha seleccionada'
                      : 'Vencimiento: ${DateFormat('dd/MM/yyyy').format(_selectFecha!)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: _pickDate,
                child: const Text('Seleccionar fecha'),
              ),
            ],
          ),

          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.check),
            label: const Text('Agregar tarea'),
          ),
        ],
      ),
    );
  }
}
