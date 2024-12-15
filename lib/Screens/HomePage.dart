import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipeappwithfirebase/Components/RecipeItem.dart';
import 'package:recipeappwithfirebase/Components/RecipeSeconditem.dart';
import 'package:recipeappwithfirebase/Screens/AddRecipe.dart';
import 'package:recipeappwithfirebase/Screens/CategoryPage.dart';
import 'package:recipeappwithfirebase/Screens/RecipeDetail.dart';
import 'package:recipeappwithfirebase/Widget/widget_support.dart';
import 'package:recipeappwithfirebase/services/database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Stream? recipestream;
  DatabaseServices databaseServices = DatabaseServices();

  getontheload() async {
    recipestream = await databaseServices.getAllRecipes();
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget showAllRecipes() {
    return StreamBuilder(
      stream: recipestream,
      builder: (context, AsyncSnapshot snapshots) {
        return snapshots.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshots.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshots.data.docs[index];
                  return Recipeseconditem(
                    recipeText: ds["RecipeName"],
                    recipeImage: ds["Image"],
                    recipeDet: ds["Detail"],
                    onTap: () {
                      Get.to(
                          Recipedetail(
                            image: ds["Image"],
                            recpiename: ds["RecipeName"],
                            recipeDetail: ds["Detail"],
                          ),
                          transition: Transition.fadeIn);
                    },
                  );
                },
              )
            : Container();
      },
    );
  }

  // search Bar code start ....................

  bool search = false;
  var queryResultSet = [];
  var tempSearchstore = [];

//funstart
  initateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchstore = [];
      });
    }
    setState(() {
      search = true;
    });

    var Capitilizedvalue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      databaseServices.Searchfromdatabase(value).then(
        (QuerySnapshot docs) {
          for (int i = 0; i < docs.docs.length; ++i) {
            queryResultSet.add(docs.docs[i].data());
          }
        },
      );
    } else {
      tempSearchstore = [];
      queryResultSet.forEach(
        (element) {
          if (element['SearchedName'].startsWith(Capitilizedvalue)) {
            setState(() {
              tempSearchstore.add(element);
            });
          }
        },
      );
    }
  }
  //fun end
  //searchbar code end......................

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Get.to(Addrecipe(), transition: Transition.downToUp);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50, left: 15, right: 15),
            child: Row(
              children: [
                Text(
                  "Looking For Your\n Favourite Meal",
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'asset/images/person.jpg',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25)),
            child: TextField(
              onChanged: (value) {
                initateSearch(value.toUpperCase());
              },
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "Search Recipe",
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          search
              ? ListView(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  primary: false,
                  shrinkWrap: true,
                  children: tempSearchstore
                      .map(
                        (element) {
                          return buildResultCard(element);
                        },
                      )
                      .toList(),
                )
              : Container(
                  height: 170,
                  child: Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Recipeitem(
                          recipeText: "Soup Recipes",
                          recipeimage: 'asset/images/soupfood.jpg',
                          onTap: () {
                            Get.to(Categorypage(
                              Catname: "Soup Recipes",
                            ));
                          },
                        ),
                        Recipeitem(
                            recipeText: "Main Course",
                            recipeimage: 'asset/images/mainfood.jpg',
                            onTap: () {
                              Get.to(Categorypage(
                                Catname: "Main Course",
                              ));
                            }),
                        Recipeitem(
                            recipeText: "PakRecipes",
                            recipeimage: 'asset/images/pakfood.jpg',
                            onTap: () {
                              Get.to(Categorypage(
                                Catname: "PakRecipes",
                              ));
                            }),
                        Recipeitem(
                            recipeText: "Chineese Recipes",
                            recipeimage: 'asset/images/chineesefood.jpg',
                            onTap: () {
                              Get.to(Categorypage(
                                Catname: "Chineese Recipes",
                              ));
                            }),
                      ],
                    ),
                  ),
                ),
      search ? Container() :   Expanded(
            child: showAllRecipes(),
          )
        ],
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Get.to(()=>Recipedetail(image: data["Image"],recpiename: data["RecipeName"],recipeDetail: data["Detail"],));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    data['Image'],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20,),
                Text(data["RecipeName"],style: AppWidget.boldFieldTextStyle(),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
