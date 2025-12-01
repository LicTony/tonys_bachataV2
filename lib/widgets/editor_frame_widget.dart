import 'package:flutter/material.dart';
import '../models/paso_pareja.dart';
import '../models/posicion_pie.dart';
import 'dart:math' as math;

class EditorFrameWidget extends StatefulWidget {
  final FramePaso frame;
  final ValueChanged<FramePaso> onChanged;

  const EditorFrameWidget({
    super.key,
    required this.frame,
    required this.onChanged,
  });

  @override
  State<EditorFrameWidget> createState() => _EditorFrameWidgetState();
}

class _EditorFrameWidgetState extends State<EditorFrameWidget> {
  late FramePaso _frameActual;
  String _pieSeleccionado = 'leader_izq'; // leader_izq, leader_der, follower_izq, follower_der

  @override
  void initState() {
    super.initState();
    _frameActual = widget.frame;
  }

  @override
  void didUpdateWidget(EditorFrameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.frame != widget.frame) {
      _frameActual = widget.frame;
    }
  }

  void _actualizarPosicion(String pie, PosicionPie nuevaPosicion) {
    FramePaso nuevoFrame;
    
    switch (pie) {
      case 'leader_izq':
        nuevoFrame = _frameActual.copyWith(leaderPieIzq: nuevaPosicion);
        break;
      case 'leader_der':
        nuevoFrame = _frameActual.copyWith(leaderPieDer: nuevaPosicion);
        break;
      case 'follower_izq':
        nuevoFrame = _frameActual.copyWith(followerPieIzq: nuevaPosicion);
        break;
      case 'follower_der':
        nuevoFrame = _frameActual.copyWith(followerPieDer: nuevaPosicion);
        break;
      default:
        return;
    }

    setState(() => _frameActual = nuevoFrame);
    widget.onChanged(nuevoFrame);
  }

  PosicionPie _obtenerPosicion(String pie) {
    switch (pie) {
      case 'leader_izq':
        return _frameActual.leaderPieIzq;
      case 'leader_der':
        return _frameActual.leaderPieDer;
      case 'follower_izq':
        return _frameActual.followerPieIzq;
      case 'follower_der':
        return _frameActual.followerPieDer;
      default:
        return PosicionPie.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector de pie
            Text(
              'Editar pie:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPieSelector('leader_izq', 'L Izq', Colors.blue),
                _buildPieSelector('leader_der', 'L Der', Colors.lightBlue),
                _buildPieSelector('follower_izq', 'F Izq', Colors.pink),
                _buildPieSelector('follower_der', 'F Der', Colors.pinkAccent),
              ],
            ),
            const SizedBox(height: 16),

            // Vista del piso
            Text(
              'Posición en el piso:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildPisoEditor(),
            const SizedBox(height: 16),

            // Controles de posición
            _buildControlesPosicion(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieSelector(String id, String label, Color color) {
    final isSelected = _pieSeleccionado == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _pieSeleccionado = id);
        }
      },
      selectedColor: color.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? color : null,
        fontWeight: isSelected ? FontWeight.bold : null,
      ),
    );
  }

  Widget _buildPisoEditor() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: GestureDetector(
        onPanUpdate: (details) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(details.globalPosition);
          final size = box.size;

          // Convertir a coordenadas -1 a 1
          final x = (localPosition.dx / size.width) * 2 - 1;
          final y = -((localPosition.dy / size.height) * 2 - 1); // Invertir Y

          final posicionActual = _obtenerPosicion(_pieSeleccionado);
          _actualizarPosicion(
            _pieSeleccionado,
            posicionActual.copyWith(
              x: x.clamp(-1.0, 1.0),
              y: y.clamp(-1.0, 1.0),
            ),
          );
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: _PisoPainter(
            leaderIzq: _frameActual.leaderPieIzq,
            leaderDer: _frameActual.leaderPieDer,
            followerIzq: _frameActual.followerPieIzq,
            followerDer: _frameActual.followerPieDer,
            pieSeleccionado: _pieSeleccionado,
          ),
        ),
      ),
    );
  }

  Widget _buildControlesPosicion() {
    final posicion = _obtenerPosicion(_pieSeleccionado);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Posiciones rápidas
        Text(
          'Posiciones rápidas:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildBotonPosicion('Centro', PosicionPie.neutral),
            _buildBotonPosicion('Izquierda', PosicionPie.izquierda),
            _buildBotonPosicion('Derecha', PosicionPie.derecha),
            _buildBotonPosicion('Adelante', PosicionPie.adelante),
            _buildBotonPosicion('Atrás', PosicionPie.atras),
          ],
        ),
        const SizedBox(height: 16),

        // Rotación
        Row(
          children: [
            Text('Rotación: ${posicion.rotacion.toInt()}°'),
            Expanded(
              child: Slider(
                value: posicion.rotacion,
                min: 0,
                max: 360,
                divisions: 72,
                label: '${posicion.rotacion.toInt()}°',
                onChanged: (value) {
                  _actualizarPosicion(
                    _pieSeleccionado,
                    posicion.copyWith(rotacion: value),
                  );
                },
              ),
            ),
          ],
        ),

        // Switches
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                title: const Text('Apoyado'),
                value: posicion.apoyado,
                onChanged: (value) {
                  _actualizarPosicion(
                    _pieSeleccionado,
                    posicion.copyWith(apoyado: value),
                  );
                },
              ),
            ),
            Expanded(
              child: SwitchListTile(
                title: const Text('Con peso'),
                value: posicion.peso,
                onChanged: (value) {
                  _actualizarPosicion(
                    _pieSeleccionado,
                    posicion.copyWith(peso: value),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBotonPosicion(String label, PosicionPie posicion) {
    return ElevatedButton(
      onPressed: () => _actualizarPosicion(_pieSeleccionado, posicion),
      child: Text(label),
    );
  }
}

class _PisoPainter extends CustomPainter {
  final PosicionPie leaderIzq;
  final PosicionPie leaderDer;
  final PosicionPie followerIzq;
  final PosicionPie followerDer;
  final String pieSeleccionado;

  _PisoPainter({
    required this.leaderIzq,
    required this.leaderDer,
    required this.followerIzq,
    required this.followerDer,
    required this.pieSeleccionado,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dibujar grid
    _dibujarGrid(canvas, size);

    // Dibujar pies
    _dibujarPie(canvas, size, leaderIzq, Colors.blue, 'leader_izq' == pieSeleccionado, 'L-I');
    _dibujarPie(canvas, size, leaderDer, Colors.lightBlue, 'leader_der' == pieSeleccionado, 'L-D');
    _dibujarPie(canvas, size, followerIzq, Colors.pink, 'follower_izq' == pieSeleccionado, 'F-I');
    _dibujarPie(canvas, size, followerDer, Colors.pinkAccent, 'follower_der' == pieSeleccionado, 'F-D');
  }

  void _dibujarGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
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

    // Centro
    paint
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  void _dibujarPie(Canvas canvas, Size size, PosicionPie posicion, Color color, 
                   bool seleccionado, String label) {
    // Convertir coordenadas -1..1 a píxeles
    final x = (posicion.x + 1) * size.width / 2;
    final y = (-posicion.y + 1) * size.height / 2; // Invertir Y

    final paint = Paint()
      ..color = color.withOpacity(posicion.apoyado ? 0.8 : 0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = seleccionado ? Colors.white : color
      ..style = PaintingStyle.stroke
      ..strokeWidth = seleccionado ? 3 : 2;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(posicion.rotacion * math.pi / 180);

    // Dibujar pie (forma elíptica)
    final path = Path();
    path.addOval(Rect.fromCenter(
      center: Offset.zero,
      width: 40,
      height: 60,
    ));

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Indicador de peso
    if (posicion.peso) {
      final pesoPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, 8, pesoPaint);
    }

    canvas.restore();

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: seleccionado ? Colors.white : color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
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
  bool shouldRepaint(_PisoPainter oldDelegate) => true;
}
