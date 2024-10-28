import 'package:flutter/material.dart';
import 'package:project/main.dart';
import 'package:project/screens/dish_screen.dart';
import 'package:project/screens/ingredient_screen.dart';
import 'package:project/screens/schedule_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'schedule',
      builder: (context, state) => const ScheduleScreen(),
    ),
    GoRoute(
      path: '/meals/:mealId/dishes',
      name: 'dish',
      builder: (context, state) =>
          DishScreen(mealId: int.parse(state.pathParameters['mealId']!)),
    ),
    GoRoute(
        path: '/ingredients',
        name: 'ingredient',
        builder: (context, state) => const IngredientScreen())
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => getIt<AppState>(),
      child: MaterialApp.router(
        routerConfig: _router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
