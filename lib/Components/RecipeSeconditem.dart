import 'package:flutter/material.dart';

class Recipeseconditem extends StatelessWidget {
  String recipeImage;
  String recipeText;
  String recipeDet;
  VoidCallback onTap;
   Recipeseconditem({super.key, required this.recipeText, required this.recipeImage  , required this.recipeDet , required this.onTap });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 18,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  fit: BoxFit.cover,
                  recipeImage,
                  height: 370,
                  width: 250,
                )),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left: 8),
              child: Text(
                recipeText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
