import 'package:flutter/material.dart';
import '../models/paso_pareja.dart';
import '../models/posicion_pie.dart';
import 'package:uuid/uuid.dart';

class PasosEjemplo {
  static const _uuid = Uuid();

  /// Básico de bachata (8 tiempos)
  static PasoPareja get basico {
    final now = DateTime.now();
    
    return PasoPareja(
      id: _uuid.v4(),
      nombre: 'Básico de Bachata',
      descripcion: 'Paso básico lateral de bachata. El líder va a su izquierda, el follower a su derecha.',
      tipo: TipoPaso.basico,
      dificultad: 1,
      color: Colors.blue,
      creado: now,
      modificado: now,
      etiquetas: ['básico', 'lateral', 'principiante'],
      frames: [
        // Tiempo 1
        FramePaso(
          tiempo: 1,
          leaderPieIzq: const PosicionPie(x: -0.3, y: 0, peso: true),
          leaderPieDer: PosicionPie.neutral,
          followerPieIzq: PosicionPie.neutral,
          followerPieDer: const PosicionPie(x: 0.3, y: 0, peso: true),
          nota: 'Leader pisa izquierda, Follower pisa derecha',
        ),
        // Tiempo 2
        FramePaso(
          tiempo: 2,
          leaderPieIzq: const PosicionPie(x: -0.3, y: 0),
          leaderPieDer: const PosicionPie(x: -0.15, y: 0, peso: true),
          followerPieIzq: const PosicionPie(x: 0.15, y: 0, peso: true),
          followerPieDer: const PosicionPie(x: 0.3, y: 0),
        ),
        // Tiempo 3
        FramePaso(
          tiempo: 3,
          leaderPieIzq: const PosicionPie(x: -0.3, y: 0, peso: true),
          leaderPieDer: const PosicionPie(x: -0.15, y: 0),
          followerPieIzq: const PosicionPie(x: 0.15, y: 0),
          followerPieDer: const PosicionPie(x: 0.3, y: 0, peso: true),
        ),
        // Tiempo 4 - Tap
        FramePaso(
          tiempo: 4,
          leaderPieIzq: const PosicionPie(x: -0.3, y: 0, peso: true),
          leaderPieDer: const PosicionPie(x: -0.3, y: 0, apoyado: true, peso: false),
          followerPieIzq: const PosicionPie(x: 0.3, y: 0, apoyado: true, peso: false),
          followerPieDer: const PosicionPie(x: 0.3, y: 0, peso: true),
          nota: 'Tap sin peso',
        ),
        // Tiempo 5 - Regreso
        FramePaso(
          tiempo: 5,
          leaderPieIzq: const PosicionPie(x: -0.3, y: 0),
          leaderPieDer: PosicionPie.neutral.copyWith(peso: true),
          followerPieIzq: PosicionPie.neutral.copyWith(peso: true),
          followerPieDer: const PosicionPie(x: 0.3, y: 0),
        ),
        // Tiempo 6
        FramePaso(
          tiempo: 6,
          leaderPieIzq: const PosicionPie(x: -0.15, y: 0, peso: true),
          leaderPieDer: PosicionPie.neutral,
          followerPieIzq: PosicionPie.neutral,
          followerPieDer: const PosicionPie(x: 0.15, y: 0, peso: true),
        ),
        // Tiempo 7
        FramePaso(
          tiempo: 7,
          leaderPieIzq: const PosicionPie(x: -0.15, y: 0),
          leaderPieDer: PosicionPie.neutral.copyWith(peso: true),
          followerPieIzq: PosicionPie.neutral.copyWith(peso: true),
          followerPieDer: const PosicionPie(x: 0.15, y: 0),
        ),
        // Tiempo 8 - Tap
        FramePaso(
          tiempo: 8,
          leaderPieIzq: const PosicionPie(x: 0, y: 0, apoyado: true, peso: false),
          leaderPieDer: PosicionPie.neutral.copyWith(peso: true),
          followerPieIzq: PosicionPie.neutral.copyWith(peso: true),
          followerPieDer: const PosicionPie(x: 0, y: 0, apoyado: true, peso: false),
          nota: 'Tap sin peso',
        ),
      ],
    );
  }

