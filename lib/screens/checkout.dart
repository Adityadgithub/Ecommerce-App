import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:nirman_store/screens/AddAddressP.dart';



import 'All_AddressP.dart';
import 'SplashScreen.dart';
import 'cart.dart';


class CheckOut extends StatefulWidget {
  var defaultId;
  var paymentmethod;
  var finalprice;
  var deliverycharges;
  CheckOut(
      {this.defaultId,
      this.paymentmethod,
      this.deliverycharges,
      this.finalprice});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  var delivery_charges = 50;
  var addressData;
  Map addressList = Map();
  Map defaultList = Map();

  bool apicalled = false;
  var cartlist;

  var total_amount;
  var total_quantity;
  var delivery_charge;
  var final_amount;

  var datalength;

  var orderresponse;

  Future AllAddress() async {
    try {
      var headers = {
        'x-access-token':
      '$globalusertoken',
        'Cookie': 'ci_session=bf1a76db3f3961bcb5e2b119abdd1ac1c3ca4825'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/account/address_list'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      addressData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          addressList = jsonDecode(addressData);
          apicalled = true;
        });
        for (int i = 0; i < addressList['data'].length; i++) {}

        return addressList;
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<List> callcheckoutapi() async {
    // print('apicalled');
    var url =
        Uri.parse('http://thenirmanstore.com/v1/cart/get_checkout_details');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    var responce = await http.post(url, body: {}, headers: {
      'x-access-token':
      '$globalusertoken',
    });

    if (responce.statusCode == 200) {
      setState(() {
        apicalled = true;
        cartlist = jsonDecode(responce.body);
        total_quantity = cartlist['total_quantity'];
        total_amount = cartlist['total_amount'];
        delivery_charge = cartlist['delivery_charge'];
        final_amount = cartlist['final_amount'];
      });
    }

    var json = jsonDecode(responce.body);
    // // print(responce.statusCode);
    // print('json msg printed?');
    // print(json['data']);
    // print(json.length);
    try {} catch (e) {}
    cartlist = json['status'];
    //datalength = json['data'].length;
    // print(total_quantity);
    return total_quantity;
  }

  void createorderapi() async {
    // print('apicalled');
    var url = Uri.parse('http://thenirmanstore.com/v1/order/create_order');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    var responce = await http.post(url, body: {
      'delivery_address': '1',
      'payment_method': 'COD',
      'final_price': '$total_amount',
      'delivery_charges': '$delivery_charge'
    }, headers: {
      'x-access-token':
      '$globalusertoken',
    });

    if (responce.statusCode == 200) {
      setState(() {
        apicalled = true;
        orderresponse = jsonDecode(responce.body);
        // print('json msg printed?');
        // print('order message - ${orderresponse['message']}');
        // print('order id - ${orderresponse['order_id']}');
        // print(orderresponse.length);
      });
    }

    // // print(responce.statusCode);

    try {} catch (e) {}
    // data = json['data'];
    // datalength = json['data'].length;
    // // print(prodName);
    // return prodName;
  }

  Future DefaultAddress() async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=b0efde7e2a0a912df810b01a794ac07ed8633eff'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://thenirmanstore.com/v1/account/get_default_address'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        setState(() {
          defaultList = jsonDecode(data);
        });
// if (defaultList['status'] == 1) {
//   Navigator.pushReplacement(context,
//       MaterialPageRoute(builder: (context) {
//         return CheckOut(defaultId: id,);
//       }));
// } else {
//   CircularProgressIndicator();
// }
        // print("dafault list  $defaultList");
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  void getcheckoutdetails() {}

  @override
  void initState() {
    createorderapi();
    callcheckoutapi();
    DefaultAddress();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 234, 234),
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
              color: Colors.black, fontSize: 22.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: SizedBox(),
        backgroundColor: Color.fromARGB(255, 249, 248, 248),
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipping address',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    if (addressList['status'] == 0) ...[
                      apicalled == true
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 20,
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                              onPressed: () {
                                splashColor:
                                Colors.blue.withAlpha(30);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddAddressP()));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.blue.shade800,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Add Address',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blue.shade800,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ]),
                              )
                              // child: Padding(
                              //   padding: const EdgeInsets.all(15),
                              //   child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               'Jane Doe',
                              //               style: TextStyle(
                              //                   color: Colors.black87,
                              //                   fontSize: 15,
                              //                   fontWeight: FontWeight.bold),
                              //             ),
                              //             InkWell(
                              //               onTap: () {
                              //                 Navigator.push(context, MaterialPageRoute(builder: (context) =>AddAddress() ));
                              //               },
                              //               child: Text(
                              //                 'Change',
                              //                 style: TextStyle(
                              //                     color: Colors.red[600],
                              //                     fontSize: 16),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //         SizedBox(height: 10),
                              //         Text('3 Newbridge Court'),
                              //         SizedBox(height: 5),
                              //         Text('Chino Hills, CA 91709, United States'),
                              //       ]),
                              // ),
                              )
                          : Center(child: CircularProgressIndicator()),
                    ] else ...[
                      Material(
                        color: Color.fromARGB(255, 246, 246, 246),
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(),
                            child: defaultList['status'] == 1
                                ? FutureBuilder(
                                    future: AllAddress(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                            height: 70,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      defaultList['data'][0]
                                                          ['first_name'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          All_AddressP()));
                                                        },
                                                        child: Text(
                                                          'Change',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[600],
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  defaultList['data'][0]
                                                          ['address'] +
                                                      " " +
                                                      defaultList['data'][0]
                                                          ['city'] +
                                                      ", " +
                                                      defaultList['data'][0]
                                                          ['state'],
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ));
                                      }
                                      return SizedBox(
                                        height: 40,
                                        width: 10,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  )
                                : FutureBuilder(
                                    future: AllAddress(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                            height: 70,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      addressList['data'][0]
                                                          ['first_name'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          All_AddressP()));
                                                        },
                                                        child: Text(
                                                          'Change',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[600],
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  addressList['data'][0]
                                                          ['address'] +
                                                      " " +
                                                      addressList['data'][0]
                                                          ['city'] +
                                                      ", " +
                                                      addressList['data'][0]
                                                          ['state'],
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ));
                                      }
                                      return SizedBox(
                                        height: 40,
                                        width: 10,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      )
                    ]
                    // Material(
                    //   elevation: 2,
                    //   shadowColor: Colors.black87,
                    //   borderRadius: BorderRadius.circular(10),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(15),
                    //       child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Jane Doe',
                    //                   style: TextStyle(
                    //                       color: Colors.black87,
                    //                       fontSize: 15,
                    //                       fontWeight: FontWeight.bold),
                    //                 ),
                    //                 InkWell(
                    //                   onTap: () {
                    //                     Navigator.pushNamed(
                    //                         context, 'AddAddress');
                    //                   },
                    //                   child: Text(
                    //                     'Change',
                    //                     style: TextStyle(
                    //                         color: Colors.red[600],
                    //                         fontSize: 16),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(height: 10),
                    //             Text('3 Newbridge Court'),
                    //             SizedBox(height: 5),
                    //             Text('Chino Hills, CA 91709, United States'),
                    //           ]),
                    //     ),
                    //   ),
                    // ),
                    ,
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, 'Payment');
                            },
                            child: Text(
                              'Change',
                              style: TextStyle(
                                  color: Colors.red[600], fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    //Payment
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Image(
                              height: 30,
                              image: AssetImage('assets/images/mastercard.png'),
                            ),
                          ),
                        ),
                        SizedBox(width: 25),
                        Text('**** **** **** 3947')
                      ],
                    )
                  ]),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 190,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: final_amount != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Order:',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(
                                  children: [
                                    Text('$total_amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Icon(
                                      Icons.currency_rupee_sharp,
                                      size: 17,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery:',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(
                                  children: [
                                    Text('$delivery_charge',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Icon(
                                      Icons.currency_rupee_sharp,
                                      size: 17,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Summary:',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    )),
                                Row(
                                  children: [
                                    Text('$final_amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Icon(
                                      Icons.currency_rupee_sharp,
                                      size: 17,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Material(
                              borderRadius: BorderRadius.circular(30),
                              elevation: 5,
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    // rgba(211, 38, 38, 0.25);
                                    color: Colors.blue[800],
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        createorderapi();
                                        Navigator.of(context)
                                            .pushNamed('Ordered');
                                      },
                                      child: Text(
                                        'SUBMIT ORDER',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                            )
                          ],
                        )
                      : SizedBox(
                          height: 10,
                          width: 10,
                          child: Center(
                              child: CircularProgressIndicator.adaptive())),
                ),
              ))
        ],
      ),
    );
  }
}
