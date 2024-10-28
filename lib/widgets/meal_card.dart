import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/database_helper.dart';
import 'package:project/models/dish_model.dart';
import 'package:project/models/meal_model.dart';

class MealCard extends StatelessWidget {
  const MealCard(
      {super.key, required this.mealModel, required this.dishModels});

  final MealModel mealModel;
  final List<DishModel> dishModels;

  void deleteDish(int id) async {
    var db = await DatabaseHelper.instance.database;

    await db.delete('dishes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- MEAL NAME ---
          ListTile(
            title: Text(mealModel.name),
            leading: const Icon(
              Icons.food_bank,
              size: 40,
            ),
            trailing: const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
            onTap: () => context.push('/meals/1/dishes'),
          ),

          const Divider(),

          // --- DISHES ---
          Column(
            children: [
              // --- DISH LIST ---
              ...List.generate(dishModels.length, (int index) {
                var dishModel = dishModels[index];

                return ListTile(
                  title: Text(dishModel.name),
                  trailing: IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                  onTap: () => context.pushNamed('dish',
                      pathParameters: {'mealId': mealModel.id.toString()}),
                );
              }),

              // --- DISH ADD BUTTON ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                    onPressed: () => context.pushNamed('dish',
                        pathParameters: {'mealId': mealModel.id.toString()}),
                    child: const Text('Добавить блюдо')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
