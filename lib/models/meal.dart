import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Meal {
  final String? category;
  final DateTime? publishedDate;
  final List<dynamic>? ingredients;
  final String? imgURL;
  final String? id;
  final int? calorie;

  String get date => DateFormat('yyyy-MM-dd').format(publishedDate!);

  Meal({
    this.category,
    this.publishedDate,
    this.ingredients,
    this.imgURL,
    this.id,
    this.calorie,
  });

  factory Meal.fromDocument(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      category: json['category'],
      publishedDate: json['published_date'].toDate(),
      ingredients: json['ingredients'],
      imgURL: json['img_url'],
      calorie: json['calorie'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'published_date': Timestamp.fromDate(publishedDate!),
      'ingredients': ingredients,
      'img_url': imgURL,
      'calorie': calorie,
    };
  }
}
