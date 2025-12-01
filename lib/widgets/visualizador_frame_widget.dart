import 'package:flutter/material.dart';
import '../models/paso_pareja.dart';
import '../models/posicion_pie.dart';
import 'dart:math' as math;

class VisualizadorFrameWidget extends StatelessWidget {
  final FramePaso frame;
  final Color color;

  const VisualizadorFrameWidget({
    super.key,
    required this.frame,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Indicador de tiempo
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tiempo ${frame.tiempo}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ),

        // Vista del piso
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.withOpacity(0.05),
              ),
              child: CustomPaint(
                size: Size.infinite,
                painter: _VisualizadorPisoPainter(
                  leaderIzq: frame.leaderPieIzq,
                  leaderDer: frame.leaderPieDer,
                  followerIzq: frame.followerPieIzq,
                  followerDer: frame.followerPieDer,
                  color: color,
                ),
              ),
            ),
          ),
        ),

        // Leyenda
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLeyendaItem(
                        context,
                        'L Izq',
                        Colors.blue,
                      ),
                      _buildLeyendaItem(
                        context,
                        'L Der',
                        Colors.lightBlue,
                      ),
                      _buildLeyendaItem(
                        context,
                        'F Izq',
                        Colors.pink,
                      ),
                      _buildLeyendaItem(
                        context,
                        'F Der',
                        Colors.pinkAccent,
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Peso',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sin apoyo',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Notas (si las hay)
        if (frame.nota != null && frame.nota!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: color.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.note, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        frame.nota!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLeyendaItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.6),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _VisualizadorPisoPainter extends CustomPainter {
  final PosicionPie leaderIzq;
  final PosicionPie leaderDer;
  final PosicionPie followerIzq;
  final PosicionPie followerDer;
  final Color color;

  _VisualizadorPisoPainter({
    required this.leaderIzq,
    required this.leaderDer,
    required this.followerIzq,
    required this.followerDer,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dibujar grid de referencia
    _dibujarGrid(canvas, size);

    // Dibujar línea de división leader/follower
    _dibujarDivision(canvas, size);

    // Dibujar pies
    _dibujarPie(canvas, size, leaderIzq, Colors.blue, 'L-I');
    _dibujarPie(canvas, size, leaderDer, Colors.lightBlue, 'L-D');
    _dibujarPie(canvas, size, followerIzq, Colors.pink, 'F-I');
    _dibujarPie(canvas, size, followerDer, Colors.pinkAccent, 'F-D');
  }

  void _dibujarGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    // Líneas verticales
    for (int i = 0; i <= 4; i++) {
      final x = size.width * i / 4;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Líneas horizontales
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _dibujarDivision(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Línea horizontal en el centro
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Texto "Leader"
    final textPainterLeader = TextPainter(
      text: TextSpan(
        text: 'LEADER',
        style: TextStyle(
          color: Colors.blue.withOpacity(0.3),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterLeader.layout();
    textPainterLeader.paint(
      canvas,
      Offset(
        size.width / 2 - textPainterLeader.width / 2,
        size.height * 0.25 - textPainterLeader.height / 2,
      ),
    );

    // Texto "Follower"
    final textPainterFollower = TextPainter(
      text: TextSpan(
        text: 'FOLLOWER',
        style: TextStyle(
          color: Colors.pink.withOpacity(0.3),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterFollower.layout();
    textPainterFollower.paint(
      canvas,
      Offset(
        size.width / 2 - textPainterFollower.width / 2,
        size.height * 0.75 - textPainterFollower.height / 2,
      ),
    );
  }

  void _dibujarPie(Canvas canvas, Size size, PosicionPie posicion, 
                   Color color, String label) {
    // Convertir coordenadas -1..1 a píxeles
    final x = (posicion.x + 1) * size.width / 2;
    final y = (-posicion.y + 1) * size.height / 2; // Invertir Y

    final paint = Paint()
      ..color = color.withOpacity(posicion.apoyado ? 0.8 : 0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Sombra si está apoyado
    if (posicion.apoyado) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.save();
      canvas.translate(x + 2, y + 2);
      canvas.rotate(posicion.rotacion * math.pi / 180);

      final shadowPath = Path();
      shadowPath.addOval(Rect.fromCenter(
        center: Offset.zero,
        width: 50,
        height: 75,
      ));

      canvas.drawPath(shadowPath, shadowPaint);
      canvas.restore();
    }

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(posicion.rotacion * math.pi / 180);

    // Dibujar pie (forma de zapato)
    final path = Path();
    path.addOval(Rect.fromCenter(
      center: Offset.zero,
      width: 50,
      height: 75,
    ));

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Indicador de punta (pequeño círculo)
    final puntaPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(0, -25), 5, puntaPaint);

    // Indicador de peso (círculo blanco en el centro)
    if (posicion.peso) {
      final pesoPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 10, pesoPaint);
      
      final pesoBorderPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset.zero, 10, pesoBorderPaint);
    }

    canvas.restore();

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_VisualizadorPisoPainter oldDelegate) {
    return oldDelegate.leaderIzq != leaderIzq ||
           oldDelegate.leaderDer != leaderDer ||
           oldDelegate.followerIzq != followerIzq ||
           oldDelegate.followerDer != followerDer;
  }
}
