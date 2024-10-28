import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/database_helper.dart';
import 'package:project/main.dart';
import 'package:project/models/ingredient_model.dart';
import 'package:provider/provider.dart';

class DishScreen extends StatefulWidget {
  const DishScreen({super.key, required this.mealId});

  final int mealId;

  @override
  State<DishScreen> createState() => _DishScreenState();
}

class DishIngredient {
  IngredientModel? ingredient;
  int? weight;

  DishIngredient({this.ingredient, this.weight});
}

class _DishScreenState extends State<DishScreen> {
  void onPressed() {}
  void onTap() {}

  Future<List<IngredientModel>> getAllIngredientModels() async {
    var db = await DatabaseHelper.instance.database;

    List<Map<String, Object?>> maps = await db.query('ingredients');

    var ingredients = [
      IngredientModel(
          id: 1,
          name: 'name',
          calories: 1,
          proteins: 10,
          fats: 20,
          carbohydrates: 30),
      IngredientModel(
          id: 2,
          name: 'name 2',
          calories: 1,
          proteins: 10,
          fats: 20,
          carbohydrates: 30),
      IngredientModel(
          id: 3,
          name: 'name 3',
          calories: 1,
          proteins: 10,
          fats: 20,
          carbohydrates: 30),
    ];
    // var ingredients = maps.map((e) => IngredientModel.fromMap(e)).toList();

    var appState = getIt.get<AppState>();

    ingredients.forEach((element) {
      appState.addItem(element);
    });

    return ingredients;
  }

  IngredientModel? _selectedItem;

  final List<DishIngredient> _dishIngredients = [
    DishIngredient(
        ingredient: IngredientModel(
            name: 'i', calories: 1, proteins: 10, fats: 10, carbohydrates: 10)),
  ];

  void _showDialog() async {
    final selectedItem = await showDialog<IngredientModel>(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AppState>(
          builder: (context, appState, child) {
            return AlertDialog(
              title: const Text('Выберите элемент'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: List.generate(appState.items.length, (int index) {
                    var ingredient = appState.items[index];

                    return ListTile(
                      title: Text(ingredient.name),
                      onTap: () {
                        Navigator.pop(context, ingredient);
                      },
                    );
                  }),
                ),
              ),
            );
          },
        );
      },
    );

    if (selectedItem != null) {
      setState(() {
        _selectedItem = selectedItem;
      });
    }
  }

  void onIngredientAddButtonPressed() {
    _dishIngredients.add(DishIngredient());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Создание блюда'),
      ),
      body: FutureBuilder(
          future: getAllIngredientModels(),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DISH NAME ---
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Название блюда'),
                  ),

                  // --- INGREDIENTS HEADER ---
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 15),
                    child: Text(
                      'Ингредиенты',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),

                  // --- INGREDIENTS ---
                  ...List.generate(_dishIngredients.length, (index) {
                    var item = _dishIngredients[index];

                    return Row(
                      children: [
                        // --- INGREDIENT SELECTION FIELD ---
                        GestureDetector(
                          onTap: _showDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                item.ingredient?.name ?? 'Выберите элемент',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),

                        // --- INGREDIENT WEIGHT FIELD ---
                        const SizedBox(
                          width: 100,
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: 'Вес в граммах'),
                          ),
                        )
                      ],
                    );
                  }),

                  // --- ADD INGREDIENT BUTTON ---
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        onPressed: onIngredientAddButtonPressed,
                        child: const Text('Добавить ингредиент')),
                  ),

                  const Spacer(),

                  // --- SAVE BUTTON ---
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
