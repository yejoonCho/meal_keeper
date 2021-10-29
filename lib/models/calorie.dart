class Calorie {
  final String? name;
  final int? calorie;

  Calorie({this.name, this.calorie});

  factory Calorie.fromJson(Map<String, dynamic> json) {
    return Calorie(
      name: json['name'],
      calorie: json['calorie'],
    );
  }
}
