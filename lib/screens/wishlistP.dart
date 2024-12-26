import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/productmodel.dart';
import 'SplashScreen.dart';

class WishListP extends StatefulWidget {
  const WishListP({super.key});

  @override
  State<WishListP> createState() => _WishListPState();
}

class _WishListPState extends State<WishListP> {
  var wish;
  int index = 0;
  Map wishlist = Map();
  bool apicalled = false;

  Future<void> productWishList() async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=993f8ce175c6855b3ce46babd7962928f32a41ed'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/product/product_wish'));

      request.headers.addAll(headers);
      //   // print('wishlist api called');

      http.StreamedResponse response = await request.send();
      wish = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          wishlist = jsonDecode(wish);

 // remove this -
        wishlist = {'status': 1, 'message': 'Cart item found', 'total_quantity': 1, 'total_amount': 480, 'data': [{
        "id": "1",
        "product_name": "Dell XPS 13",
        "short_description": "Dell XPS 13 Ultrabook",
        "long_description": "Dell XPS 13 Ultrabook with InfinityEdge display",
        "product_highlights": "Ultra-thin and powerful",
        "discount_percent": "0.00",
        "price": "67,000.00",
        "stock": "500",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image": "assets/images/temp/products/prod1.png",
            "catalog_image":
                "assets/images/temp/products/prod1.png",
            "cart_image": "assets/images/temp/products/prod1.png"
          }
        ],
        "product_ratings": ""
      },]};



          apicalled = true;
        });
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
    return wish;
  }

  void delete_product() {
    // print('product deleted ');
    setState(() {});
    // wishlist.removeLast();

    setState(() {});
  }

  @override
  void initState() {
    productWishList();
    super.initState();
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Exit'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'WISHLIST',
            style: TextStyle(
                color: Colors.black, fontSize: 22.5, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: SizedBox(),
          backgroundColor: Color.fromARGB(255, 249, 248, 248),
          elevation: 0.5,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                wishlist['status'] != 0
                    ? Expanded(
                        child: FutureBuilder(
                            future: productWishList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData)
                                return Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: GridView.builder(
                                    itemCount: wishlist['data'].length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              1.6),
                                      crossAxisCount:
                                          2, // Set the number of columns in the grid
                                      crossAxisSpacing:
                                          10, // Set the spacing between columns
                                      mainAxisSpacing:
                                          10, // Set the spacing between rows
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ProductModel(
                                          api: 'wishlist',
                                          id: wishlist['data'][index]['id'],
                                          image: wishlist['data'][index]
                                                  ['product_image'][0]
                                              ['search_image'],
                                          title: wishlist['data'][index]
                                              ['product_name'],
                                          ratings: wishlist['data'][index]
                                                  ['product_ratings']
                                              .toString(),
                                          price: wishlist['data'][index]
                                              ['price']);
                                    },
                                  ),
                                );

                              if (snapshot.hasError)
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Tap the '),
                                        Icon(Icons.favorite_border),
                                        Text(
                                            ' Icon to add a product in your wishlist!')
                                      ],
                                    ),
                                  ),
                                );
                              return Center(
                                  child: CircularProgressIndicator.adaptive());
                            }),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: Column(
                            children: [
                              if (apicalled == false)
                                Center(
                                    child: CircularProgressIndicator.adaptive()),
                              if (apicalled == true)
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Tap the '),
                                        Icon(Icons.favorite_border),
                                        Text(
                                            ' Icon to add a product in your wishlist!')
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
