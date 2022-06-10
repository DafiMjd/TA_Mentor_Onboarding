// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final VoidCallback press;
  

  const CategoryItem({required this.categoryName, required this.categoryColor, 
      required this.press});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: press,
      child: Container(
        margin: EdgeInsets.only(
          left: 18,
          right: 18,
        ),
        width: MediaQuery.of(context).size.height * 0.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              width: MediaQuery.of(context).size.height * 0.1,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Icon(Icons.task, color: Colors.grey.shade100, size: 28,),
            ),
            Text(
              categoryName,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
