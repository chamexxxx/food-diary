import 'package:flutter/material.dart';
import 'package:project/models/meal_model.dart';

class MealListView extends StatelessWidget {
  const MealListView({
    super.key,
    required this.meals,
  });

  final List<MealModel> meals;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return Text(meals[index].name);
        });
  }
}
