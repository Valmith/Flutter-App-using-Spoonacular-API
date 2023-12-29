import 'package:flutter/material.dart';
import 'package:spoonacular/model/meal_model.dart';
import 'package:spoonacular/model/meal_plan_model.dart';
import 'package:spoonacular/model/recipe_model.dart';
import 'package:spoonacular/screens/recipe_screen.dart';
import 'package:spoonacular/services/api_services.dart';

class MealsScreen extends StatefulWidget {
  //It returns a final mealPlan variable
  final MealPlan mealPlan;
  MealsScreen({required this.mealPlan});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {

/*
Returns aContainer with Curved edges and a BoxShadow.
The child is a column widget that returns nutrient information in Rows
 */

_buildTotalNutrientsCard() {
  return Container(
    height: 200, // Adjusted height to accommodate content
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Total Nutrients',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  'Calories: ${widget.mealPlan.calories.toString()} cal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'Protein: ${widget.mealPlan.protein.toString()} g',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  'Fat: ${widget.mealPlan.fat.toString()} g',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'Carb: ${widget.mealPlan.carbs.toString()} cal',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

//end of total nutrients card

//PROBLEMS START HERE

//This method below takes in parameters meal and index

  _buildMealCard(Meal meal, int index) {
  String mealType = _mealType(index);

  return GestureDetector(
    onTap: () async {
      if (meal.id != null) {
        Recipe recipe = await ApiService.instance.fetchRecipe(meal.id.toString());
        Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeScreen(
          mealType: mealType,
          recipe: recipe,
        )));
      } else {
        // Handle case where meal ID is null
        // You can show an error message or handle it as per your app logic
        print('Meal ID is null');
      }
    },
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 220,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            image: meal.imgURL != null
                ? DecorationImage(
                    image: NetworkImage(meal.imgURL),
                    fit: BoxFit.cover,
                  )
                : null, // Handle null imgURL
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 6,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(60),
          padding: EdgeInsets.all(10),
          color: Colors.white70,
          child: Column(
            children: <Widget>[
              Text(
                mealType ?? '', // Handle null mealType
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                meal.title ?? '', // Handle null title
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    ),
  );
}


/*
mealType returns Breakfast, Lunch or Dinner, depending on the index value
*/
  _mealType(int index) {
    switch (index) {
      case 0:
        return 'Breakfast';
      case 1:
        return 'Lunch';
      case 2:
        return 'Dinner';
      default:
        return 'Breakfast';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //has an appBar
      appBar: AppBar(title: Text('Your Meal Plan')),
      //and body as a ListView builder
      body: ListView.builder(
        /*
        We set itemCount to 1 + no. of meals, which based on our API call,
        the no. of meals should always be 3
        */
          itemCount: 1 + widget.mealPlan.meals.length,
          itemBuilder: (BuildContext context, int index) {
            /*
            If index is 0, we return a method called _buildTotalNutrientsCard()
            */
            if (index == 0) {
              return _buildTotalNutrientsCard();
            }
            /*
            Otherwise, we return a buildMealCard method that takes in the meal,
            and index - 1
            */
            Meal meal = widget.mealPlan.meals[index - 1];
            return _buildMealCard(meal, index - 1);
          }),
    );
  }
}

