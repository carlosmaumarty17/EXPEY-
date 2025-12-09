class Booking {
  final String id;
  final String userId;
  final String experienceId;
  final DateTime date;
  final String time;
  final int numberOfPeople;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.experienceId,
    required this.date,
    required this.time,
    required this.numberOfPeople,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'experienceId': experienceId,
    'date': date.toIso8601String(),
    'time': time,
    'numberOfPeople': numberOfPeople,
    'totalPrice': totalPrice,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    userId: json['userId'] as String,
    experienceId: json['experienceId'] as String,
    date: DateTime.parse(json['date'] as String),
    time: json['time'] as String,
    numberOfPeople: json['numberOfPeople'] as int,
    totalPrice: (json['totalPrice'] as num).toDouble(),
    status: json['status'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  Booking copyWith({
    String? id,
    String? userId,
    String? experienceId,
    DateTime? date,
    String? time,
    int? numberOfPeople,
    double? totalPrice,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Booking(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    experienceId: experienceId ?? this.experienceId,
    date: date ?? this.date,
    time: time ?? this.time,
    numberOfPeople: numberOfPeople ?? this.numberOfPeople,
    totalPrice: totalPrice ?? this.totalPrice,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
