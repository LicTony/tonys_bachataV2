import 'package:flutter/material.dart';
import '../models/paso_pareja.dart';
import '../services/paso_repository.dart';
import 'editor_paso_screen.dart';
import 'detalle_paso_screen.dart';
import '../widgets/paso_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PasoRepository _repository = PasoRepository();
  List<PasoPareja> _pasos = [];
  List<PasoPareja> _pasosFiltrados = [];
  bool _isLoading = true;
  String _searchQuery = '';
  TipoPaso? _filtroTipo;

  @override
  void initState() {
    super.initState();
    _cargarPasos();
  }

  Future<void> _cargarPasos() async {
    setState(() => _isLoading = true);
    
    try {
      final pasos = await _repository.obtenerTodos();
      setState(() {
        _pasos = pasos;
        _aplicarFiltros();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar pasos: $e')),
        );
      }
    }
  }

  void _aplicarFiltros() {
    var resultado = _pasos;

    // Filtrar por tipo
    if (_filtroTipo != null) {
      resultado = resultado.where((p) => p.tipo == _filtroTipo).toList();
    }

    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      resultado = resultado.where((p) {
        return p.nombre.toLowerCase().contains(query) ||
               (p.descripcion?.toLowerCase().contains(query) ?? false) ||
               p.etiquetas.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    // Ordenar por fecha de modificación (más reciente primero)
    resultado.sort((a, b) => b.modificado.compareTo(a.modificado));

    setState(() {
      _pasosFiltrados = resultado;
    });
  }

  Future<void> _eliminarPaso(PasoPareja paso) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar paso'),
        content: Text('¿Estás seguro de eliminar "${paso.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      final exitoso = await _repository.eliminar(paso.id);
      
      if (exitoso) {
        _cargarPasos();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Paso eliminado')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al eliminar paso')),
          );
        }
      }
    }
  }

  void _irAEditor([PasoPareja? paso]) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditorPasoScreen(paso: paso),
      ),
    );

    if (resultado == true) {
      _cargarPasos();
    }
  }

  void _irADetalle(PasoPareja paso) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePasoScreen(paso: paso),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tony\'s Bachata'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _mostrarAcercaDe(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campo de búsqueda
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar pasos...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _aplicarFiltros();
                    });
                  },
                ),
                const SizedBox(height: 12),
                
                // Filtro por tipo
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: _filtroTipo == null,
                        onSelected: (selected) {
                          setState(() {
                            _filtroTipo = null;
                            _aplicarFiltros();
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...TipoPaso.values.map((tipo) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(_nombreTipo(tipo)),
                          selected: _filtroTipo == tipo,
                          onSelected: (selected) {
                            setState(() {
                              _filtroTipo = selected ? tipo : null;
                              _aplicarFiltros();
                            });
                          },
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Lista de pasos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _pasosFiltrados.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _cargarPasos,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _pasosFiltrados.length,
                          itemBuilder: (context, index) {
                            final paso = _pasosFiltrados[index];
                            return PasoCardWidget(
                              paso: paso,
                              onTap: () => _irADetalle(paso),
                              onEdit: () => _irAEditor(paso),
                              onDelete: () => _eliminarPaso(paso),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _irAEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Paso'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _filtroTipo != null
                ? 'No se encontraron pasos'
                : 'No hay pasos guardados',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _filtroTipo != null
                ? 'Intenta con otros filtros'
                : 'Crea tu primer paso con el botón +',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
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

  void _mostrarAcercaDe() {
    showAboutDialog(
      context: context,
      applicationName: 'Tony\'s Bachata V2',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.music_note, size: 48),
      children: [
        const Text(
          'Diccionario visual de pasos de bachata en pareja.\n\n'
          'Crea, edita y visualiza pasos de bachata con representación '
          'de los pies del líder y el seguidor.',
        ),
      ],
    );
  }
}
