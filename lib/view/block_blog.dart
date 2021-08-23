import 'package:flutter/material.dart';

class Block extends StatelessWidget {
  final String? imageUrl, author, desc, title;
  const Block({Key? key, this.imageUrl, this.author, this.desc, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          ClipRRect(
            child: Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          Center(
            child: Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title!, style: TextStyle(fontSize: 35),),
                Text(author!, style: TextStyle(fontSize: 20),),
                Text(desc!, style: TextStyle(fontSize: 15),),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
