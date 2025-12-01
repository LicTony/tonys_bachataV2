import 'package:flutter/material.dart';
import '../models/paso_pareja.dart';

class PasoCardWidget extends StatelessWidget {
  final PasoPareja paso;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PasoCardWidget({
    super.key,
    required this.paso,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icono de tipo
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: paso.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _iconoPorTipo(paso.tipo),
                      color: paso.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Nombre y tipo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paso.nombre,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              paso.tipoNombre,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: paso.color,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '• ${paso.cantidadTiempos} tiempos',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Dificultad
                  _buildDificultad(),
                ],
              ),
              
              // Descripción (si existe)
              if (paso.descripcion != null && paso.descripcion!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  paso.descripcion!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              // Etiquetas
              if (paso.etiquetas.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: paso.etiquetas.take(3).map((etiqueta) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        etiqueta,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }).toList(),
                ),
              ],
              
              // Acciones
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Eliminar'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDificultad() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < paso.dificultad ? Icons.star : Icons.star_border,
          size: 16,
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
