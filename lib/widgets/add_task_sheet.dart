import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/provider_task/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:tareas/services/notification_service.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

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

  void _submit() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      // 1. Agrega la tarea al provider
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).addTask(text, vencimiento: _selectFecha);

      // 2. Enviar notificación inmediata
      await NotificationService.showImmediateNotification(
        title: 'Nueva tarea',
        body: 'Has agregado la tarea: $text',
        payload: 'Tarea: $text',
      );

      // 3. Programar recordatorio si hay fecha
      if (_selectFecha != null) {
        await NotificationService.scheduleNotification(
          title: 'Recordatorio de tarea',
          body: 'No olvides: $text',
          scheduledDate: _selectFecha!,
          payload:
              'Tarea programada: $text para ${DateFormat('dd/MM/yyyy').format(_selectFecha!)}',
        );
      }

      Navigator.pop(context);
    }
  }

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
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Nombre de la tarea',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
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
