import 'dart:convert';

/// Posición de un pie en el espacio
class PosicionPie {
  final double x; // -1 a 1 (izquierda a derecha)
  final double y; // -1 a 1 (atrás a adelante)
  final double rotacion; // grados (0-360)
  final bool apoyado; // si está en el suelo
  final bool peso; // si tiene el peso del cuerpo

  const PosicionPie({
    required this.x,
    required this.y,
    this.rotacion = 0,
    this.apoyado = true,
    this.peso = false,
  });

  // Posiciones predefinidas
  static const PosicionPie neutral = PosicionPie(x: 0, y: 0);
  static const PosicionPie izquierda = PosicionPie(x: -0.3, y: 0);
  static const PosicionPie derecha = PosicionPie(x: 0.3, y: 0);
  static const PosicionPie adelante = PosicionPie(x: 0, y: 0.3);
  static const PosicionPie atras = PosicionPie(x: 0, y: -0.3);

  PosicionPie copyWith({
    double? x,
    double? y,
    double? rotacion,
    bool? apoyado,
    bool? peso,
  }) {
    return PosicionPie(
      x: x ?? this.x,
      y: y ?? this.y,
      rotacion: rotacion ?? this.rotacion,
      apoyado: apoyado ?? this.apoyado,
      peso: peso ?? this.peso,
    );
  }

  // Serialización
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'rotacion': rotacion,
      'apoyado': apoyado,
      'peso': peso,
    };
  }

  factory PosicionPie.fromJson(Map<String, dynamic> json) {
    return PosicionPie(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      rotacion: (json['rotacion'] as num?)?.toDouble() ?? 0,
      apoyado: json['apoyado'] as bool? ?? true,
      peso: json['peso'] as bool? ?? false,
    );
  }

  @override
  String toString() {
    return 'PosicionPie(x: $x, y: $y, rot: $rotacion°, apoyado: $apoyado, peso: $peso)';
  }
}
