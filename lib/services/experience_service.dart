import 'dart:convert';
import 'package:sentir/models/experience.dart';
import 'package:sentir/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperienceService {
  static const _experiencesKey = 'experiences';

  Future<List<Experience>> getAllExperiences() async {
    final prefs = await SharedPreferences.getInstance();
    final experiencesJson = prefs.getString(_experiencesKey);
    
    if (experiencesJson != null) {
      try {
        final List<dynamic> decoded = json.decode(experiencesJson) as List;
        return decoded.map((e) => Experience.fromJson(e as Map<String, dynamic>)).toList();
      } catch (e) {
        return _getSampleExperiences();
      }
    }
    
    final experiences = _getSampleExperiences();
    await _saveExperiences(experiences);
    return experiences;
  }

  Future<List<Experience>> getExperiencesByEmotion(String emotionId) async {
    final all = await getAllExperiences();
    return all.where((e) => e.emotionId == emotionId).toList();
  }

  Future<Experience?> getExperienceById(String id) async {
    final all = await getAllExperiences();
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Experience>> searchExperiences(String query) async {
    final all = await getAllExperiences();
    final lowerQuery = query.toLowerCase();
    return all.where((e) =>
      e.title.toLowerCase().contains(lowerQuery) ||
      e.description.toLowerCase().contains(lowerQuery) ||
      e.location.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  Future<void> _saveExperiences(List<Experience> experiences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_experiencesKey, json.encode(experiences.map((e) => e.toJson()).toList()));
  }

  List<Experience> _getSampleExperiences() {
    final now = DateTime.now();
    return [
      Experience(
        id: 'exp1',
        title: 'Salto en Bungee desde el Puente',
        description: 'Lánzate al vacío desde 120 metros de altura y siente la adrenalina pura correr por tus venas. Una experiencia que te hará sentir vivo como nunca antes.',
        emotionId: 'adrenalina',
        imageUrl: 'assets/images/bungee_jumping_null_1761611041438.jpg',
        location: 'San Gil, Santander',
        duration: '2 horas',
        price: 150000,
        rating: 4.9,
        reviews: [
          Review(
            id: 'rev1',
            userId: 'user1',
            userName: 'Ana María',
            experienceId: 'exp1',
            rating: 5.0,
            comment: '¡Increíble! Me sentí completamente libre. Una experiencia que nunca olvidaré.',
            emotionalScore: {'feliz': 5, 'emocionado': 5, 'inspirado': 4},
            createdAt: now.subtract(const Duration(days: 10)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp2',
        title: 'Paracaidismo en el Cielo Azul',
        description: 'Vuela como un ave y experimenta la libertad absoluta. Salta desde 3000 metros y disfruta de vistas espectaculares.',
        emotionId: 'adrenalina',
        imageUrl: 'assets/images/skydiving_null_1761611042089.jpg',
        location: 'Flandes, Tolima',
        duration: '4 horas',
        price: 580000,
        rating: 5.0,
        reviews: [
          Review(
            id: 'rev2',
            userId: 'user2',
            userName: 'Carlos',
            experienceId: 'exp2',
            rating: 5.0,
            comment: 'La mejor experiencia de mi vida. Superó todas mis expectativas.',
            emotionalScore: {'feliz': 5, 'emocionado': 5, 'libre': 5},
            createdAt: now.subtract(const Duration(days: 5)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp3',
        title: 'Meditación y Yoga al Amanecer',
        description: 'Conecta con tu ser interior en una sesión guiada de yoga y meditación. Respira, fluye y encuentra tu paz.',
        emotionId: 'calma',
        imageUrl: 'assets/images/meditation_yoga_null_1761611042805.jpg',
        location: 'Villa de Leyva, Boyacá',
        duration: '3 horas',
        price: 80000,
        rating: 4.8,
        reviews: [
          Review(
            id: 'rev3',
            userId: 'user3',
            userName: 'Sofía',
            experienceId: 'exp3',
            rating: 5.0,
            comment: 'Encontré la paz que tanto buscaba. El instructor es maravilloso.',
            emotionalScore: {'relajado': 5, 'tranquilo': 5, 'renovado': 4},
            createdAt: now.subtract(const Duration(days: 7)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp4',
        title: 'Spa y Masaje Relajante',
        description: 'Déjate consentir con un masaje de piedras calientes y terapias de relajación profunda. Tu cuerpo te lo agradecerá.',
        emotionId: 'calma',
        imageUrl: 'assets/images/spa_wellness_null_1761611043368.jpg',
        location: 'Cartagena, Bolívar',
        duration: '2.5 horas',
        price: 250000,
        rating: 4.9,
        reviews: [
          Review(
            id: 'rev4',
            userId: 'user4',
            userName: 'Laura',
            experienceId: 'exp4',
            rating: 5.0,
            comment: 'Salí renovada completamente. El spa es hermoso y el servicio impecable.',
            emotionalScore: {'relajado': 5, 'renovado': 5, 'tranquilo': 5},
            createdAt: now.subtract(const Duration(days: 3)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp5',
        title: 'Caminata en el Bosque Nublado',
        description: 'Reconecta con la naturaleza en un sendero mágico rodeado de biodiversidad. Escucha el canto de las aves y respira aire puro.',
        emotionId: 'conexion',
        imageUrl: 'assets/images/forest_hiking_null_1761611044361.jpg',
        location: 'Cocora, Quindío',
        duration: '5 horas',
        price: 120000,
        rating: 4.7,
        reviews: [
          Review(
            id: 'rev5',
            userId: 'user5',
            userName: 'Miguel',
            experienceId: 'exp5',
            rating: 5.0,
            comment: 'Naturaleza en estado puro. Me sentí conectado con todo.',
            emotionalScore: {'conectado': 5, 'inspirado': 4, 'renovado': 5},
            createdAt: now.subtract(const Duration(days: 12)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp6',
        title: 'Atardecer en la Playa',
        description: 'Contempla uno de los atardeceres más hermosos del Caribe mientras disfrutas de una cena romántica en la playa.',
        emotionId: 'conexion',
        imageUrl: 'assets/images/beach_sunset_null_1761611044994.jpg',
        location: 'Santa Marta, Magdalena',
        duration: '3 horas',
        price: 180000,
        rating: 4.9,
        reviews: [
          Review(
            id: 'rev6',
            userId: 'user6',
            userName: 'Daniela',
            experienceId: 'exp6',
            rating: 5.0,
            comment: 'Mágico y romántico. El atardecer fue espectacular.',
            emotionalScore: {'feliz': 5, 'enamorado': 5, 'inspirado': 4},
            createdAt: now.subtract(const Duration(days: 2)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp7',
        title: 'Show de Comedia Stand-Up',
        description: 'Ríe hasta que te duela el estómago con los mejores comediantes del país. Una noche llena de risas y buena energía.',
        emotionId: 'alegria',
        imageUrl: 'assets/images/comedy_show_null_1761611045558.jpg',
        location: 'Bogotá, Cundinamarca',
        duration: '2 horas',
        price: 45000,
        rating: 4.6,
        reviews: [
          Review(
            id: 'rev7',
            userId: 'user7',
            userName: 'Andrés',
            experienceId: 'exp7',
            rating: 5.0,
            comment: '¡Me dolió la cara de tanto reír! Excelente show.',
            emotionalScore: {'feliz': 5, 'divertido': 5, 'alegre': 5},
            createdAt: now.subtract(const Duration(days: 4)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp8',
        title: 'Día de Diversión en el Parque',
        description: 'Libera tu niño interior en el parque de atracciones más emocionante. Montañas rusas, juegos y mucha diversión.',
        emotionId: 'alegria',
        imageUrl: 'assets/images/amusement_park_null_1761611046425.jpg',
        location: 'Medellín, Antioquia',
        duration: 'Todo el día',
        price: 95000,
        rating: 4.8,
        reviews: [
          Review(
            id: 'rev8',
            userId: 'user8',
            userName: 'Carolina',
            experienceId: 'exp8',
            rating: 5.0,
            comment: 'Un día perfecto en familia. Los niños quedaron encantados.',
            emotionalScore: {'feliz': 5, 'emocionado': 5, 'divertido': 5},
            createdAt: now.subtract(const Duration(days: 6)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp9',
        title: 'Terapia Holística y Sanación',
        description: 'Sana tu cuerpo y alma con terapias ancestrales. Reiki, aromaterapia y sanación energética en un espacio sagrado.',
        emotionId: 'sanacion',
        imageUrl: 'assets/images/holistic_therapy_null_1761611047042.jpg',
        location: 'Salento, Quindío',
        duration: '2.5 horas',
        price: 150000,
        rating: 4.9,
        reviews: [
          Review(
            id: 'rev9',
            userId: 'user9',
            userName: 'Patricia',
            experienceId: 'exp9',
            rating: 5.0,
            comment: 'Transformador. Sentí cómo se liberaban todas mis tensiones.',
            emotionalScore: {'sanado': 5, 'renovado': 5, 'tranquilo': 5},
            createdAt: now.subtract(const Duration(days: 8)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp10',
        title: 'Masaje Terapéutico Profundo',
        description: 'Libera tensiones acumuladas con un masaje terapéutico especializado. Sana tu cuerpo desde lo más profundo.',
        emotionId: 'sanacion',
        imageUrl: 'assets/images/massage_therapy_null_1761611047590.jpg',
        location: 'Cali, Valle del Cauca',
        duration: '1.5 horas',
        price: 120000,
        rating: 4.7,
        reviews: [
          Review(
            id: 'rev10',
            userId: 'user10',
            userName: 'Roberto',
            experienceId: 'exp10',
            rating: 5.0,
            comment: 'Excelente masajista. Aliviaron mis dolores crónicos.',
            emotionalScore: {'sanado': 5, 'relajado': 5, 'renovado': 4},
            createdAt: now.subtract(const Duration(days: 1)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp11',
        title: 'Escalada en Roca',
        description: 'Desafía tus límites escalando paredes naturales. Una aventura vertical que pondrá a prueba tu fuerza y determinación.',
        emotionId: 'aventura',
        imageUrl: 'assets/images/mountain_climbing_null_1761611048484.jpg',
        location: 'Suesca, Cundinamarca',
        duration: '4 horas',
        price: 130000,
        rating: 4.8,
        reviews: [
          Review(
            id: 'rev11',
            userId: 'user11',
            userName: 'David',
            experienceId: 'exp11',
            rating: 5.0,
            comment: 'Desafiante y emocionante. Los guías son muy profesionales.',
            emotionalScore: {'emocionado': 5, 'orgulloso': 5, 'fuerte': 4},
            createdAt: now.subtract(const Duration(days: 9)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp12',
        title: 'Safari Fotográfico',
        description: 'Captura la belleza de la fauna salvaje en su hábitat natural. Una aventura fotográfica inolvidable.',
        emotionId: 'aventura',
        imageUrl: 'assets/images/safari_wildlife_null_1761611049111.jpg',
        location: 'Los Llanos, Meta',
        duration: 'Todo el día',
        price: 350000,
        rating: 5.0,
        reviews: [
          Review(
            id: 'rev12',
            userId: 'user12',
            userName: 'Isabella',
            experienceId: 'exp12',
            rating: 5.0,
            comment: 'Vimos tantos animales increíbles. Una experiencia única.',
            emotionalScore: {'emocionado': 5, 'inspirado': 5, 'conectado': 5},
            createdAt: now.subtract(const Duration(days: 11)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp13',
        title: 'Cena Romántica bajo las Estrellas',
        description: 'Una velada perfecta para dos. Cena gourmet en un ambiente íntimo con velas y música en vivo.',
        emotionId: 'romanticismo',
        imageUrl: 'assets/images/romantic_dinner_null_1761611049752.jpg',
        location: 'Barichara, Santander',
        duration: '3 horas',
        price: 280000,
        rating: 4.9,
        reviews: [
          Review(
            id: 'rev13',
            userId: 'user13',
            userName: 'Valentina',
            experienceId: 'exp13',
            rating: 5.0,
            comment: 'La cena más romántica de nuestras vidas. Todo fue perfecto.',
            emotionalScore: {'enamorado': 5, 'feliz': 5, 'romántico': 5},
            createdAt: now.subtract(const Duration(days: 3)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp14',
        title: 'Retiro de Parejas',
        description: 'Reconecta con tu pareja en un retiro diseñado para fortalecer el amor. Terapias, masajes y momentos especiales.',
        emotionId: 'romanticismo',
        imageUrl: 'assets/images/couples_retreat_null_1761611050272.jpg',
        location: 'Girardot, Cundinamarca',
        duration: '2 días',
        price: 950000,
        rating: 5.0,
        reviews: [
          Review(
            id: 'rev14',
            userId: 'user14',
            userName: 'Camilo',
            experienceId: 'exp14',
            rating: 5.0,
            comment: 'Salvó nuestra relación. Salimos más unidos que nunca.',
            emotionalScore: {'enamorado': 5, 'conectado': 5, 'feliz': 5},
            createdAt: now.subtract(const Duration(days: 15)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp15',
        title: 'Exploración de Cavernas',
        description: 'Adéntrate en el mundo subterráneo y descubre formaciones rocosas milenarias. Una aventura para exploradores.',
        emotionId: 'exploracion',
        imageUrl: 'assets/images/cave_exploration_null_1761611051149.jpg',
        location: 'San Agustín, Huila',
        duration: '4 horas',
        price: 110000,
        rating: 4.7,
        reviews: [
          Review(
            id: 'rev15',
            userId: 'user15',
            userName: 'Julián',
            experienceId: 'exp15',
            rating: 5.0,
            comment: 'Impresionante. Las cavernas son espectaculares.',
            emotionalScore: {'emocionado': 5, 'curioso': 5, 'aventurero': 5},
            createdAt: now.subtract(const Duration(days: 13)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp16',
        title: 'Tour por la Ciudad Colonial',
        description: 'Descubre la historia y arquitectura colonial en un recorrido guiado por calles empedradas llenas de cultura.',
        emotionId: 'exploracion',
        imageUrl: 'assets/images/city_tour_null_1761611051748.jpg',
        location: 'Cartagena, Bolívar',
        duration: '3 horas',
        price: 65000,
        rating: 4.6,
        reviews: [
          Review(
            id: 'rev16',
            userId: 'user16',
            userName: 'Mariana',
            experienceId: 'exp16',
            rating: 5.0,
            comment: 'Aprendí mucho sobre la historia. El guía es muy conocedor.',
            emotionalScore: {'curioso': 5, 'inspirado': 4, 'culto': 5},
            createdAt: now.subtract(const Duration(days: 5)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp17',
        title: 'Surf y Olas',
        description: 'Domina las olas del Pacífico colombiano. Clases de surf para todos los niveles con instructores certificados.',
        emotionId: 'adrenalina',
        imageUrl: 'assets/images/surfing_waves_null_1761611052343.jpg',
        location: 'Nuquí, Chocó',
        duration: '3 horas',
        price: 140000,
        rating: 4.8,
        reviews: [
          Review(
            id: 'rev17',
            userId: 'user17',
            userName: 'Sebastián',
            experienceId: 'exp17',
            rating: 5.0,
            comment: '¡Logré pararme en la tabla! Una experiencia increíble.',
            emotionalScore: {'emocionado': 5, 'orgulloso': 5, 'libre': 5},
            createdAt: now.subtract(const Duration(days: 7)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp18',
        title: 'Paseo en Globo Aerostático',
        description: 'Vuela sobre paisajes increíbles y observa el amanecer desde las alturas. Una experiencia mágica e inolvidable.',
        emotionId: 'exploracion',
        imageUrl: 'assets/images/hot_air_balloon_null_1761611053140.jpg',
        location: 'Guatavita, Cundinamarca',
        duration: '2.5 horas',
        price: 450000,
        rating: 5.0,
        reviews: [
          Review(
            id: 'rev18',
            userId: 'user18',
            userName: 'Gabriela',
            experienceId: 'exp18',
            rating: 5.0,
            comment: 'Mágico y romántico. Las vistas son de otro mundo.',
            emotionalScore: {'enamorado': 5, 'inspirado': 5, 'libre': 5},
            createdAt: now.subtract(const Duration(days: 4)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp19',
        title: 'Cata de Vinos',
        description: 'Degusta los mejores vinos locales e internacionales acompañados de quesos artesanales. Una experiencia sensorial.',
        emotionId: 'alegria',
        imageUrl: 'assets/images/wine_tasting_null_1761611053678.jpg',
        location: 'Villa de Leyva, Boyacá',
        duration: '2 horas',
        price: 120000,
        rating: 4.7,
        reviews: [
          Review(
            id: 'rev19',
            userId: 'user19',
            userName: 'Fernando',
            experienceId: 'exp19',
            rating: 5.0,
            comment: 'Descubrí vinos increíbles. El sommelier es excelente.',
            emotionalScore: {'feliz': 5, 'culto': 4, 'relajado': 5},
            createdAt: now.subtract(const Duration(days: 6)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Experience(
        id: 'exp20',
        title: 'Clase de Cocina Gourmet',
        description: 'Aprende a preparar platos gourmet de la mano de chefs profesionales. Cocina, come y disfruta.',
        emotionId: 'alegria',
        imageUrl: 'assets/images/cooking_class_null_1761611054397.jpg',
        location: 'Bogotá, Cundinamarca',
        duration: '3 horas',
        price: 180000,
        rating: 4.9,
        reviews: [
          Review(
            id: 'rev20',
            userId: 'user20',
            userName: 'Natalia',
            experienceId: 'exp20',
            rating: 5.0,
            comment: 'Aprendí técnicas increíbles. La comida quedó deliciosa.',
            emotionalScore: {'feliz': 5, 'orgulloso': 5, 'creativo': 5},
            createdAt: now.subtract(const Duration(days: 2)),
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
