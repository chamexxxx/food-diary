import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/database_helper.dart';

class IngredientScreen extends StatefulWidget {
  const IngredientScreen({super.key});

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, Object> values = {};

  void Function(String? value) onChanged(String fieldName) {
    return (String? value) {
      values[fieldName] = value ?? '';
    };
  }

  void onPressed() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Форма валидна')),
      );

      var db = await DatabaseHelper.instance.database;

      var id = await db.insert('ingredients', values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Создание ингредиента'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Название ингредиента',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно для заполнения';
                  }

                  return null;
                },
                onChanged: onChanged('name'),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Калорийность на 100 грамм'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\,?\d{0,2}'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно для заполнения';
                  }

                  return null;
                },
                onChanged: onChanged('calories'),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Белков на 100 грамм'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\,?\d{0,2}'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно для заполнения';
                  }

                  return null;
                },
                onChanged: onChanged('proteins'),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Жиров на 100 грамм'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\,?\d{0,2}'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно для заполнения';
                  }

                  return null;
                },
                onChanged: onChanged('fats'),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Углеводов на 100 грамм'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\,?\d{0,2}'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Это поле обязательно для заполнения';
                  }

                  return null;
                },
                onChanged: onChanged('carbohydrates'),
              ),
              ElevatedButton(
                  onPressed: onPressed, child: const Text('Сохранить'))
            ],
          ),
        ),
      ),
    );
  }
}
