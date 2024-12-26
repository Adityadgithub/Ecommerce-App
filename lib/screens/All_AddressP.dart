import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'AddAddressP.dart';
import 'SplashScreen.dart';
import 'UpdateAddressP.dart';
import 'checkout.dart';

class All_AddressP extends StatefulWidget {
  @override
  State<All_AddressP> createState() => _All_AddressPState();
}

var addressData;
Map addressList = Map();
String? selectOption = "0";
var groupValue;
Map defaultList = Map();

class _All_AddressPState extends State<All_AddressP> {
  var addressLength;

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
      addressData = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        setState(() {
          addressList = jsonDecode(addressData);
        });
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

  Future DefaultAddress(id) async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=ecc69a7bb1a2faedb50e0f3fe73aeda12d1ae5a7'
      };
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://thenirmanstore.com/v1/account/default_address_set'));
      request.fields.addAll({'address_id': id.toString(), 'default': '1'});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        setState(() {
          defaultList = jsonDecode(data);
        });
        // print(id);
        // print(defaultList);
        if (defaultList['status'] == 1) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return CheckOut(
              defaultId: id,
            );
          }));
        } else {
          CircularProgressIndicator();
        }
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> deleteAddress(address_id) async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=7d4832524981a8c354021e32be4b985be19526ea'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/account/delete_address'));
      request.fields.addAll({'address_id': address_id});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  _handleRadioValueChange(value) {
    setState(() {
      groupValue = value;
    });
    // print(groupValue);
  }

  @override
  void initState() {
    showAllAddress();
    super.initState();
  }

  var i;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: addressList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.discreteCircle(
                      color: Colors.blue.shade800, size: 80),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Please wait ")
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)))),
                            onPressed: () {
                              splashColor:
                              Colors.blue.withAlpha(30);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAddressP()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                            ),
                      ),
                      addressList['status'] != 0
                          ? SingleChildScrollView(
                              child: Column(
                                children: List<Widget>.generate(
                                  addressList['data'].length,
                                  (int i) => ListTile(
                                    title: Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(
                                              255, 246, 246, 246),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FutureBuilder(
                                                future: showAllAddress(),
                                                builder: (context, snapshot) {
                                                  return Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Name: " +
                                                              addressList[
                                                                      'data'][i]
                                                                  [
                                                                  'first_name'] +
                                                              "\n" "Address: " +
                                                              addressList[
                                                                      'data'][i]
                                                                  ['address'] +
                                                              " " +
                                                              addressList[
                                                                      'data'][i]
                                                                  ['city'] +
                                                              ", " +
                                                              addressList[
                                                                      'data'][i]
                                                                  ['postcode'] +
                                                              "\n" +
                                                              addressList[
                                                                      'data'][i]
                                                                  ['state'],
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                            Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: IconButton(
                                                      color:
                                                          Colors.blue.shade800,
                                                      onPressed: () {
                                                        Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            UpdateAddress(
                                                                              Id: addressList['data'][i]['id'],
                                                                              Name: addressList['data'][i]['first_name'],
                                                                              Address: addressList['data'][i]['address'],
                                                                              City: addressList['data'][i]['city'],
                                                                              state: addressList['data'][i]['state'],
                                                                              ZipCode: addressList['data'][i]['postcode'],
                                                                            )));
                                                      },
                                                      icon: Icon(
                                                          Icons.edit_sharp)),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.red,
                                                  child: IconButton(
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            title: new Text(
                                                                'Are you sure?'),
                                                            content: new Text(
                                                                'Do you want to Delete Address'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false), //<-- SEE HERE
                                                                child: new Text(
                                                                    'No'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          true);
                                                                  deleteAddress(
                                                                      addressList['data']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'id']);
                                                                }, // <-- SEE HERE
                                                                child: new Text(
                                                                    'Yes'),
                                                              ),
                                                            ],
                                                          ),
                                                        );

                                                        setState(() {});
                                                      },
                                                      icon: Icon(Icons.delete)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    leading: Radio<int>(
                                      value: int.parse(
                                          addressList['data'][i]['id']),
                                      groupValue: groupValue,
                                      onChanged: _handleRadioValueChange,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child:
                                  Center(child: Text("Please Add an Address"))),
                      SizedBox(
                        height: 70,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
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
                                DefaultAddress(groupValue);
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context){
                                //           return
                                //
                                //   CheckOut(groupValue);
                                //
                                //         }));
                              },
                              child: Text(
                                'SELECT ADDRESS',
                                style: TextStyle(color: Colors.white),
                              ))),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
