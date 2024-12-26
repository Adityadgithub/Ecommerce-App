import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nirman_store/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'All_AddressP.dart';
import 'ProfileDetailsP.dart';
import 'SplashScreen.dart';

class MyProfileP extends StatefulWidget {
  const MyProfileP({super.key});

  @override
  State<MyProfileP> createState() => _MyProfilePState();
}

late String getData;
Map getList = Map();
var url = 'https://thenirmanstore.com/';

class _MyProfilePState extends State<MyProfileP> {
  bool apicalled = false;
  var addressLength;
  var totleAddress;
  var _key;

  Future<void> getProfile() async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=dc51f8d959bc6201cd8ebc94d6b71a9e04d3cb65'
      };
      var request = http.MultipartRequest('GET',
          Uri.parse('https://thenirmanstore.com/v1/account/get_profile'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      getData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          getList = jsonDecode(getData);
        });
        apicalled = true;
        // print(getList);
        // print(url + getList['data']['profile_picture']);
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
    setState(() {
      
    });
  }

  void _deletetoken() async {
    // print('running');
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.remove('token');
    setState(() {
      _key = key;
    });
    // print('YOUR KEY - "$key"');
    // print('key deleted');
  }

  Future<void> showAllAddress() async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=fb47b67462ef5857dde5857303c1f52f7749e928'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/account/address_list'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var addressData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        setState(() {
          addressList = jsonDecode(addressData);
        });

        addressLength = (addressList['data'].length);
        if (addressLength == null) {
          totleAddress = "Please add an addresss";
          // print(totleAddress);
        } else if (addressLength == 1) {
          totleAddress = "$addressLength address";
        } else {
          totleAddress = "$addressLength addresses";
        }
        // print(totleAddress);

        addressLength = addressList['data'].length;
        //// print(addressList['data']);
        //// print(addressList.length);
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  void initState() {
    getProfile();
    showAllAddress();
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
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
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
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'MY PROFILE',
              style: TextStyle(
                  color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: SizedBox(),
            backgroundColor: Color.fromARGB(255, 245, 245, 245),
            elevation: 1,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'My Profile ',
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    // ),

                    FutureBuilder(future: getProfile(),
                      builder: (context, snapshot) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreenP()));
                          },
                          child: getList.isEmpty
                              ? Center(child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ))
                              : Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 38,
                                        backgroundColor: Colors.white,
                                        foregroundImage: NetworkImage(
                                            getList['data']['profile_picture']),
                                      ),
                                      SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          12,
                                          12,
                                          0,
                                          0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getList['data']['username'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              getList['data']['email'],
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'MyOrder');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My orders',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 17),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'view your orders',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'All_Address');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shipping address',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                SizedBox(height: 5),
                                if (totleAddress == null) ...[
                                  Text(
                                    "Please add an address",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ] else
                                  Text(
                                    "$totleAddress",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'Payment');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment methods',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Visa **34',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 40),
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.pushNamed(context, 'Subscription');
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               'Subscription Plans',
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold, fontSize: 17),
                    //             ),
                    //             SizedBox(height: 5),
                    //             Text(
                    //               'check some exciting plans!',
                    //               style: TextStyle(color: Colors.grey),
                    //             ),
                    //           ],
                    //         ),
                    //         Icon(
                    //           Icons.keyboard_arrow_right_rounded,
                    //           color: Colors.grey,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 40),
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.of(context).pushNamed('RefernEarn');
                    //     },
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               'Refer and Earn',
                    //               style: TextStyle(
                    //                   fontWeight: FontWeight.bold, fontSize: 17),
                    //             ),
                    //             SizedBox(height: 5),
                    //             Text(
                    //               'Share the link and earn money!',
                    //               style: TextStyle(color: Colors.grey),
                    //             ),
                    //           ],
                    //         ),
                    //         Icon(
                    //           Icons.keyboard_arrow_right_rounded,
                    //           color: Colors.grey,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Divider(),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,


                      ),

                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Colors.blue.shade800,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'About Us',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.blue.shade800),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 5),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,


                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.contact_page_outlined,
                              color: Colors.blue.shade800,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Contact Us',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.blue.shade800),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,


                      ),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: new Text('Are you sure?'),
                              content: new Text('Do you want to Logout'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(false), //<-- SEE HERE
                                  child: new Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deletetoken();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ));
                                  }, // <-- SEE HERE
                                  child: new Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
