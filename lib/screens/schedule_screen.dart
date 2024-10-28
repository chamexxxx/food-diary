import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/database_helper.dart';
import 'package:project/models/day_model.dart';
import 'package:project/models/dish_model.dart';
import 'package:project/models/meal_model.dart';
import 'package:project/widgets/meal_card.dart';
import 'package:project/widgets/schedule_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  late Future<List<DayModel>> _listFuture;

  final List<MealModel> meals = [MealModel(id: 1, name: 'Завтрак')];

  @override
  void initState() {
    super.initState();

    _listFuture = getAllDayModels();
  }

  void refreshList() {
    setState(() {
      _listFuture = getAllDayModels();
    });
  }

  Future<List<DayModel>> getAllDayModels() async {
    var db = await DatabaseHelper.instance.database;

    List<Map<String, Object?>> maps = await db.query('days');

    var days = maps.map((e) => DayModel.fromMap(e)).toList();

    print(days);

    return days;
  }

  Function() onCreateDayButtonPressed(String weekday) {
    return () async {
      var name = await showDialog<String?>(
          context: context,
          builder: (context) {
            var controller = TextEditingController();

            return Dialog.fullscreen(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration:
                          const InputDecoration(labelText: 'Название дня'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            Navigator.pop(context, controller.text);
                          }
                        },
                        child: const Text('Сохранить')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'))
                  ],
                ),
              ),
            );
          });

      if (name != null) {
        print(name);

        var db = await DatabaseHelper.instance.database;

        var id = await db.insert('days', {'name': name, 'weekday': weekday});

        refreshList();

        print('inserted id: ' + id.toString());
      }
    };
  }

  void onPressed() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Расписание на неделю'),
      ),
      body: Builder(builder: (context) {
        final double height = MediaQuery.of(context).size.height;

        var daysOfTheWeek = [
          'Понедельник',
          'Вторник',
          'Среда',
          'Четверг',
          'Пятница',
          'Суббота',
          'Воскресенье'
        ];

        var shortDaysOfTheWeek = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

        return FutureBuilder(
            future: _listFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('data'),
                );
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    // --- CAROUSEL PAGINATION ---
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(shortDaysOfTheWeek.length,
                              (int index) {
                            return Flexible(
                                child: ElevatedButton(
                              onPressed: () =>
                                  _carouselController.animateToPage(index),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(60),
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                shortDaysOfTheWeek[index],
                              ),
                            ));
                          }),
                        )),

                    // --- CAROUSEL ---
                    Expanded(
                        child: CarouselSlider.builder(
                            options: CarouselOptions(
                              height: height,
                              viewportFraction: 0.9,
                              aspectRatio: 2.0,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.2,
                            ),
                            carouselController: _carouselController,
                            itemCount: daysOfTheWeek.length,
                            itemBuilder: (context, index, realIndex) {
                              var weekday = daysOfTheWeek[index];

                              var dayModel = snapshot.data
                                  ?.where((e) => e.weekday == weekday)
                                  .firstOrNull;

                              if (dayModel == null) {
                                return ScheduleCard(
                                  weekday: weekday,
                                  children: [
                                    ScheduleCardEmptyState(
                                        onPressed:
                                            onCreateDayButtonPressed(weekday))
                                  ],
                                );
                              }

                              return ScheduleCard(
                                weekday: weekday,
                                children: [
                                  // --- DAY NAME ---
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 15),
                                    child: Text(
                                      dayModel.name,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),

                                  // --- MEALS ---
                                  Expanded(
                                      child: ListView(
                                    children: List.generate(meals.length,
                                        (int index) {
                                      var mealModel = meals[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: MealCard(
                                          mealModel: mealModel,
                                          dishModels: [
                                            const DishModel(
                                                name: 'Макароны с сыром')
                                          ],
                                        ),
                                      );
                                    }),
                                  ))
                                ],
                              );
                            }))
                  ],
                ),
              );
            });
      }),
    );
  }
}
