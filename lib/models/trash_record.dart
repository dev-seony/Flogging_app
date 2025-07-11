class TrashRecord {
  final String id;
  final String userId;
  final String imageUrl;
  final String trashType;
  final DateTime date;
  final String locationDesc;

  TrashRecord({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.trashType,
    required this.date,
    required this.locationDesc,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'imageUrl': imageUrl,
    'trashType': trashType,
    'date': date.toIso8601String(),
    'locationDesc': locationDesc,
  };

  factory TrashRecord.fromMap(Map<String, dynamic> map) => TrashRecord(
    id: map['id'],
    userId: map['userId'],
    imageUrl: map['imageUrl'],
    trashType: map['trashType'],
    date: DateTime.parse(map['date']),
    locationDesc: map['locationDesc'],
  );
} 