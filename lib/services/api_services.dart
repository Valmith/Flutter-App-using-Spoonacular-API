//This file will handle all our API calls to the
//Spoonacular API, hehe

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:spoonacular/model/meal_plan_model.dart';
import 'package:spoonacular/model/recipe_model.dart';

class ApiService {
  ApiService._instantiate();
  static final ApiService instance = ApiService._instantiate();

  final String _baseURL = "api.spoonacular.com";
  static const String API_KEY ="e1ea9d28071547329684438575c5d5c6";

  Future<List<int>> fetchRecipesByIngredients(List<String> ingredients) async {
    try {
      print('fetchRecipesByIngredients - Start');
      print('Ingredients: $ingredients');

      Map<String, String> parameters = {
        'apiKey': API_KEY,
        'ingredients': ingredients.join(','),
      };

      Uri uri = Uri.https(
        _baseURL,
        '/recipes/findByIngredients',
        parameters,
      );

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };

      var response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print('API Response Data: $data');

        List<int> recipeIds = data.map<int>((recipe) => recipe['id']).toList();

        print('fetchRecipesByIngredients - End');
        return recipeIds;
      } else {
        throw 'Error: ${response.statusCode}';
      }
    } catch (err) {
      print('fetchRecipesByIngredients - Error: $err');
      throw err.toString();
    }
  }

  Future<MealPlan> generateMealPlanWithFilteredIngredients({
    required int targetCalories,
    required String diet,
    required List<String> labelSearch,
  }) async {
    try {
      print('generateMealPlanWithFilteredIngredients - Start');
      print('targetCalories: $targetCalories, diet: $diet, labelSearch: $labelSearch');

      if (diet == null || diet.isEmpty) {
        diet = '';
      }

      if (targetCalories == null) {
        throw 'Target calories cannot be null.';
      }

      Map<String, String> parameters = {
        'timeFrame': 'day',
        'targetCalories': targetCalories.toString(),
        'diet': diet,
        'apiKey': API_KEY,
        'ingredients': labelSearch.join(','),
      };

      Uri uri = Uri.https(
        _baseURL,
        '/recipes/mealplans/generate',
        parameters,
      );

      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };

      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic>? data = json.decode(response.body);
        print('API Response Data: $data');

        if (data != null && data.containsKey('meals')) {
          if (data.containsKey('nutrients')) {
            double? fat = data['nutrients']['fat'];
            double? carbohydrates = data['nutrients']['carbohydrates'];
            double? calories = data['nutrients']['calories'];
            double? protein = data['nutrients']['protein'];

            print("Nutrient Info: Fat: $fat, Carbohydrates: $carbohydrates, Calories: $calories, Protein: $protein");

            if (fat != null && carbohydrates != null && calories != null && protein != null) {
              MealPlan mealPlan = MealPlan.fromMap(data);
              print('generateMealPlanWithFilteredIngredients - End');
              return mealPlan;
            } else {
              throw 'One or more nutrient values are null.';
            }
          } else {
            throw 'Response does not contain the expected "nutrients" data structure.';
          }
        } else {
          throw 'Response does not contain the expected "meals" data structure.';
        }
      } else {
        throw 'Error: ${response.statusCode}';
      }
    } catch (err) {
      print('generateMealPlanWithFilteredIngredients - Error: $err');
      throw err.toString();
    }
  }

  Future<Recipe> fetchRecipe(String id) async {
    Map<String, String> parameters = {
      'includeNutrition': 'false',
      'apiKey': API_KEY,
    };

    Uri uri = Uri.https(
      _baseURL,
      '/recipes/$id/information',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    try {
      var response = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(response.body);
      Recipe recipe = Recipe.fromMap(data);
      return recipe;
    } catch (err) {
      throw err.toString();
    }
  }
}
