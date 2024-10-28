class IngredientModel {
  int id;
  String name;
  int calories;
  double proteins;
  double fats;
  double carbohydrates;

  IngredientModel(
      {this.id = 0,
      required this.name,
      required this.calories,
      required this.proteins,
      required this.fats,
      required this.carbohydrates});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'proteins': proteins,
      'fats': fats,
      'carbohydrates': carbohydrates
    };
  }

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
        id: map['id'] ?? 0,
        name: map['name'],
        calories: map['calories'],
        proteins: map['proteins'],
        fats: map['fats'],
        carbohydrates: map['carbohydrates']);
  }
}
