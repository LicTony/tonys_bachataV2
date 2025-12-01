import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/paso_pareja.dart';
import '../models/posicion_pie.dart';
import '../services/paso_repository.dart';
import '../widgets/editor_frame_widget.dart';

class EditorPasoScreen extends StatefulWidget {
  final PasoPareja? paso;

  const EditorPasoScreen({super.key, this.paso});

  @override
  State<EditorPasoScreen> createState() => _EditorPasoScreenState();
}

class _EditorPasoScreenState extends State<EditorPasoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final PasoRepository _repository = PasoRepository();
  
  late String _id;
  late TipoPaso _tipoSeleccionado;
  late int _dificultad;
  late Color _color;
  late List<FramePaso> _frames;
  late List<String> _etiquetas;
  int _frameActual = 0;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.paso != null) {
      // Editando paso existente
      _id = widget.paso!.id;
      _nombreController.text = widget.paso!.nombre;
      _descripcionController.text = widget.paso!.descripcion ?? '';
      _tipoSeleccionado = widget.paso!.tipo;
      _dificultad = widget.paso!.dificultad;
      _color = widget.paso!.color;
      _frames = List.from(widget.paso!.frames);
      _etiquetas = List.from(widget.paso!.etiquetas);
    } else {
      // Creando nuevo paso
      _id = const Uuid().v4();
      _tipoSeleccionado = TipoPaso.basico;
      _dificultad = 1;
      _color = Colors.purple;
      _frames = _crearFramesBasicos();
      _etiquetas = [];
    }
  }

  List<FramePaso> _crearFramesBasicos() {
    // Crear 8 frames básicos (un compás completo)
    return List.generate(8, (index) {
      return FramePaso(
        leaderPieIzq: PosicionPie.neutral,
        leaderPieDer: PosicionPie.neutral,
        followerPieIzq: PosicionPie.neutral,
        followerPieDer: PosicionPie.neutral,
        tiempo: index + 1,
      );
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarPaso() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_frames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes agregar al menos un frame')),
      );
      return;
    }

    setState(() => _guardando = true);

    final now = DateTime.now();
    final paso = PasoPareja(
      id: _id,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim().isEmpty 
          ? null 
          : _descripcionController.text.trim(),
      tipo: _tipoSeleccionado,
      frames: _frames,
      dificultad: _dificultad,
      color: _color,
      creado: widget.paso?.creado ?? now,
      modificado: now,
      etiquetas: _etiquetas,
    );

    final exitoso = await _repository.guardar(paso);

    setState(() => _guardando = false);

    if (exitoso) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el paso')),
        );
      }
    }
  }

  void _agregarFrame() {
    setState(() {
      _frames.add(FramePaso(
        leaderPieIzq: PosicionPie.neutral,
        leaderPieDer: PosicionPie.neutral,
        followerPieIzq: PosicionPie.neutral,
        followerPieDer: PosicionPie.neutral,
        tiempo: _frames.length + 1,
      ));
      _frameActual = _frames.length - 1;
    });
  }

  void _eliminarFrame(int index) {
    if (_frames.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe haber al menos un frame')),
      );
      return;
    }

    setState(() {
      _frames.removeAt(index);
      // Reajustar los tiempos
      for (int i = 0; i < _frames.length; i++) {
        _frames[i] = _frames[i].copyWith(tiempo: i + 1);
      }
      if (_frameActual >= _frames.length) {
        _frameActual = _frames.length - 1;
      }
    });
  }

  void _actualizarFrame(FramePaso frame) {
    setState(() {
      _frames[_frameActual] = frame;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paso != null ? 'Editar Paso' : 'Nuevo Paso'),
        actions: [
          if (_guardando)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _guardarPaso,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Información básica
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del paso',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción (opcional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Tipo de paso
                    DropdownButtonFormField<TipoPaso>(
                      value: _tipoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de paso',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: TipoPaso.values.map((tipo) {
                        return DropdownMenuItem(
                          value: tipo,
                          child: Text(_nombreTipo(tipo)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _tipoSeleccionado = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dificultad
                    Text(
                      'Dificultad',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _dificultad ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() => _dificultad = index + 1);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Color
                    Text(
                      'Color',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Colors.purple,
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.red,
                        Colors.pink,
                        Colors.teal,
                        Colors.indigo,
                      ].map((color) {
                        return InkWell(
                          onTap: () => setState(() => _color = color),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _color == color
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: _color == color
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Editor de frames
                    Text(
                      'Frames (${_frames.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    
                    // Timeline de frames
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _frames.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _frames.length) {
                            // Botón agregar
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: InkWell(
                                onTap: _agregarFrame,
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final isSelected = index == _frameActual;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () => setState(() => _frameActual = index),
                              onLongPress: () => _eliminarFrame(index),
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? _color
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Theme.of(context).textTheme.bodyLarge?.color,
                                      fontWeight: FontWeight.bold,
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

                    // Editor del frame actual
                    if (_frames.isNotEmpty)
                      EditorFrameWidget(
                        frame: _frames[_frameActual],
                        onChanged: _actualizarFrame,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _nombreTipo(TipoPaso tipo) {
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
}
