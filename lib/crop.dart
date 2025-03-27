import 'package:cloud_firestore/cloud_firestore.dart';

class Crop {
  String id;
  String name;
  DateTime date;
  double land;

  Crop({
    required this.id,
    required this.name,
    required this.date,
    required this.land,
  });

  factory Crop.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Crop(
      id: doc.id,
      name: data['name'] ?? '',
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      land: (data['land'] is int) ? (data['land'] as int).toDouble() : (data['land'] ?? 0.0),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'date': Timestamp.fromDate(date),
      'land': land,
    };
  }
}
