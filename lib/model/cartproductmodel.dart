// CART PRODUCT MODEL

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../screens/SplashScreen.dart';

class CartProductModel extends StatefulWidget {
  final api;
  final id;
  final image;
  final title;
  final ratings;
  final ratedby;
  final price;
  final cart_item_id;
  final cart_id;
  final avaibility;
  var quantity;

  CartProductModel(
      {required this.api,
      this.id,
      this.image,
      this.title,
      this.ratings,
      this.ratedby,
      this.price,
      this.cart_item_id,
      this.cart_id,
      this.avaibility,
      this.quantity});

  @override
  State<CartProductModel> createState() => _CartProductModelState();
}

class _CartProductModelState extends State<CartProductModel> {
  var data;
  var datalength;

  bool apicalled = false;
  int localquantity = 0;
  var updatecartresponse;
  @override
  void initState() {
    localquantity = int.parse(widget.quantity);

    // TODO: implement initState
    super.initState();
  }

  void deletefromwishlist() async {
    try {
      var headers = {
        'x-access-token':
            '$globalusertoken',
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

  void deletefromcart({cart_item_id, cart_id}) async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
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

  void updatecartapi(updatequantity) async {
    // print('apicalled');
    var url = Uri.parse('http://thenirmanstore.com/v1/cart/update_cart_item');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    var responce = await http.post(url, body: {
      'cart_item_id': widget.cart_item_id.toString(),
      'cart_id': widget.cart_id.toString(),
      'quantity': updatequantity.toString()
    }, headers: {
      'x-access-token':
      '$globalusertoken',
    });

    if (responce.statusCode == 200) {
      setState(() {
        apicalled = true;
        updatecartresponse = jsonDecode(responce.body);
      });
    }

    var json = jsonDecode(responce.body);
    // // print(responce.statusCode);
    // print('json msg printed?');
    // print(json['data']);
    // print(json.length);
    try {} catch (e) {}
    data = json['data'];
    // datalength = json['data'].length;
  }

  @override
  Widget build(BuildContext context) {
    // // print('${widget.title} - ${widget.quantity}');
    // print(widget.avaibility);
    return //Product list -

        Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: InkWell(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage('${widget.image}')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 15, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        '${widget.title}',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.currency_rupee_sharp, size: 15),
                        Text(
                          '${widget.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.avaibility == '1')
                      Text(
                        'In Stock',
                        style: TextStyle(color: Colors.green),
                      ),
                    if (widget.avaibility == '0')
                      Text(
                        'Out Of Stock',
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (localquantity > 0)
                              setState(() {
                                localquantity -= 1;
                                widget.quantity = localquantity.toString();
                              });
                            if (localquantity > 1) {
                              updatecartapi(localquantity);
                            }
                            if (localquantity <= 1) {
                              deletefromcart(
                                  cart_id: widget.cart_id,
                                  cart_item_id: widget.cart_item_id);
                            }
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            elevation: 2,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(localquantity > 1
                                    ? Icons.remove
                                    : Icons.delete)),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text('$localquantity'),
                        SizedBox(width: 15),
                        InkWell(
                          onTap: () {
                            setState(() {
                              localquantity += 1;
                              widget.quantity = localquantity.toString();
                            });
                            // print(localquantity);
                            updatecartapi(localquantity);
                          },
                          child: Material(
                            borderRadius: BorderRadius.circular(15),
                            elevation: 2,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.add)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
        ),
        // Align(
        //     alignment: Alignment.bottomRight,
        //     child: CircleAvatar(
        //         backgroundColor: Colors.red,
        //         child: IconButton(
        //           color: Colors.white,
        //           icon: Icon(
        //             Icons.delete,
        //           ),
        //           onPressed: () {
        //             if (widget.api == 'wishlist') {
        //               deletefromwishlist();
        //             }
        //             if (widget.api == 'cart') {
        //               deletefromcart(widget.cart_item_id, widget.cart_id);
        //             }
        //           },
        //         )))
      ],
    );
  }
}
