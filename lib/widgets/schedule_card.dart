import 'package:flutter/material.dart';
import 'package:project/models/meal_model.dart';

enum DayOfTheWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

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

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {super.key, required this.weekday, this.children = const <Widget>[]});

  final String weekday;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weekday,
              style: const TextStyle(fontSize: 23),
            ),
            ...children
          ],
        ),
      ),
    );
  }
}

class ScheduleCardEmptyState extends StatelessWidget {
  const ScheduleCardEmptyState({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Icon(
              Icons.add,
              size: 60,
              color: Colors.green.shade300,
            )),
        ElevatedButton(
            onPressed: onPressed,
            child: const Text('Создать расписание на этот день'))
      ],
    ));
  }
}
