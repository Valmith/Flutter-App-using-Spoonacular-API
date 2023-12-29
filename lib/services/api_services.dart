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


  //Add base URL for the spoonacular API
  final String _baseURL = "api.spoonacular.com";
  static const String API_KEY ="e1ea9d28071547329684438575c5d5c6";

  //We create async function to generate meal plan which takes in
  //timeFrame, targetCalories, diet and apiKey

  //If diet is none, we set the diet into an empty string

  //timeFrame parameter sets our meals into 3 meals, which are daily meals.
  //that's why it's set to day

  Future<MealPlan> generateMealPlan({required int targetCalories, required String diet}) async {
  try {
    print('generateMealPlan - Start');
    print('targetCalories: $targetCalories, diet: $diet');

    // Check if diet is null or empty, and set it to an empty string if necessary
    if (diet == null || diet.isEmpty) {
      diet = '';
    }

    // Check if targetCalories is not null
    if (targetCalories == null) {
      throw 'Target calories cannot be null.';
    }

    // Construct the parameters
    Map<String, String> parameters = {
      'timeFrame': 'day',
      'targetCalories': targetCalories.toString(),
      'diet': diet,
      'apiKey': API_KEY,
    };

    // Construct the URI
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/mealplans/generate',
      parameters,
    );

    // Set the headers
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Make the API request
    var response = await http.get(uri, headers: headers);

    // Check if the response status code is OK (200)
    if (response.statusCode == 200) {
      // Decode the response body into a map
      Map<String, dynamic>? data = json.decode(response.body);
      print('API Response Data: $data');

      // Check if the 'meals' key exists in the response
if (data != null && data.containsKey('meals')) {
  // Check if 'nutrients' key exists in the response
  if (data.containsKey('nutrients')) {
    // Ensure that individual nutrient values are not null
    double? fat = data['nutrients']['fat'];
    double? carbohydrates = data['nutrients']['carbohydrates'];
    double? calories = data['nutrients']['calories'];
    double? protein = data['nutrients']['protein'];
    
    print("THIS IS TO SEE IF THE NUTRIENTS ARE IN "'Fat: $fat, Carbohydrates: $carbohydrates, Calories: $calories, Protein: $protein');
  
    if (fat != null && carbohydrates != null && calories != null && protein != null) {
      // Convert the map into a MealPlan object
      MealPlan mealPlan = MealPlan.fromMap(data);
      print('generateMealPlan - End');
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
    // If an error occurs during the process, throw an error message
    print('generateMealPlan - Error: $err');
    throw err.toString();
  }
}



  //the fetchRecipe takes in the id of the recipe we want to get the info for
  //We also specify in the parameters that we don't want to include the nutritional
  //information
  //We also parse in our API key
  Future<Recipe> fetchRecipe(String id) async {
    Map<String, String> parameters = {
      'includeNutrition': 'false',
      'apiKey': API_KEY,
    };

    //we call in our recipe id in the Uri, and parse in our parameters
    Uri uri = Uri.https(
      _baseURL,
      '/recipes/$id/information',
      parameters,
    );

    //And also specify that we want our header to return a json object
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    //finally, we put our response in a try catch block
    try{
      var response = await http.get(uri, headers: headers);
      Map<String, dynamic> data = json.decode(response.body);
      Recipe recipe = Recipe.fromMap(data);
      return recipe;
    }catch (err) {
      throw err.toString();
    }

  }

}