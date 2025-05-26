import 'dart:math';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Animation<double> iconRotation;

  const TaskCard({
    super.key,
    required this.title,
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
    required this.iconRotation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      //-CAMBIO DE OPACIDAD-
      // Cambia la opacidad del widget según el estado de isDone
      // Si isDone es true, la opacidad será 0.4, de lo contrario será 1.0
      opacity: isDone ? 0.4 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          //-CAMBIO DE COLOR DE FONDO-
          //se cambia el color de fondo de verde a color azul con un tono claro y sombra/opacidad a 200
          color: isDone ? Colors.blue.shade200 : Colors.white,
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
            onTap: onToggle,
            child: AnimatedBuilder(
              animation: iconRotation,
              builder: (context, child) {
                return Transform.rotate(
                  //-ROTACION DEL ICONO-
                  // El icono se rota según el valor de iconRotation
                  // si isDone es true, se rota el icono de check.
                  // se cambio para que tenga una rotacion de 90 grados
                  angle: isDone ? iconRotation.value * (pi / 2) : 0,
                  child: Icon(
                    isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isDone ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? Colors.black54 : Colors.black87,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
