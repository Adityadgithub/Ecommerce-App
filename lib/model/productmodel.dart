// CART PRODUCT MODEL

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../screens/SplashScreen.dart';
import '../screens/productdetailsP.dart';

class ProductModel extends StatefulWidget {
  final api;
  final id;
  final image;
  final title;
  final ratings;
  final ratedby;
  final price;
  final cart_item_id;
  final cart_id;

  ProductModel(
      {required this.api,
      this.id,
      this.image,
      this.title,
      this.ratings,
      this.ratedby,
      this.price,
      this.cart_item_id,
      this.cart_id});

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  var data;
  var datalength;

  bool apicalled = false;

  void deletefromwishlist() async {
    try {
      var headers = {
        'x-access-token': '$globalusertoken',
        'Cookie': 'ci_session=e8daebc9c3fe6cc93fdf999ed4c5457e27b5c185'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://thenirmanstore.com/v1/product/delete_wish_list_product'));
      request.fields.addAll({'product_id': widget.id});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e);
    }
    // return json;
  }

  void deletefromcart(cart_item_id, cart_id) async {
    try {
      var headers = {
        'x-access-token': '$globalusertoken',
        'Cookie': 'ci_session=e8daebc9c3fe6cc93fdf999ed4c5457e27b5c185'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/cart/delete_cart_item'));
      request.fields.addAll({'cart_item_id': cart_item_id, 'cart_id': cart_id});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e);
    }
    // return json;
  }

  @override
  Widget build(BuildContext context) {
    return //Product list -

        InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsP(prodid: widget.id)));
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 8,
                right: 5,
                top: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 242, 242, 242),
              ),
              child: Column(
                children: [
                  Container(
                      height: 140,
                      child: Image(
                          fit: BoxFit.cover, image: AssetImage(widget.image))),
                  Text(
                    '${widget.title}',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.currency_rupee_sharp, size: 17),
                          Text(
                            widget.price,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              color: Colors.blue.shade800,
                              icon: Icon(
                                Icons.delete,
                              ),
                              onPressed: () {
                                if (widget.api == 'wishlist') {
                                  deletefromwishlist();
                                }
                                if (widget.api == 'cart') {
                                  deletefromcart(
                                      widget.cart_item_id, widget.cart_id);
                                }
                              },
                            )),
                      )
                    ],
                  )
                ],
              ),
            ));
  }
}