  /// Básico adelante y atrás
  static PasoPareja get basicoAdelanteAtras {
    final now = DateTime.now();
    
    return PasoPareja(
      id: _uuid.v4(),
      nombre: 'Básico Adelante/Atrás',
      descripcion: 'El líder va adelante en 1-2-3, el follower va atrás. Luego se invierten.',
      tipo: TipoPaso.adelanteAtras,
      dificultad: 1,
      color: Colors.green,
      creado: now,
      modificado: now,
      etiquetas: ['básico', 'adelante', 'atrás'],
      frames: [
        // Tiempo 1
        FramePaso(
          tiempo: 1,
          leaderPieIzq: const PosicionPie(x: -0.15, y: 0.3, peso: true),
          leaderPieDer: PosicionPie.neutral,
          followerPieIzq: PosicionPie.neutral,
          followerPieDer: const PosicionPie(x: 0.15, y: -0.3, peso: true),
          nota: 'Leader adelante, Follower atrás',
        ),
        // Tiempo 2
        FramePaso(
          tiempo: 2,
          leaderPieIzq: const PosicionPie(x: -0.15, y: 0.3),
          leaderPieDer: const PosicionPie(x: 0.15, y: 0.15, peso: true),
          followerPieIzq: const PosicionPie(x: -0.15, y: -0.15, peso: true),
          followerPieDer: const PosicionPie(x: 0.15, y: -0.3),
        ),
        // Tiempo 3
        FramePaso(
          tiempo: 3,
          leaderPieIzq: const PosicionPie(x: -0.15, y: 0.3, peso: true),
          leaderPieDer: const PosicionPie(x: 0.15, y: 0.15),
          followerPieIzq: const PosicionPie(x: -0.15, y: -0.15),
          followerPieDer: const PosicionPie(x: 0.15, y: -0.3, peso: true),
        ),
        // Tiempo 4 - Tap
        FramePaso(
          tiempo: 4,
          leaderPieIzq: const PosicionPie(x: -0.15, y: 0.3, peso: true),
          leaderPieDer: const PosicionPie(x: 0.15, y: 0.3, apoyado: true, peso: false),
          followerPieIzq: const PosicionPie(x: -0.15, y: -0.3, apoyado: true, peso: false),
          followerPieDer: const PosicionPie(x: 0.15, y: -0.3, peso: true),
        ),
        // Tiempo 5 - Regreso
        FramePaso(
          tiempo: 5,
          leaderPieIzq: const PosicionPie(x: -0.15, y: 0.3),
          leaderPieDer: const PosicionPie(x: 0.15, y: -0.3, peso: true),
          followerPieIzq: const PosicionPie(x: -0.15, y: 0.3, peso: true),
          followerPieDer: const PosicionPie(x: 0.15, y: -0.3),
          nota: 'Se invierten: Leader atrás, Follower adelante',
        ),
        // Tiempo 6
        FramePaso(
          tiempo: 6,
          leaderPieIzq: const PosicionPie(x: -0.15, y: -0.15, peso: true),
          leaderPieDer: const PosicionPie(x: 0.15, y: -0.3),
          followerPieIzq: const PosicionPie(x: -0.15, y: 0.3),
          followerPieDer: const PosicionPie(x: 0.15, y: 0.15, peso: true),
        ),
        // Tiempo 7
        FramePaso(
          tiempo: 7,
          leaderPieIzq: const PosicionPie(x: -0.15, y: -0.15),
          leaderPieDer: const PosicionPie(x: 0.15, y: -0.3, peso: true),
          followerPieIzq: const PosicionPie(x: -0.15, y: 0.3, peso: true),
          followerPieDer: const PosicionPie(x: 0.15, y: 0.15),
        ),
        // Tiempo 8 - Tap
        FramePaso(
          tiempo: 8,
          leaderPieIzq: const PosicionPie(x: -0.15, y: -0.3, apoyado: true, peso: false),
          leaderPieDer: const PosicionPie(x: 0.15, y: -0.3, peso: true),
          followerPieIzq: const PosicionPie(x: -0.15, y: 0.3, peso: true),
          followerPieDer: const PosicionPie(x: 0.15, y: 0.3, apoyado: true, peso: false),
        ),
      ],
    );
  }

