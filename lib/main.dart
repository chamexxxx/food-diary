import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project/app.dart';
import 'package:project/models/ingredient_model.dart';

class AppState extends ChangeNotifier {
  final List<IngredientModel> _items = [];

  List<IngredientModel> get items => _items;

  void addItem(IngredientModel item) {
    _items.add(item);

    notifyListeners();
  }

  void removeItem(IngredientModel item) {
    _items.remove(item);

    notifyListeners();
  }
}

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<AppState>(AppState());

  runApp(const App());
}
