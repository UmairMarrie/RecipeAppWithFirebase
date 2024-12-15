import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {



 Future addRecipeData (Map<String,dynamic>RecipeMap) async {

  return await FirebaseFirestore.instance.collection("RecipesData").doc().set(RecipeMap);

 }

 Future <Stream<QuerySnapshot>> getAllRecipes () async {
    return await FirebaseFirestore.instance.collection("RecipesData").snapshots();
    
 }

 Future <Stream<QuerySnapshot>> showCategories (String Catname) async {

  return await FirebaseFirestore.instance.collection("RecipesData").where("Category",isEqualTo:Catname ).snapshots();
 }
     
     Future <QuerySnapshot>  Searchfromdatabase (String name) async{

      return await FirebaseFirestore.instance.collection("RecipesData").where("Key",isEqualTo: name.substring(0,1).toUpperCase()).get();


     }



}