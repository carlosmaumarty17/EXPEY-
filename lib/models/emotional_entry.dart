class EmotionalEntry {
  final String id;
  final String userId;
  final String experienceId;
  final String bookingId;
  final Map<String, int> emotions;
  final String notes;
  final DateTime date;
  final DateTime createdAt;

  EmotionalEntry({
    required this.id,
    required this.userId,
    required this.experienceId,
    required this.bookingId,
    required this.emotions,
    required this.notes,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'experienceId': experienceId,
    'bookingId': bookingId,
    'emotions': emotions,
    'notes': notes,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory EmotionalEntry.fromJson(Map<String, dynamic> json) => EmotionalEntry(
    id: json['id'] as String,
    userId: json['userId'] as String,
    experienceId: json['experienceId'] as String,
    bookingId: json['bookingId'] as String,
    emotions: Map<String, int>.from(json['emotions'] as Map),
    notes: json['notes'] as String,
    date: DateTime.parse(json['date'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  EmotionalEntry copyWith({
    String? id,
    String? userId,
    String? experienceId,
    String? bookingId,
    Map<String, int>? emotions,
    String? notes,
    DateTime? date,
    DateTime? createdAt,
  }) => EmotionalEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    experienceId: experienceId ?? this.experienceId,
    bookingId: bookingId ?? this.bookingId,
    emotions: emotions ?? this.emotions,
    notes: notes ?? this.notes,
    date: date ?? this.date,
    createdAt: createdAt ?? this.createdAt,
  );
}
