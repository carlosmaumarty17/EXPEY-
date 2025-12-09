# EXPEYÁ - Arquitectura de Aplicación

## 🌈 Concepto
**EXPEYÁ** es un mercado de experiencias y emociones. No vende viajes, vende cómo quieres sentirte hoy.

**Eslogan**: "No compres viajes, vive emociones."

---

## 🎯 Características MVP

### Pantallas Principales
1. **HomeScreen** - Pantalla de inicio con categorías emocionales
2. **ExploreScreen** - Tarjetas tipo Tinder para deslizar experiencias
3. **ExperienceDetailScreen** - Detalle completo de la experiencia
4. **CheckoutScreen** - Proceso de reserva
5. **EmotionalDiaryScreen** - Diario emocional del usuario
6. **ProfileScreen** - Perfil y configuraciones del usuario

### Funcionalidades
- Navegación fluida entre pantallas
- Categorización por emociones (Adrenalina, Calma, Conexión, Alegría, Sanación, etc.)
- Swipe de tarjetas para explorar experiencias
- Sistema de reservas completo (sin pago real)
- Diario emocional post-experiencia
- Persistencia local con shared_preferences

---

## 🎨 Identidad Visual

### Paleta de Colores Emocionales
- **Verde jade** (#2BB673) - Bienestar y conexión
- **Coral** (#FF6B6B) - Emoción y aventura
- **Azul cielo** (#4DB8FF) - Libertad y tranquilidad
- **Amarillo suave** (#FFD166) - Alegría y energía
- **Blanco/Beige** - Fondos limpios y naturales
- **Gris oscuro** (#2D2D2D) - Textos principales

### Tipografías
- **Títulos**: Poppins SemiBold
- **Cuerpo**: Nunito Regular

### Estilo
- Diseño moderno, cálido y emocional
- Botones redondeados con sombras suaves
- Iconografía minimalista lineal
- Transiciones suaves entre pantallas
- Animaciones naturales
- Cambio de color de fondo según emoción

---

## 🧩 Arquitectura de Datos

### Modelos de Datos

#### 1. User (Usuario)
```dart
- id: String
- name: String
- email: String
- phone: String?
- avatar: String?
- createdAt: DateTime
- updatedAt: DateTime
```

#### 2. Emotion (Emoción)
```dart
- id: String
- name: String (Adrenalina, Calma, Conexión, etc.)
- description: String
- color: String (hex color)
- icon: IconData
```

#### 3. Experience (Experiencia)
```dart
- id: String
- title: String
- description: String
- emotionId: String
- imageUrl: String
- location: String
- duration: String
- price: double
- rating: double
- reviews: List<Review>
- createdAt: DateTime
- updatedAt: DateTime
```

#### 4. Review (Reseña)
```dart
- id: String
- userId: String
- experienceId: String
- rating: double
- comment: String
- emotionalScore: Map<String, int> (feliz, relajado, inspirado, etc.)
- createdAt: DateTime
```

#### 5. Booking (Reserva)
```dart
- id: String
- userId: String
- experienceId: String
- date: DateTime
- time: String
- numberOfPeople: int
- totalPrice: double
- status: String (pending, confirmed, completed, cancelled)
- createdAt: DateTime
- updatedAt: DateTime
```

#### 6. EmotionalEntry (Entrada de Diario Emocional)
```dart
- id: String
- userId: String
- experienceId: String
- bookingId: String
- emotions: Map<String, int> (rating de cada emoción)
- notes: String
- date: DateTime
- createdAt: DateTime
```

### Servicios

#### 1. UserService
- `getCurrentUser()` - Obtener usuario actual
- `updateUser(User)` - Actualizar datos del usuario
- `saveUser(User)` - Guardar usuario en almacenamiento local

#### 2. EmotionService
- `getAllEmotions()` - Obtener todas las emociones
- `getEmotionById(String)` - Obtener emoción por ID
- Sample data: 8 emociones predefinidas

#### 3. ExperienceService
- `getAllExperiences()` - Obtener todas las experiencias
- `getExperiencesByEmotion(String)` - Filtrar por emoción
- `getExperienceById(String)` - Obtener experiencia por ID
- `searchExperiences(String)` - Buscar experiencias
- Sample data: 20+ experiencias variadas

#### 4. BookingService
- `createBooking(Booking)` - Crear nueva reserva
- `getBookingsByUser(String)` - Obtener reservas del usuario
- `updateBookingStatus(String, String)` - Actualizar estado
- `getBookingById(String)` - Obtener reserva por ID

#### 5. EmotionalDiaryService
- `createEntry(EmotionalEntry)` - Crear entrada de diario
- `getEntriesByUser(String)` - Obtener entradas del usuario
- `getEmotionalStats(String)` - Estadísticas emocionales
- `updateEntry(EmotionalEntry)` - Actualizar entrada

---

## 🎬 Flujo de Usuario

1. **Inicio** → Usuario ve mensaje de bienvenida y categorías emocionales
2. **Selección de Emoción** → Usuario elige cómo quiere sentirse
3. **Exploración** → Usuario desliza tarjetas de experiencias
4. **Detalle** → Usuario ve información completa y reseñas
5. **Reserva** → Usuario completa datos y confirma
6. **Confirmación** → "Tu emoción te espera 💫"
7. **Post-Experiencia** → Usuario registra en diario emocional

---

## 📱 Estructura de Widgets

### Widgets Reutilizables
- **EmotionCategoryCard** - Tarjeta de categoría emocional
- **ExperienceSwipeCard** - Tarjeta deslizable de experiencia
- **EmotionChip** - Chip de emoción
- **RatingStars** - Estrellas de calificación
- **CustomButton** - Botón personalizado con animación
- **EmotionalColorBackground** - Fondo con gradiente emocional

### Navegación
- Stack-based navigation (Navigator 2.0 no es necesario para MVP)
- Transiciones personalizadas entre pantallas
- Bottom navigation bar para pantallas principales

---

## 🔧 Dependencias Necesarias

- `shared_preferences` - Almacenamiento local
- `google_fonts` - Tipografías Poppins y Nunito
- `flutter_svg` - Iconos SVG
- `intl` - Formateo de fechas y números
- `uuid` - Generación de IDs únicos

---

## ✅ Plan de Implementación

### Fase 1: Setup y Tema
1. Actualizar theme.dart con colores emocionales de EXPEYÁ
2. Configurar tipografías Poppins y Nunito
3. Agregar dependencias necesarias

### Fase 2: Modelos y Servicios
4. Crear modelos de datos (User, Emotion, Experience, Review, Booking, EmotionalEntry)
5. Implementar servicios con data de muestra
6. Configurar almacenamiento local

### Fase 3: Widgets Reutilizables
7. Crear componentes base (botones, tarjetas, chips)
8. Implementar componentes emocionales específicos

### Fase 4: Pantallas
9. HomeScreen - Inicio con categorías
10. ExploreScreen - Swipe de experiencias
11. ExperienceDetailScreen - Detalle completo
12. CheckoutScreen - Proceso de reserva
13. EmotionalDiaryScreen - Diario emocional
14. ProfileScreen - Perfil del usuario

### Fase 5: Navegación y Pulido
15. Implementar navegación completa
16. Añadir animaciones y transiciones
17. Pulir detalles visuales

### Fase 6: Testing y Debug
18. Compilar proyecto y corregir errores
19. Testing de flujo completo
20. Validación final

---

## 💬 Tono de Voz

- Cálido, humano, inspirador y empático
- Motiva al usuario a vivir, sentir y conectar
- Ejemplos:
  - "Tu alma también necesita respirar"
  - "Hoy es un buen día para sentir"
  - "Prepárate para vivir algo único"
  - "Guarda este momento en tu historia emocional"

---

## 🚀 Objetivo Final

Crear una aplicación móvil emotiva, estética y funcional que invite a las personas a vivir experiencias que despierten emociones reales, conectando diseño, emoción y tecnología bajo la esencia de **EXPEYÁ**.
