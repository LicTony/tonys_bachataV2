import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/paso_pareja.dart';

/// Repositorio para gestionar la persistencia de pasos
class PasoRepository {
  static const String _keyPasos = 'pasos_bachata';
  static const String _keyPrimerUso = 'primer_uso';
  
  // Singleton
  static final PasoRepository _instance = PasoRepository._internal();
  factory PasoRepository() => _instance;
  PasoRepository._internal();
  
  SharedPreferences? _prefs;
  
  /// Inicializar SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  /// Verificar si es el primer uso y cargar pasos de ejemplo
  Future<bool> esPrimerUso() async {
    await init();
    return _prefs!.getBool(_keyPrimerUso) ?? true;
  }
  
  /// Marcar que ya no es el primer uso
  Future<void> marcarPrimerUsoCompletado() async {
    await init();
    await _prefs!.setBool(_keyPrimerUso, false);
  }
  
  /// Cargar pasos de ejemplo
  Future<bool> cargarPasosEjemplo(List<PasoPareja> pasosEjemplo) async {
    try {
      await init();
      
      final pasosExistentes = await obtenerTodos();
      
      // Solo cargar si no hay pasos
      if (pasosExistentes.isEmpty) {
        for (final paso in pasosEjemplo) {
          await guardar(paso);
        }
        await marcarPrimerUsoCompletado();
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error al cargar pasos de ejemplo: $e');
      return false;
    }
  }
  
  /// Obtener todos los pasos
  Future<List<PasoPareja>> obtenerTodos() async {
    await init();
    
    final jsonList = _prefs!.getStringList(_keyPasos) ?? [];
    
    return jsonList.map((jsonStr) {
      try {
        return PasoPareja.fromJsonString(jsonStr);
      } catch (e) {
        print('Error al parsear paso: $e');
        return null;
      }
    }).whereType<PasoPareja>().toList();
  }
  
  /// Obtener un paso por ID
  Future<PasoPareja?> obtenerPorId(String id) async {
    final pasos = await obtenerTodos();
    try {
      return pasos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Guardar un paso (crear o actualizar)
  Future<bool> guardar(PasoPareja paso) async {
    try {
      await init();
      
      final pasos = await obtenerTodos();
      
      // Buscar si ya existe
      final index = pasos.indexWhere((p) => p.id == paso.id);
      
      if (index >= 0) {
        // Actualizar existente
        pasos[index] = paso.copyWith(
          modificado: DateTime.now(),
        );
      } else {
        // Agregar nuevo
        pasos.add(paso);
      }
      
      // Guardar
      final jsonList = pasos.map((p) => p.toJsonString()).toList();
      return await _prefs!.setStringList(_keyPasos, jsonList);
      
    } catch (e) {
      print('Error al guardar paso: $e');
      return false;
    }
  }
  
  /// Eliminar un paso
  Future<bool> eliminar(String id) async {
    try {
      await init();
      
      final pasos = await obtenerTodos();
      pasos.removeWhere((p) => p.id == id);
      
      final jsonList = pasos.map((p) => p.toJsonString()).toList();
      return await _prefs!.setStringList(_keyPasos, jsonList);
      
    } catch (e) {
      print('Error al eliminar paso: $e');
      return false;
    }
  }
  
  /// Limpiar todos los pasos
  Future<bool> limpiarTodo() async {
    await init();
    return await _prefs!.remove(_keyPasos);
  }
  
  /// Obtener pasos por tipo
  Future<List<PasoPareja>> obtenerPorTipo(TipoPaso tipo) async {
    final pasos = await obtenerTodos();
    return pasos.where((p) => p.tipo == tipo).toList();
  }
  
  /// Buscar pasos por nombre o descripción
  Future<List<PasoPareja>> buscar(String query) async {
    if (query.isEmpty) return obtenerTodos();
    
    final pasos = await obtenerTodos();
    final queryLower = query.toLowerCase();
    
    return pasos.where((p) {
      return p.nombre.toLowerCase().contains(queryLower) ||
             (p.descripcion?.toLowerCase().contains(queryLower) ?? false) ||
             p.etiquetas.any((tag) => tag.toLowerCase().contains(queryLower));
    }).toList();
  }
}
