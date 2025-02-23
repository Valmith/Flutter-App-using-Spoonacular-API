//import meal_model.dart

import 'meal_model.dart';

class MealPlan {
  //MealPlan class has a list of meals and nutritional info about the meal plan
  late List<Meal> meals;
  late double calories, carbs, fat, protein;

  MealPlan({
    required this.meals,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein
  });


/*
The factory constructor iterates over the list of meals and our decoded mealplan
data and creates a list of meals.
Then, we return MealPlan object with all the information
*/

  // factory MealPlan.fromMap(Map<String, dynamic> map) {
  //   List<Meal> meals = [];
  //   map['meals'].forEach((mealMap) => meals.add(Meal.fromMap(mealMap)));
  //   //MealPlan object with information we want
  //   return MealPlan(
  //     meals: meals,
  //     calories: map['nutrients']['calories'],
  //     carbs: map['nutrients']['carbohydrates'],
  //     fat: map['nutrients']['fat'],
  //     protein: map['nutrients']['protein'],
  //   );
  // }

factory MealPlan.fromMap(Map<String, dynamic> map) {
  try {
    List<Meal> meals = [];
    if (map.containsKey('meals')) {
      map['meals'].forEach((mealMap) {
        try {
          meals.add(Meal.fromMap(mealMap));
        } catch (e) {
          print('Error creating Meal object: $e');
        }
      });
    } else {
      print('API response does not contain meals.');
    }

    return MealPlan(
      meals: meals,
      calories: map['nutrients']['calories'],
      carbs: map['nutrients']['carbohydrates'],
      fat: map['nutrients']['fat'],
      protein: map['nutrients']['protein'],
    );
  } catch (e) {
    print('Error creating MealPlan object: $e');
    rethrow;
  }
}

}