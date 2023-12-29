class Meal {
  final int id;
  final String title, imgURL;

  Meal({
    required this.id,
    required this.title,
    required this.imgURL
  });

//This class has an ID which allows us to get the Recipes and other info
//Such as title and Image URL

/*
Factory Constructor Meal.fromMap parses the decoded JSON data to get the
values of the meal, and returns the Meal Object
*/

  factory Meal.fromMap(Map<String, dynamic> map) {
  return Meal(
    id: map['id'] ?? 0, // Provide a default value if 'id' is null
    title: map['title'] ?? '', // Provide a default value if 'title' is null
    imgURL: map['image'] != null
        ? 'https://spoonacular.com/recipeImages/' + map['image']
        : '', // Provide a default value or handle null 'image'
  );
}

}