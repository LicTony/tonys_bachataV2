import 'package:flutter/material.dart';
import 'dart:async';
import '../models/paso_pareja.dart';
import '../widgets/visualizador_frame_widget.dart';

class DetallePasoScreen extends StatefulWidget {
  final PasoPareja paso;

  const DetallePasoScreen({super.key, required this.paso});

  @override
  State<DetallePasoScreen> createState() => _DetallePasoScreenState();
}

class _DetallePasoScreenState extends State<DetallePasoScreen> {
  int _frameActual = 0;
  bool _reproduciendo = false;
  Timer? _timer;
  double _velocidad = 1.0; // 0.5x, 1x, 1.5x, 2x

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _reproducir() {
    if (_reproduciendo) {
      _pausar();
      return;
    }

    setState(() => _reproduciendo = true);

    // Duración base por frame (500ms)
    final duracionBase = Duration(milliseconds: (500 / _velocidad).round());

    _timer = Timer.periodic(duracionBase, (timer) {
      setState(() {
        _frameActual = (_frameActual + 1) % widget.paso.frames.length;
      });
    });
  }

  void _pausar() {
    _timer?.cancel();
    setState(() => _reproduciendo = false);
  }

  void _reiniciar() {
    _pausar();
    setState(() => _frameActual = 0);
  }

  void _cambiarVelocidad() {
    setState(() {
      if (_velocidad == 0.5) {
        _velocidad = 1.0;
      } else if (_velocidad == 1.0) {
        _velocidad = 1.5;
      } else if (_velocidad == 1.5) {
        _velocidad = 2.0;
      } else {
        _velocidad = 0.5;
      }
    });

    if (_reproduciendo) {
      _pausar();
      _reproducir();
    }
  }

  void _irAlFrame(int index) {
    _pausar();
    setState(() => _frameActual = index);
  }

  @override
  Widget build(BuildContext context) {
    final frame = widget.paso.frames[_frameActual];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paso.nombre),
      ),
      body: Column(
        children: [
          // Información del paso
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: widget.paso.color.withOpacity(0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _iconoPorTipo(widget.paso.tipo),
                      color: widget.paso.color,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.paso.nombre,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${widget.paso.tipoNombre} • ${widget.paso.cantidadTiempos} tiempos',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    _buildDificultad(),
                  ],
                ),
                if (widget.paso.descripcion != null && 
                    widget.paso.descripcion!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.paso.descripcion!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (widget.paso.etiquetas.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.paso.etiquetas.map((etiqueta) {
                      return Chip(
                        label: Text(etiqueta),
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        padding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Visualizador de frames
          Expanded(
            child: VisualizadorFrameWidget(
              frame: frame,
              color: widget.paso.color,
            ),
          ),

          // Controles de reproducción
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Timeline
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.paso.frames.length,
                    itemBuilder: (context, index) {
                      final isActual = index == _frameActual;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () => _irAlFrame(index),
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                              color: isActual
                                  ? widget.paso.color
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActual
                                    ? widget.paso.color
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActual
                                      ? Colors.white
                                      : Theme.of(context).textTheme.bodyLarge?.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Botones de control
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Reiniciar
                    IconButton(
                      icon: const Icon(Icons.replay),
                      iconSize: 32,
                      onPressed: _reiniciar,
                    ),
                    const SizedBox(width: 16),

                    // Frame anterior
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 32,
                      onPressed: () {
                        _pausar();
                        setState(() {
                          _frameActual = _frameActual > 0
                              ? _frameActual - 1
                              : widget.paso.frames.length - 1;
                        });
                      },
                    ),
                    const SizedBox(width: 16),

                    // Play/Pause
                    Container(
                      decoration: BoxDecoration(
                        color: widget.paso.color,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _reproduciendo ? Icons.pause : Icons.play_arrow,
                        ),
                        color: Colors.white,
                        iconSize: 48,
                        onPressed: _reproducir,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Frame siguiente
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      iconSize: 32,
                      onPressed: () {
                        _pausar();
                        setState(() {
                          _frameActual = (_frameActual + 1) % widget.paso.frames.length;
                        });
                      },
                    ),
                    const SizedBox(width: 16),

                    // Velocidad
                    TextButton.icon(
                      icon: const Icon(Icons.speed),
                      label: Text('${_velocidad}x'),
                      onPressed: _cambiarVelocidad,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDificultad() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < widget.paso.dificultad ? Icons.star : Icons.star_border,
          size: 20,
          color: Colors.amber,
        );
      }),
    );
  }

  IconData _iconoPorTipo(TipoPaso tipo) {
    switch (tipo) {
      case TipoPaso.basico:
        return Icons.adjust;
      case TipoPaso.giro:
        return Icons.rotate_right;
      case TipoPaso.lateral:
        return Icons.swap_horiz;
      case TipoPaso.adelanteAtras:
        return Icons.swap_vert;
      case TipoPaso.cruzado:
        return Icons.close;
      case TipoPaso.sensual:
        return Icons.favorite;
      case TipoPaso.personalizado:
        return Icons.star;
    }
  }
}
