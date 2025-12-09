import 'package:flutter/material.dart';

class Emotion {
  final String id;
  final String name;
  final String description;
  final Color color;
  final IconData icon;

  Emotion({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'color': color.value,
    'icon': icon.codePoint,
  };

  factory Emotion.fromJson(Map<String, dynamic> json) => Emotion(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    color: Color(json['color'] as int),
    icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
  );

  Emotion copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    IconData? icon,
  }) => Emotion(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    color: color ?? this.color,
    icon: icon ?? this.icon,
  );
}
