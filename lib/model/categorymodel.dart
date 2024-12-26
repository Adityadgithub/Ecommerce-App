import 'package:flutter/material.dart';

import '../screens/Productsundercategory.dart';

class CategoryModel extends StatefulWidget {
  final id;
  final image;
  final title;
  CategoryModel({
    this.id,
    this.image,
    this.title,
  });

  @override
  State<CategoryModel> createState() => _CategoryModelState();
}

class _CategoryModelState extends State<CategoryModel> {
  // _CategoryModelState(image, title, ratings, ratedby, price);

  @override
  Widget build(BuildContext context) {
    return //Product list -
        Container(
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductsUnderCategory(category_id: widget.id.toString()),
                ));
          },
          child: Column(
            children: [
              Container(
                height: 120,
                width: 120,
                child: Image(image: AssetImage('${widget.image}')),
              ),
              Center(
                child: Text(
                  // softWrap: true,

                  // textAlign: TextAlign.center,
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          )),
    );
  }
}