  /// Giro simple a la derecha del follower
  static PasoPareja get giroSimple {
    final now = DateTime.now();
    
    return PasoPareja(
      id: _uuid.v4(),
      nombre: 'Giro Simple Derecha',
      descripcion: 'Giro del follower a su derecha mientras el líder hace básico.',
      tipo: TipoPaso.giro,
      dificultad: 2,
      color: Colors.orange,
      creado: now,
      modificado: now,
      etiquetas: ['giro', 'derecha', 'follower'],
      frames: [
        // Tiempo 1
        FramePaso(
          tiempo: 1,
          leaderPieIzq: const PosicionPie(x: -0.2, y: 0, peso: true),
          leaderPieDer: PosicionPie.neutral,
          followerPieIzq: PosicionPie.neutral,
          followerPieDer: const PosicionPie(x: 0.2, y: 0, peso: true),
          nota: 'Preparación para el giro',
        ),
        // Tiempo 2
        FramePaso(
          tiempo: 2,
          leaderPieIzq: const PosicionPie(x: -0.2, y: 0),
          leaderPieDer: PosicionPie.neutral.copyWith(peso: true),
          followerPieIzq: const PosicionPie(x: -0.2, y: 0.1, peso: true, rotacion: 45),
          followerPieDer: const PosicionPie(x: 0.2, y: 0),
          nota: 'Follower inicia giro',
        ),
        // Tiempo 3
        FramePaso(
          tiempo: 3,
          leaderPieIzq: const PosicionPie(x: -0.2, y: 0, peso: true),
          leaderPieDer: PosicionPie.neutral,
          followerPieIzq: const PosicionPie(x: -0.2, y: 0.1, rotacion: 90),
          followerPieDer: const PosicionPie(x: 0, y: 0, peso: true, rotacion: 90),
        ),
        // Tiempo 4 - Medio giro
        FramePaso(
          tiempo: 4,
          leaderPieIzq: const PosicionPie(x: -0.2, y: 0, peso: true),
          leaderPieDer: const PosicionPie(x: -0.2, y: 0, apoyado: true),
          followerPieIzq: const PosicionPie(x: 0, y: -0.1, peso: true, rotacion: 135),
          followerPieDer: const PosicionPie(x: 0.2, y: -0.1, apoyado: true, rotacion: 135),
        ),
        // Tiempo 5 - Completa giro
        FramePaso(
          tiempo: 5,
          leaderPieIzq: const PosicionPie(x: -0.2, y: 0),
          leaderPieDer: PosicionPie.neutral.copyWith(peso: true),
          followerPieIzq: const PosicionPie(x: 0.2, y: 0, rotacion: 180),
          followerPieDer: const PosicionPie(x: -0.2, y: 0, peso: true, rotacion: 180),
          nota: 'Follower completa el giro',
        ),
        // Tiempo 6
        FramePaso(
          tiempo: 6,
          leaderPieIzq: PosicionPie.neutral.copyWith(peso: true),
          leaderPieDer: PosicionPie.neutral,
          followerPieIzq: PosicionPie.neutral.copyWith(peso: true),
          followerPieDer: const PosicionPie(x: -0.2, y: 0, rotacion: 180),
        ),
        // Tiempo 7
        FramePaso(
          tiempo: 7,
          leaderPieIzq: PosicionPie.neutral,
          leaderPieDer: PosicionPie.neutral.copyWith(peso: true),
          followerPieIzq: PosicionPie.neutral,
          followerPieDer: PosicionPie.neutral.copyWith(peso: true),
        ),
        // Tiempo 8
        FramePaso(
          tiempo: 8,
          leaderPieIzq: PosicionPie.neutral.copyWith(apoyado: true),
          leaderPieDer: PosicionPie.neutral.copyWith(peso: true),
          followerPieIzq: PosicionPie.neutral.copyWith(apoyado: true),
          followerPieDer: PosicionPie.neutral.copyWith(peso: true),
        ),
      ],
    );
  }

  /// Obtener todos los pasos de ejemplo
  static List<PasoPareja> get todos => [
        basico,
        basicoAdelanteAtras,
        giroSimple,
      ];
}
