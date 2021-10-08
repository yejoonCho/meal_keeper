import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String? category;
  final DateTime? publishedDate;
  final List<dynamic>? ingredients;
  final String? imgURL;

  Meal({this.category, this.publishedDate, this.ingredients, this.imgURL});

  factory Meal.fromDocument(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return Meal(
      category: json['category'],
      publishedDate: json['published_date'].toDate(),
      ingredients: json['ingredients'],
      imgURL: json['img_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'published_date': Timestamp.fromDate(publishedDate!),
      'ingredients': ingredients,
      'img_url': imgURL
    };
  }
}
