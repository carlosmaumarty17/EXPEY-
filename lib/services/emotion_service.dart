import 'package:flutter/material.dart';
import 'package:sentir/models/emotion.dart';
import 'package:sentir/theme.dart';

class EmotionService {
  List<Emotion> getAllEmotions() => [
    Emotion(
      id: 'adrenalina',
      name: 'Adrenalina',
      description: 'Siente la emoción de lo extremo',
      color: EmotionColors.adrenalina,
      icon: Icons.flash_on,
    ),
    Emotion(
      id: 'calma',
      name: 'Calma',
      description: 'Encuentra tu paz interior',
      color: EmotionColors.calma,
      icon: Icons.spa,
    ),
    Emotion(
      id: 'conexion',
      name: 'Conexión',
      description: 'Conecta con la naturaleza y contigo',
      color: EmotionColors.conexion,
      icon: Icons.nature_people,
    ),
    Emotion(
      id: 'alegria',
      name: 'Alegría',
      description: 'Llena tu vida de risas',
      color: EmotionColors.alegria,
      icon: Icons.emoji_emotions,
    ),
    Emotion(
      id: 'sanacion',
      name: 'Sanación',
      description: 'Sana tu cuerpo y alma',
      color: EmotionColors.sanacion,
      icon: Icons.healing,
    ),
    Emotion(
      id: 'aventura',
      name: 'Aventura',
      description: 'Descubre lo desconocido',
      color: EmotionColors.aventura,
      icon: Icons.explore,
    ),
    Emotion(
      id: 'romanticismo',
      name: 'Romanticismo',
      description: 'Vive el amor intensamente',
      color: EmotionColors.romanticismo,
      icon: Icons.favorite,
    ),
    Emotion(
      id: 'exploracion',
      name: 'Exploración',
      description: 'Explora nuevos horizontes',
      color: EmotionColors.exploracion,
      icon: Icons.hiking,
    ),
  ];

  Emotion? getEmotionById(String id) {
    try {
      return getAllEmotions().firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
