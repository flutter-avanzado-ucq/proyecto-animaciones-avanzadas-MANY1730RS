# tareas

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


CAMBIOS 



//-CAMBIO DE COLOR DE FONDO-
//se cambia el color de fondo de verde a color azul con un tono claro y sombra/opacidad a 200
color: isDone ? Colors.blue.shade200 : Colors.white,

//-CAMBIO DE OPACIDAD-
// Cambia la opacidad del widget según el estado de isDone
// Si isDone es true, la opacidad será 0.4, de lo contrario será 1.0
opacity: isDone ? 0.4 : 1.0,


//-ROTACION DEL ICONO-
// El icono se rota según el valor de iconRotation
// si isDone es true, se rota el icono de check. 
// se cambio para que tenga una rotacion de 90 grados porque ya se encontraba en 180 grados
angle: isDone ? iconRotation.value * (pi / 2) : 0,


//-CAMBIO DE ICONO ANIMADO-
//cambie el add_event por ellipsis_search
//para que el icono cambie de un icono de agregar tarea a un icono de busqueda
icon: AnimatedIcons.search_ellipsis,