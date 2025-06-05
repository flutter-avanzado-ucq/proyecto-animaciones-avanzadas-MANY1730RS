import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit; // Nuevo callback para editar
  final Animation<double> iconRotation;
  final DateTime? vencimiento;
  final ValueChanged<String> onTitleChanged;

  const TaskCard({
    super.key,
    required this.title,
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.iconRotation,
    required this.vencimiento,
    required this.onTitleChanged,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
  }

  @override
  void didUpdateWidget(covariant TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      _controller.text = widget.title;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: widget.isDone ? 0.4 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.isDone ? Colors.blue.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: GestureDetector(
            onTap: widget.onToggle,
            child: AnimatedBuilder(
              animation: widget.iconRotation,
              builder: (context, child) {
                return Transform.rotate(
                  angle:
                      widget.isDone ? widget.iconRotation.value * (pi / 2) : 0,
                  child: Icon(
                    widget.isDone
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: widget.isDone ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nombre de la tarea',
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  decoration: widget.isDone ? TextDecoration.lineThrough : null,
                  color: widget.isDone ? Colors.black54 : Colors.black87,
                  fontSize: 16,
                ),
                enabled: !widget.isDone,
                onChanged: widget.onTitleChanged,
              ),
              if (widget.vencimiento != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Vencimiento: ${DateFormat('dd/MM/yyyy').format(widget.vencimiento!)}',
                    style: TextStyle(
                      color: widget.isDone ? Colors.black54 : Colors.black87,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: widget.onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: widget.onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
