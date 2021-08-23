import 'package:cloud_firestore/cloud_firestore.dart';

class Crud {
  Future<void> add(blogData) async {
    FirebaseFirestore.instance.collection('blog').add(blogData);
  }

  Future<QuerySnapshot> getQuery() async {
    return await FirebaseFirestore.instance.collection('blog').get();
  }
}
