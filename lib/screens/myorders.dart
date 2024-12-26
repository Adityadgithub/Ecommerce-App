import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/myordermodel.dart';
import 'SplashScreen.dart';


class MyOrder extends StatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool apicalled = false;
  Map myorderlist = Map();
  var order_id;
  var order_no;
  var order_date;
  var order_track_status;
  var total_amount;
  var total_qty;

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Future<Map> callapi() async {
    // print('apicalled');
    var url = Uri.parse('http://thenirmanstore.com/v1/order/my_orders');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    var responce = await http.post(url, body: {}, headers: {
      'x-access-token':
      '$globalusertoken',
    });
// order - eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6Mzk3LCJpYXQiOjE2Nzc3NzI4NDB9.MsjQ4H2x6wPyqNEzTMqBP-x4cgwNwt_1E4SZ5ZxIYZE
// no order - eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6NDU5LCJpYXQiOjE2Nzg5NjY1NDl9.bmF5bO4QlBMWkbjJ9Xtb4bTk_TQECCnceMTb_mBU9o8

    if (responce.statusCode == 200) {
      // print('running');
      setState(() {
        apicalled = true;
        myorderlist = jsonDecode(responce.body);

        // print('json msg printed?');
        // print(myorderlist['data']);
      });
      // print('still running');
    }
    return myorderlist;
  }

  Widget showDeliveredorders() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        child: myorderlist['status'] != 0
            ? FutureBuilder(
                future: callapi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: myorderlist['data'].length,
                        itemBuilder: (context, index) => myorderlist['data']
                                    [index]['order_track_status'] ==
                                'Delivered'
                            ? MyOrderModel(
                                order_date: myorderlist['data'][index]
                                    ['order_id'],
                                order_id: myorderlist['data'][index]
                                    ['order_id'],
                                order_no: myorderlist['data'][index]
                                    ['order_no'],
                                order_track_status: myorderlist['data'][index]
                                    ['order_track_status'],
                                total_amount: myorderlist['data'][index]
                                    ['total_amount'],
                                total_qty: myorderlist['data'][index]
                                    ['total_qty'],
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.history_sharp, size: 45),
                                      SizedBox(height: 20),
                                      Text(
                                        'Order history not found',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    );
                  }
                  if (snapshot.hasError) return Text('sds');
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Center(child: CircularProgressIndicator()));
                })
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Column(
                    children: [
                      if (apicalled == false)
                        Center(child: CircularProgressIndicator.adaptive()),
                      if (apicalled == true)
                        Center(
                          child: Column(
                            children: [
                              Icon(Icons.history_sharp, size: 55),
                              SizedBox(height: 20),
                              Text(
                                'Order history not found',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  showCancelledorders() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        child: myorderlist['status'] != 0
            ? FutureBuilder(
                future: callapi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: myorderlist['data'].length,
                        itemBuilder: (context, index) => myorderlist['data']
                                    [index]['order_track_status'] ==
                                'Cancelled'
                            ? MyOrderModel(
                                order_date: myorderlist['data'][index]
                                    ['order_id'],
                                order_id: myorderlist['data'][index]
                                    ['order_id'],
                                order_no: myorderlist['data'][index]
                                    ['order_no'],
                                order_track_status: myorderlist['data'][index]
                                    ['order_track_status'],
                                total_amount: myorderlist['data'][index]
                                    ['total_amount'],
                                total_qty: myorderlist['data'][index]
                                    ['total_qty'],
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.history_sharp, size: 45),
                                      SizedBox(height: 20),
                                      Text(
                                        'Order history not found',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    );
                  }
                  if (snapshot.hasError) return Text('sds');
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Center(child: CircularProgressIndicator()));
                })
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Column(
                    children: [
                      if (apicalled == false)
                        Center(child: CircularProgressIndicator.adaptive()),
                      if (apicalled == true)
                        Center(
                          child: Column(
                            children: [
                              Icon(Icons.history_sharp, size: 55),
                              SizedBox(height: 20),
                              Text(
                                'Order history not found',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  showProcessingorders() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: SizedBox(
        child: myorderlist['status'] != 0
            ? FutureBuilder(
                future: callapi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: myorderlist['data'].length,
                        itemBuilder: (context, index) => myorderlist['data']
                                    [index]['order_track_status'] ==
                                'Pending'
                            ? MyOrderModel(
                                order_date: myorderlist['data'][index]
                                    ['order_id'],
                                order_id: myorderlist['data'][index]
                                    ['order_id'],
                                order_no: myorderlist['data'][index]
                                    ['order_no'],
                                order_track_status: myorderlist['data'][index]
                                    ['order_track_status'],
                                total_amount: myorderlist['data'][index]
                                    ['total_amount'],
                                total_qty: myorderlist['data'][index]
                                    ['total_qty'],
                              )
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.history_sharp, size: 45),
                                      SizedBox(height: 20),
                                      Text(
                                        'Order history not found',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    );
                  }
                  if (snapshot.hasError) return Text('sds');
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Center(child: CircularProgressIndicator()));
                })
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 90.0),
                  child: Column(
                    children: [
                      if (apicalled == false)
                        Center(child: CircularProgressIndicator.adaptive()),
                      if (apicalled == true)
                        Center(
                          child: Column(
                            children: [
                              Icon(Icons.history_sharp, size: 55),
                              SizedBox(height: 20),
                              Text(
                                'Order history not found',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  var orderBar = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 241, 241, 241),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon:
                  Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black)),
        ),
        backgroundColor: Color.fromARGB(242, 255, 255, 255),
        key: scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.all(0),
                    child: Text(
                      'My Orders',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              orderBar = 0;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: orderBar == 0
                                      ? Colors.black
                                      : Colors.transparent),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Delivered',
                                  style: TextStyle(
                                      color: orderBar == 0
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              orderBar = 1;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: orderBar == 1
                                      ? Colors.black
                                      : Colors.transparent),
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Processing',
                                    style: TextStyle(
                                        color: orderBar == 1
                                            ? Colors.white
                                            : Colors.black),
                                  ))),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              orderBar = 2;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: orderBar == 2
                                      ? Colors.black
                                      : Colors.transparent),
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Cancelled',
                                    style: TextStyle(
                                        color: orderBar == 2
                                            ? Colors.white
                                            : Colors.black),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  if (orderBar == 0) showDeliveredorders(),
                  if (orderBar == 1) showProcessingorders(),
                  if (orderBar == 2) showCancelledorders(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
