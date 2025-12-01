import 'dart:convert';
import 'package:flutter/material.dart';
import 'posicion_pie.dart';

enum TipoPaso {
  basico,
  giro,
  lateral,
  adelanteAtras,
  cruzado,
  sensual,
  personalizado,
}

/// Frame individual que muestra las posiciones de ambos bailarines
class FramePaso {
  // Leader (hombre)
  final PosicionPie leaderPieIzq;
  final PosicionPie leaderPieDer;
  
  // Follower (mujer)
  final PosicionPie followerPieIzq;
  final PosicionPie followerPieDer;
  
  final int tiempo; // 1-8 en el compás
  final String? nota; // Nota opcional para este frame

  const FramePaso({
    required this.leaderPieIzq,
    required this.leaderPieDer,
    required this.followerPieIzq,
    required this.followerPieDer,
    required this.tiempo,
    this.nota,
  });

  // Serialización
  Map<String, dynamic> toJson() {
    return {
      'leaderPieIzq': leaderPieIzq.toJson(),
      'leaderPieDer': leaderPieDer.toJson(),
      'followerPieIzq': followerPieIzq.toJson(),
      'followerPieDer': followerPieDer.toJson(),
      'tiempo': tiempo,
      'nota': nota,
    };
  }

  factory FramePaso.fromJson(Map<String, dynamic> json) {
    return FramePaso(
      leaderPieIzq: PosicionPie.fromJson(json['leaderPieIzq']),
      leaderPieDer: PosicionPie.fromJson(json['leaderPieDer']),
      followerPieIzq: PosicionPie.fromJson(json['followerPieIzq']),
      followerPieDer: PosicionPie.fromJson(json['followerPieDer']),
      tiempo: json['tiempo'] as int,
      nota: json['nota'] as String?,
    );
  }

  FramePaso copyWith({
    PosicionPie? leaderPieIzq,
    PosicionPie? leaderPieDer,
    PosicionPie? followerPieIzq,
    PosicionPie? followerPieDer,
    int? tiempo,
    String? nota,
  }) {
    return FramePaso(
      leaderPieIzq: leaderPieIzq ?? this.leaderPieIzq,
      leaderPieDer: leaderPieDer ?? this.leaderPieDer,
      followerPieIzq: followerPieIzq ?? this.followerPieIzq,
      followerPieDer: followerPieDer ?? this.followerPieDer,
      tiempo: tiempo ?? this.tiempo,
      nota: nota ?? this.nota,
    );
  }
}

/// Paso completo de bachata en pareja
class PasoPareja {
  final String id;
  final String nombre;
  final String? descripcion;
  final TipoPaso tipo;
  final List<FramePaso> frames;
  final int dificultad; // 1-5
  final Color color;
  final DateTime creado;
  final DateTime modificado;
  final List<String> etiquetas;

  const PasoPareja({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.tipo,
    required this.frames,
    this.dificultad = 1,
    this.color = Colors.purple,
    required this.creado,
    required this.modificado,
    this.etiquetas = const [],
  });

  // Nombre del tipo de paso
  String get tipoNombre {
    switch (tipo) {
      case TipoPaso.basico:
        return 'Básico';
      case TipoPaso.giro:
        return 'Giro';
      case TipoPaso.lateral:
        return 'Lateral';
      case TipoPaso.adelanteAtras:
        return 'Adelante/Atrás';
      case TipoPaso.cruzado:
        return 'Cruzado';
      case TipoPaso.sensual:
        return 'Sensual';
      case TipoPaso.personalizado:
        return 'Personalizado';
    }
  }

  // Cantidad de tiempos
  int get cantidadTiempos => frames.length;

  // Serialización
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'tipo': tipo.name,
      'frames': frames.map((f) => f.toJson()).toList(),
      'dificultad': dificultad,
      'color': color.value,
      'creado': creado.toIso8601String(),
      'modificado': modificado.toIso8601String(),
      'etiquetas': etiquetas,
    };
  }

  factory PasoPareja.fromJson(Map<String, dynamic> json) {
    return PasoPareja(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      tipo: TipoPaso.values.firstWhere(
        (t) => t.name == json['tipo'],
        orElse: () => TipoPaso.personalizado,
      ),
      frames: (json['frames'] as List)
          .map((f) => FramePaso.fromJson(f as Map<String, dynamic>))
          .toList(),
      dificultad: json['dificultad'] as int? ?? 1,
      color: Color(json['color'] as int? ?? Colors.purple.value),
      creado: DateTime.parse(json['creado'] as String),
      modificado: DateTime.parse(json['modificado'] as String),
      etiquetas: (json['etiquetas'] as List?)?.cast<String>() ?? [],
    );
  }

  String toJsonString() => jsonEncode(toJson());
  
  factory PasoPareja.fromJsonString(String jsonStr) {
    return PasoPareja.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  PasoPareja copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    TipoPaso? tipo,
    List<FramePaso>? frames,
    int? dificultad,
    Color? color,
    DateTime? creado,
    DateTime? modificado,
    List<String>? etiquetas,
  }) {
    return PasoPareja(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      frames: frames ?? this.frames,
      dificultad: dificultad ?? this.dificultad,
      color: color ?? this.color,
      creado: creado ?? this.creado,
      modificado: modificado ?? this.modificado,
      etiquetas: etiquetas ?? this.etiquetas,
    );
  }
}
