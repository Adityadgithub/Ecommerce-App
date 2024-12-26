import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../model/categoryprodmodel.dart';

class ProductsUnderCategory extends StatefulWidget {
  var category_id;
  ProductsUnderCategory({this.category_id});

  @override
  State<ProductsUnderCategory> createState() => _ProductsUnderCategoryState();
}

class _ProductsUnderCategoryState extends State<ProductsUnderCategory> {
  List prodId = [];
  List prodName = [];
  List prodPrice = [];
  List prodImage = [];
  List prodRatings = [];

  List productmodelist = [];

  bool apicalled = false;

  // _ProductModelState(image, title, ratings, ratedby, price);

  Future<List> callapi() async {
    // print('apicalled');
    var url = Uri.parse('http://thenirmanstore.com/v1/product/products');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    // print('Category Id - ${widget.category_id}');
    var responce = await http.post(url, body: {
      'category_id': widget.category_id.toString(),
    });
    var json = jsonDecode(responce.body);
    setState(() {
      apicalled = true;
    });
    // print(apicalled);
    // print('json msg printed?');
    // print(json['data']);
    var data = await json['data'];
    var datalength = json['data'].length;
    // print('Datalength $datalength');

    for (int i = 0; i < datalength; i++) {
      prodId.add(data[i]['id']);
      prodName.add(data[i]['product_name']);
      prodImage.add(data[i]['product_image'][0]['search_image']);
      prodPrice.add(data[i]['price']);
      prodRatings.add(data[i]['product_ratings']);

      // // print('x');
    }

    for (int i = 0; i < prodName.length; i++) {
      productmodelist.add(CategoryProductsModel(
        id: prodId[i],
        price: prodPrice[i],
        image: prodImage[i],
        title: prodName[i],
        ratings: 5,
        ratedby: 7,
      ));
    }
    // name = data[0]['name'];
    setState(() {});
    // print(prodName);
    // if (json['status'] == 1) {
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => HomePage(),
    //       ));
    // } else {
    //   setState(() {
    //     _error = json['message'];
    //   });
    // }
    return prodName;
  }

  @override
  void initState() {
    setState(() {
      apicalled = false;
    });
    callapi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: SizedBox(),

            centerTitle: true,
            title: Text(
              "Products",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(255, 249, 248, 248),
            elevation: 0),
        body: Column(
          children: [
            if (productmodelist.isNotEmpty)
              Column(children: [
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Row(
                            //   children: [
                            //     Icon(
                            //       Icons.filter_list_outlined,
                            //       size: 30,
                            //     ),
                            //     SizedBox(width: 5),
                            //     Text('Filters')
                            //   ],
                            // ),
                            // Row(
                            //   children: [
                            //     Icon(
                            //       Icons.sort_rounded,
                            //       size: 30,
                            //     ),
                            //     SizedBox(width: 5),
                            //     Text('Sort')
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      GridView.count(
                        // mainAxisSpacing: 5,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: [...productmodelist],
                      ),
                    ],
                  ),
                )
              ]),
            if (productmodelist.isEmpty && apicalled == false)
              Expanded(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator.adaptive())),
              ),
            if (productmodelist.isEmpty && apicalled == true)
              Expanded(
                  child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel_outlined),
                    SizedBox(width: 8),
                    Text(
                      'No Products Found',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ))
          ],
        ));
  }
}
