import 'package:blog/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './create_blog.dart';
import './block_blog.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Crud _crud = Crud();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Flutter',
              style: TextStyle(fontSize: 25),
            ),
            Text(
              'Blog',
              style: TextStyle(color: Colors.blue, fontSize: 25),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
          initialData: [],
          future: _crud.getQuery(),
          builder: (context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Block(
                      author: snapshot.data.docs[index].get('author'),
                      title: snapshot.data.docs[index].get('title'),
                      desc: snapshot.data.docs[index].get('desc'),
                      imageUrl: snapshot.data.docs[index].get('downloadURL'));
                });
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()))
                .then((value) => setState(() {}));
          },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}