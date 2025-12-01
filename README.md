# Tony's Bachata V2 🎵💃🕺

Diccionario visual de pasos de bachata en pareja - versión CRUD completa

## 📱 Descripción

Aplicación Flutter para crear, visualizar y gestionar pasos de bachata en pareja. Muestra la posición de los pies del **líder** (hombre) y del **follower** (mujer) en cada tiempo del paso.

## ✨ Características

### CRUD Completo
- ✅ **Crear** pasos personalizados con múltiples frames
- ✅ **Leer/Visualizar** pasos con animación
- ✅ **Actualizar** pasos existentes
- ✅ **Eliminar** pasos

### Editor Visual
- 🎨 Editor de posiciones de pies con vista 2D del piso
- 🔄 Rotación de pies (0-360°)
- ⚖️ Indicador de peso en cada pie
- 👟 Control de apoyo (pie en el suelo o levantado)
- 🎬 Timeline visual de frames
- 📝 Notas por frame

### Visualizador
- ▶️ Reproducción automática con controles
- ⏯️ Play/Pause
- ⏭️ Navegación frame por frame
- 🎚️ Control de velocidad (0.5x, 1x, 1.5x, 2x)
- 📊 Vista clara de ambos bailarines

### Organización
- 🏷️ Sistema de etiquetas
- 🎨 Códigos de color personalizables
- ⭐ Niveles de dificultad (1-5 estrellas)
- 🔍 Búsqueda por nombre, descripción o etiquetas
- 🗂️ Filtros por tipo de paso

## 🏗️ Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada
├── models/
│   ├── paso_pareja.dart              # Modelo del paso completo
│   ├── posicion_pie.dart             # Modelo de posición de un pie
│   └── frame_paso.dart               # Frame individual (en paso_pareja.dart)
├── screens/
│   ├── home_screen.dart              # Pantalla principal (lista)
│   ├── editor_paso_screen.dart       # Editor de pasos
│   └── detalle_paso_screen.dart      # Visualizador con reproducción
├── widgets/
│   ├── paso_card_widget.dart         # Card de paso en lista
│   ├── editor_frame_widget.dart      # Editor de frame individual
│   └── visualizador_frame_widget.dart # Visualizador de frame
├── services/
│   └── paso_repository.dart          # Persistencia con SharedPreferences
└── utils/
    ├── constantes.dart               # Constantes de la app
    └── pasos_ejemplo.dart            # Pasos predefinidos de ejemplo
```

## 🎯 Modelos de Datos

### PasoPareja
```dart
- id: String
- nombre: String
- descripcion: String?
- tipo: TipoPaso (básico, giro, lateral, etc.)
- frames: List<FramePaso>
- dificultad: int (1-5)
- color: Color
- creado: DateTime
- modificado: DateTime
- etiquetas: List<String>
```

### FramePaso
```dart
- leaderPieIzq: PosicionPie
- leaderPieDer: PosicionPie
- followerPieIzq: PosicionPie
- followerPieDer: PosicionPie
- tiempo: int (1-8 en compás)
- nota: String?
```

### PosicionPie
```dart
- x: double (-1 a 1, izquierda a derecha)
- y: double (-1 a 1, atrás a adelante)
- rotacion: double (0-360 grados)
- apoyado: bool (si está en el suelo)
- peso: bool (si tiene el peso del cuerpo)
```

## 🚀 Instalación

1. **Requisitos:**
   - Flutter SDK >= 3.0.0
   - Dart >= 3.0.0

2. **Instalar dependencias:**
```bash
flutter pub get
```

3. **Ejecutar:**
```bash
flutter run
```

## 📦 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  google_fonts: ^6.1.0
  shared_preferences: ^2.2.2
  uuid: ^4.2.1
  intl: ^0.18.1
```

## 🎨 Características del Editor

### Vista del Piso
- Grid de referencia 4x4
- Línea divisoria entre leader y follower
- Interacción táctil para mover pies
- Visualización de rotación y peso

### Controles
- **Posiciones rápidas:** Centro, Izquierda, Derecha, Adelante, Atrás
- **Slider de rotación:** 0-360° con incrementos de 5°
- **Switches:** Apoyado / Con peso
- **Selector de pie:** Leader Izq/Der, Follower Izq/Der

### Timeline
- Vista horizontal de todos los frames
- Agregar/eliminar frames
- Selección táctil de frame
- Reordenamiento automático de tiempos

## 📱 Pantallas

### HomeScreen
- Lista de pasos con cards visuales
- Búsqueda en tiempo real
- Filtros por tipo
- Pull-to-refresh
- FAB para crear nuevo paso

### EditorPasoScreen
- Formulario de información básica
- Selector de tipo y dificultad
- Paleta de colores
- Editor de frames integrado
- Validación de campos

### DetallePasoScreen
- Visualizador grande del frame actual
- Controles de reproducción
- Timeline interactiva
- Información del paso
- Indicadores de leyenda

## 🎓 Pasos de Ejemplo Incluidos

1. **Básico de Bachata** (8 tiempos)
   - Paso lateral básico
   - Dificultad: 1

2. **Básico Adelante/Atrás** (8 tiempos)
   - Leader adelante, Follower atrás y viceversa
   - Dificultad: 1

3. **Giro Simple Derecha** (8 tiempos)
   - Giro del follower mientras leader hace básico
   - Dificultad: 2

## 💾 Persistencia

Los datos se guardan localmente usando `SharedPreferences`:
- Serialización JSON automática
- Carga en el primer uso de pasos de ejemplo
- CRUD completo sin backend

## 🎯 Próximas Mejoras

- [ ] Exportar/Importar pasos (JSON)
- [ ] Compartir pasos entre usuarios
- [ ] Videos de referencia
- [ ] Modo oscuro manual
- [ ] Coreografías (secuencias de pasos)
- [ ] Música integrada
- [ ] Animaciones más fluidas
- [ ] Vista 3D de los bailarines

## 👨‍💻 Autor

**Tony** - Mentor de programación y bailarín de bachata

## 📄 Licencia

Este proyecto es de código abierto para fines educativos.

---

**¡Disfruta bailando y codificando! 🎉**
