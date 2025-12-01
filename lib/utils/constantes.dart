import 'package:flutter/material.dart';

/// Constantes de la aplicación
class Constantes {
  // Colores predefinidos para pasos
  static const List<Color> coloresDisponibles = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
  ];

  // Duraciones
  static const Duration duracionFrameDefault = Duration(milliseconds: 500);
  static const Duration duracionTransicion = Duration(milliseconds: 300);

  // Tamaños
  static const double tamanioPie = 50.0;
  static const double radioBorde = 12.0;
  static const double espaciado = 16.0;

  // Textos
  static const String appName = 'Tony\'s Bachata V2';
  static const String appVersion = '1.0.0';
  static const String appDescription = 
      'Diccionario visual de pasos de bachata en pareja';

  // SharedPreferences keys
  static const String keyPrimerUso = 'primer_uso';
  static const String keyTemaOscuro = 'tema_oscuro';
  static const String keyVelocidadReproduccion = 'velocidad_reproduccion';

  // Validaciones
  static const int nombreMinLength = 2;
  static const int nombreMaxLength = 50;
  static const int descripcionMaxLength = 500;
  static const int maxEtiquetas = 10;

  // Mensajes
  static const String mensajeGuardadoExitoso = 'Paso guardado correctamente';
  static const String mensajeEliminadoExitoso = 'Paso eliminado';
  static const String mensajeErrorGuardar = 'Error al guardar el paso';
  static const String mensajeErrorEliminar = 'Error al eliminar el paso';
  static const String mensajeErrorCargar = 'Error al cargar los pasos';
  static const String mensajeCamposVacios = 'Completa todos los campos obligatorios';
}

/// Extensión para colores
extension ColorExtension on Color {
  /// Convierte el color a un string hexadecimal
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  
  /// Crea un color desde un string hexadecimal
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
