import 'package:flutter/material.dart';

class Recipeitem extends StatelessWidget {
  String recipeText;
  String recipeimage;
  VoidCallback onTap;

 Recipeitem({super.key, required this.recipeText , required this.recipeimage , required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 18),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              fit: BoxFit.cover,
                             recipeimage,
                              height: 110,
                              width: 110,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          recipeText,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
    );
  }
}