import 'dart:io';

import 'package:blog/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';
class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String _name = '', _title = '', _desc = '';
  File? image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Crud _crud = Crud();
  Future getImage() async {
    // Pick an image
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("failed to access gallery");
    }
  }

  Future uploadInfo() async {
    if (image != null) {
      setState(() {
        _isLoading = true;
      });
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child("blogImages").child('${randomAlpha(9)}.jpg');
      UploadTask uploadTask = ref.putFile(image!);
      uploadTask.then((res) async {
        var downloadURL = await res.ref.getDownloadURL();
        Map<String, dynamic> blogInfo = {
          "downloadURL": downloadURL,
          "author": _name,
          "title": _title,
          "desc": _desc
        };
        _crud.add(blogInfo).then((value) => Navigator.pop(context));
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadInfo();
            },
            icon: Icon(Icons.upload),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: _isLoading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Container(
              padding: EdgeInsets.all((15)),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: image != null
                        ? Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              image!,
                              fit: BoxFit.contain,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ))
                        : Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white38),
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: Icon(Icons.add_a_photo)),
                          ),
                  ),
                  TextField(
                    onChanged: (value) {
                      _name = value;
                    },
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        hintText: 'Author Name',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )),
                  ),
                  TextField(
                    onChanged: (value) {
                      _title = value;
                    },
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )),
                  ),
                  TextField(
                    onChanged: (value) {
                      _desc = value;
                    },
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        hintText: 'Description',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
    );
  }
}
