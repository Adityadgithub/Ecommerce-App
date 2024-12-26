import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/cartproductmodel.dart';
import 'SplashScreen.dart';
import 'checkout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

var price = 51;

class _CartState extends State<Cart> {
  bool apicalled = false;
  var quantity = 1;
  var price_initial_value = 51;
  List prodId = [];
  List prodName = [];
  List prodPrice = [];
  List prodImage = [];
  List prodRatings = [];
  List cart_item_id = [];
  List cart_id = [];

  Map cartlist = Map();

  var data;
  var datalength;

  bool checkoutable = false;

  Future<List> callapi() async {
    //// print('apicalled');
    var url = Uri.parse('http://thenirmanstore.com/v1/cart/cart_in_item');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    var responce = await http.post(url, body: {}, headers: {
      'x-access-token':
      '$globalusertoken',
    });

    if (responce.statusCode == 200) {
      setState(() {
        apicalled = true;
        cartlist = jsonDecode(responce.body);
       
       // remove this -
        cartlist = {'status': 1, 'message': 'Cart item found', 'total_quantity': 1, 'total_amount': 480, 'data': [{
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

        print(cartlist);
      });
    }

    // // print('cart api response ${cartlist}');
    // // print('token ${globalusertoken}');
    if (cartlist['status'] == 1) {
      setState(() {
        checkoutable = true;
      });
    }

    // print('cart json msg printed?');
    var json = jsonDecode(responce.body);
    // // print(responce.statusCode);
    //  // print(json['data']);
    //// print(json.length);
    try {} catch (e) {}
    data = json['data'];

    //datalength = json['data'].length;
    //// print(prodName);
    return prodName;
  }

  @override
  void initState() {
    callapi();
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
            'CART',
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: SizedBox(),
          backgroundColor: Color.fromARGB(255, 230, 230, 230),
          elevation: 1,
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(255, 230, 230, 230),
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'View and edit your cart\nor proceed to check out!',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 17),
                        cartlist['status'] != 0
                            ? FutureBuilder(
                                future: callapi(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.62,
                                            child: ListView.builder(
                                              itemCount: cartlist['data'].length,
                                              itemBuilder: (BuildContext context,
                                                  int index) {
                                                return Column(
                                                  children: [
                                                    CartProductModel(
                                                      api: 'cart',
                                                      image: cartlist['data'][index]
                                                              ['product_image'][0]
                                                          ['search_image'],
                                                      title: cartlist['data'][index]
                                                          ['product_name'],
                                                      ratings: cartlist['data'][index]
                                                              ['product_ratings']
                                                          .toString(),
                                                      price: cartlist['data'][index]
                                                          ['price'],
                                                      cart_id: cartlist['data'][index]
                                                          ['cart_id'],
                                                      cart_item_id: cartlist['data']
                                                          [index]['cart_item_id'],
                                                      avaibility: cartlist['data']
                                                          [index]['available'],
                                                      quantity: cartlist['data']
                                                          [index]['quantity']),
                                                    SizedBox(height: 10,)
                                                  ],
                                                );
                                              },
                                            )),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  elevation: 5,
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30),
                                                        // rgba(211, 38, 38, 0.25);
                                                        color: Colors.blue[800],
                                                      ),
                                                      child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CheckOut(
                                                                      deliverycharges:
                                                                          '150',
                                                                      finalprice:
                                                                          '13000',
                                                                      paymentmethod:
                                                                          'COD'),
                                                            ));
                                                          },
                                                          child: Text(
                                                            'CHECK OUT',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white),
                                                          ))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                  if (snapshot.hasError)
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 70.0),
                                        child: Column(
                                          children: [
                                            if (apicalled == false)
                                              Center(
                                                  child: CircularProgressIndicator
                                                      .adaptive()),
                                            if (apicalled == true)
                                              Center(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .remove_shopping_cart_outlined,
                                                        size: 75),
                                                    SizedBox(height: 20),
                                                    Text(
                                                      'Your cart is empty',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25),
                                                    )
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 130),
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child:
                                            CircularProgressIndicator.adaptive()),
                                  );
                                },
                              )
                            
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 70.0),
                                  child: Column(
                                    children: [
                                      if (apicalled == false)
                                        Center(
                                            child: CircularProgressIndicator
                                                .adaptive()),
                                      if (apicalled == true)
                                        Center(
                                          child: Column(
                                            children: [
                                              Icon(
                                                  Icons
                                                      .remove_shopping_cart_outlined,
                                                  size: 75),
                                              SizedBox(height: 20),
                                              Text(
                                                'Your cart is empty',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                      ]),
                ),
              ),
            ),

            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     padding:    const EdgeInsets.symmetric(horizontal: 15.0),
            //     height: 170,
            //     child: Column(
            //       children: [
            //         // Container(
            //         //     decoration: BoxDecoration(
            //         //         color: Colors.white,
            //         //         borderRadius: BorderRadius.only(
            //         //             topLeft: Radius.circular(10),
            //         //             bottomLeft: Radius.circular(10),
            //         //             bottomRight: Radius.circular(30),
            //         //             topRight: Radius.circular(30))),
            //         //     padding: const EdgeInsets.only(left: 20.0),
            //         //     child: TextFormField(
            //         //       decoration: InputDecoration(
            //         //           hintText: 'Enter your promo code',
            //         //           border: InputBorder.none,
            //         //           suffixIcon: CircleAvatar(
            //         //             backgroundColor: Colors.black,
            //         //             child: Icon(
            //         //               Icons.arrow_forward,
            //         //               color: Colors.white,
            //         //             ),
            //         //           )),
            //         //     )),
            //         // SizedBox(height: 25),
            //         // Row(
            //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         //   children: [
            //         //     Text('Total amount:',
            //         //         style: TextStyle(
            //         //           color: Colors.grey,
            //         //           fontSize: 15,
            //         //         )),
            //         //     Row(
            //         //       children: [
            //         //         Text('$price',
            //         //             style: TextStyle(
            //         //                 color: Colors.black,
            //         //                 fontWeight: FontWeight.bold)),
            //         //         Icon(Icons.currency_rupee_outlined, size: 17),
            //         //       ],
            //         //     ),
            //         //   ],
            //         // ),
            //         // SizedBox(height: 20),
            //         Material(
            //           borderRadius: BorderRadius.circular(30),
            //           elevation: 5,
            //           child: Container(
            //               width: MediaQuery.of(context).size.width,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(30),
            //                 // rgba(211, 38, 38, 0.25);
            //                 color: Colors.blue[800],
            //               ),
            //               child: TextButton(
            //                   onPressed: () {
            //                     Navigator.of(context).push(MaterialPageRoute(
            //                       builder: (context) => CheckOut(
            //                           deliverycharges: '150',
            //                           finalprice: '13000',
            //                           paymentmethod: 'COD'),
            //                     ));
            //                   },
            //                   child: Text(
            //                     'CHECK OUT',
            //                     style: TextStyle(color: Colors.white),
            //                   ))),
            //         )
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
