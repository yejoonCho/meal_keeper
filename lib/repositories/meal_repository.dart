import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_keeper/models/meal.dart';

class MealRepository {
  Stream<List<Meal>> fetch() {
    return FirebaseFirestore.instance
        .collection('meals')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Meal.fromDocument(doc)).toList();
    });
  }
}
