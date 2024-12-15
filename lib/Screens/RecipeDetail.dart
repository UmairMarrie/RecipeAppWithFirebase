import 'package:flutter/material.dart';

class Recipedetail extends StatelessWidget {
  String image;
  String recpiename;
  String recipeDetail;

   Recipedetail({super.key, required this.image , required this.recpiename , required this.recipeDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.2),
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recpiename,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          textAlign: TextAlign.justify,
                          recipeDetail,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8,),
                      
                      ],
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
