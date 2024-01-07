import 'package:flutter/material.dart';
import 'package:spoonacular/model/meal_plan_model.dart';
import 'package:spoonacular/services/api_services.dart';

import 'meals_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /*
  Our state has three parameters.
  diets - list of diet that the spoonacular api let's us filter by,
  targetCalories - desired number of calories we want our mealplan to reach
  diet - our selected diet
  */

  final List<String> _diets = [
    //List of diets that lets spoonacular API filter out the recipes
    'None',
    'Gluten Free',
    'Ketogenic',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Whole30',
  ];

  double _targetCalories = 2250;
  String _diet = 'None';
  final String _labelSearch = 'none'; //NEW THING ADDED TO RECIEVE LABELS FROM THE CAMERA
//EDIT THIS AREA, or the API_services as needed to get the labels from the camera module to here


  //This method generates a MealPlan by parsing our parameters into the
  //ApiService.instance.generateMealPlan.
  //It then pushes the Meal Screen onto the stack with Navigator.push

  void _searchMealPlan() async {
  try {
    // Fetch recipes based on detected labels
    List<dynamic> recipes = await ApiService.instance.fetchRecipesByIngredients([_labelSearch]);
    
    // Extract recipe IDs from the fetched recipes
    List<int> recipeIds = recipes.map<int>((recipe) => recipe['id']).toList();
    
    // Generate meal plan using filtered ingredients and other parameters
    MealPlan mealPlan = await ApiService.instance.generateMealPlanWithFilteredIngredients(
      targetCalories: _targetCalories.toInt(),
      diet: _diet,
      labelSearch: [_labelSearch], // Pass detected label for filtering
    );

    // Navigate to MealsScreen with the generated meal plan and filtered recipes
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealsScreen(mealPlan: mealPlan, recipes: recipeIds),
      ),
    );
  } catch (error) {
    // Handle errors gracefully
    print('Error fetching recipes or generating meal plan: $error');
    // Show a snackbar or error message to the user
  }
}

  @override
  Widget build(BuildContext context) {
    /*
    Our build method returns Scaffold Container, which has a decoration
    image using a Network Image. The image loads and is the background of
    the page
    */

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=353&q=80'),
            fit: BoxFit.cover,
          ),
        ),

        //Center widget and a container as a child, and a column widget
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Text widget for the app's title
                const Text(
                  'My Daily Meal Planner',
                  style: TextStyle(fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                //space
                const SizedBox(height: 20),
                //A RichText to style the target calories
                RichText(
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 25),
                      children: [
                        TextSpan(
                            text:  _targetCalories.truncate().toString(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        const TextSpan(
                            text: 'cal',
                            style: TextStyle(
                                fontWeight: FontWeight.w600
                            )
                        ),
                      ]
                  ),
                ),
                //Orange slider that sets the target calories
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: Theme.of(context).primaryColor,
                    inactiveTrackColor: Colors.lightBlue[100],
                    trackHeight: 6,
                  ),
                  child: Slider(
                    min: 0,
                    max: 4500,
                    value: _targetCalories,
                    onChanged: (value) => setState(() {
                      _targetCalories = value.round().toDouble();
                    }
                    ),
                  ),
                ),
                //Simple drop down to select the type of diet for filtering
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: DropdownButtonFormField(
                    items: _diets.map((String priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(
                          priority,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Diet',
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _diet = value!;
                      });
                    },
                    value: _diet,
                  ),
                ),
                //Space
                const SizedBox(height: 30),
                TextButton(
                //_searchMealPlan
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed:  (){
                    setState(() {
                    _searchMealPlan();
                  });
                    },
                  child: const Text(
                    'Search', style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ) ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}