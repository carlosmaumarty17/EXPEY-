class Review {
  final String id;
  final String userId;
  final String userName;
  final String experienceId;
  final double rating;
  final String comment;
  final Map<String, int> emotionalScore;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.experienceId,
    required this.rating,
    required this.comment,
    required this.emotionalScore,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'experienceId': experienceId,
    'rating': rating,
    'comment': comment,
    'emotionalScore': emotionalScore,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as String,
    userId: json['userId'] as String,
    userName: json['userName'] as String,
    experienceId: json['experienceId'] as String,
    rating: (json['rating'] as num).toDouble(),
    comment: json['comment'] as String,
    emotionalScore: Map<String, int>.from(json['emotionalScore'] as Map),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  Review copyWith({
    String? id,
    String? userId,
    String? userName,
    String? experienceId,
    double? rating,
    String? comment,
    Map<String, int>? emotionalScore,
    DateTime? createdAt,
  }) => Review(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    experienceId: experienceId ?? this.experienceId,
    rating: rating ?? this.rating,
    comment: comment ?? this.comment,
    emotionalScore: emotionalScore ?? this.emotionalScore,
    createdAt: createdAt ?? this.createdAt,
  );
}
