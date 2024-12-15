import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipeappwithfirebase/Components/RecipeSeconditem.dart';
import 'package:recipeappwithfirebase/Screens/RecipeDetail.dart';
import 'package:recipeappwithfirebase/Widget/widget_support.dart';
import 'package:recipeappwithfirebase/services/database.dart';

class Categorypage extends StatefulWidget {
  String Catname;
  Categorypage({super.key, required this.Catname});

  @override
  State<Categorypage> createState() => _CategorypageState();
}

class _CategorypageState extends State<Categorypage> {
  Stream? catstream;
  DatabaseServices databaseServices = DatabaseServices();
  getontheload() async {
    catstream = await databaseServices.showCategories(widget.Catname);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget showCategoriesRecipes() {
    return StreamBuilder(
      stream: catstream,
      builder: (context, AsyncSnapshot snapshots) {
        return snapshots.hasData
            ? GridView.builder(
              padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0),
                itemCount: snapshots.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshots.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(()=>Recipedetail(image: ds["Image"] ,recpiename: ds["RecipeName"] ,recipeDetail: ds["Detail"],));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 18, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                fit: BoxFit.cover,
                                ds["Image"],
                                height: 250,
                                width: 250,
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(
                              ds["RecipeName"],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50),
              child: Text(
                widget.Catname,
                style: AppWidget.overBoldstyle(),
              )),
              SizedBox(height: 10,),
          Expanded(child: showCategoriesRecipes()),
        ],
      ),
    );
  }
}
