import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:recipeappwithfirebase/services/database.dart';

class Addrecipe extends StatefulWidget {
  const Addrecipe({super.key});

  @override
  State<Addrecipe> createState() => _AddrecipeState();
}

class _AddrecipeState extends State<Addrecipe> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  String? value;
  final List<String> recipelist = [
    'Soup Recipes',
    'Main Course',
    'Pak Recipes',
    'Chineese Recipes'
  ];

  DatabaseServices databaseServices = DatabaseServices();

  Future<void> getImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      print("No image selected");
    }
  }

  uploadRecipeData() async {
    if (_image != null && nameController != '' && detailController != '') {
      String addid = randomAlphaNumeric(10);

      Reference firebasestorageRef =
          FirebaseStorage.instance.ref().child('RecipeImages').child(addid);
      final UploadTask task = firebasestorageRef.putFile(_image!);
      var downloadurl = await (await task).ref.getDownloadURL();

      Map<String, dynamic> addrecp = {
        "RecipeName": nameController.text,
        "Detail": detailController.text,
        "Image": downloadurl,
        "Category" : value,
        "Key" : nameController.text.substring(0,1).toUpperCase(),
        "SearchedName" : nameController.text.toUpperCase(),
      };
        showDialog(context: context,builder: (context) {
          return Center(child: CircularProgressIndicator(),);
        },);
      databaseServices.addRecipeData(addrecp).then(
        (value) {
          nameController.text = '';
          detailController.text = '';
          Fluttertoast.showToast(msg: "Uploaded Success",backgroundColor: Colors.green,gravity: ToastGravity.BOTTOM,toastLength: Toast.LENGTH_LONG);

         Get.back();  
         },
      
        
      );
    } else {
      Fluttertoast.showToast(
          msg: "Fill All Fields",
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Icon(Icons.arrow_back_ios_new)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: const Text(
                      "Add Recipe",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: getImage,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 200,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.camera_alt_outlined,
                            size: 30,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Recipe Name",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    hintText: "Recipe Name",
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: recipelist
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        this.value = value;
                      }),
                      dropdownColor: Colors.white,
                      hint: Text("Select Category"),
                      icon: Container(
                        child: Icon(Icons.arrow_drop_down),
                      ),
                      iconSize: 35,
                      value: value,
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Recipe Details",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: detailController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    hintText: "Write a Recipe Detail",
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  uploadRecipeData();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
