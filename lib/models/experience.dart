import 'package:sentir/models/review.dart';

class Experience {
  final String id;
  final String title;
  final String description;
  final String emotionId;
  final String imageUrl;
  final String location;
  final String duration;
  final double price;
  final double rating;
  final List<Review> reviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.emotionId,
    required this.imageUrl,
    required this.location,
    required this.duration,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'emotionId': emotionId,
    'imageUrl': imageUrl,
    'location': location,
    'duration': duration,
    'price': price,
    'rating': rating,
    'reviews': reviews.map((r) => r.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    emotionId: json['emotionId'] as String,
    imageUrl: json['imageUrl'] as String,
    location: json['location'] as String,
    duration: json['duration'] as String,
    price: (json['price'] as num).toDouble(),
    rating: (json['rating'] as num).toDouble(),
    reviews: (json['reviews'] as List).map((r) => Review.fromJson(r as Map<String, dynamic>)).toList(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Experience copyWith({
    String? id,
    String? title,
    String? description,
    String? emotionId,
    String? imageUrl,
    String? location,
    String? duration,
    double? price,
    double? rating,
    List<Review>? reviews,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Experience(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    emotionId: emotionId ?? this.emotionId,
    imageUrl: imageUrl ?? this.imageUrl,
    location: location ?? this.location,
    duration: duration ?? this.duration,
    price: price ?? this.price,
    rating: rating ?? this.rating,
    reviews: reviews ?? this.reviews,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
