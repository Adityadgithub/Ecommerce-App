import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'All_AddressP.dart';
import 'SplashScreen.dart';

class UpdateAddress extends StatefulWidget {
  const UpdateAddress(
      {required this.Name,
      required this.Address,
      required this.City,
      required this.state,
      required this.ZipCode,
      required this.Id});
  final String Id, Name, Address, City, state;
  final String ZipCode;

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

Map updatelist = Map();

class _UpdateAddressState extends State<UpdateAddress> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  String? nameerror;

  String? addresserror;

  String? cityerror;

  String? ziperror;

  String? stateerror;

  Future<void> updateAddress(
      address_id, full_name, address, city, postcode, state) async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=7d4832524981a8c354021e32be4b985be19526ea'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/account/update_address'));
      request.fields.addAll({
        'address_id': address_id,
        'full_name': full_name,
        'address': address,
        'city': city,
        'postcode': postcode,
        'state': state
      });

      request.headers.addAll(headers);
      // print('--------------------------------------------');

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        updatelist = jsonDecode(data);
        // print(updatelist);
        if (updatelist['status'] == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => All_AddressP()));
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

  Future<void> addAddress(full_name, address, city, postcode, state) async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=fb47b67462ef5857dde5857303c1f52f7749e928'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/account/add_address'));
      request.fields.addAll({
        'full_name': full_name,
        'address': address,
        'city': city,
        'postcode': postcode,
        'state': state
      });

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

  @override
  void initState() {
    nameController.text = widget.Name;
    addressController.text = widget.Address;
    cityController.text = widget.City;
    stateController.text = widget.state;
    zipController.text = widget.ZipCode.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 238, 238),
      appBar: AppBar(
        title: Text(
          'Add Shipping Address',
          style: TextStyle(
              color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: SizedBox(),
        backgroundColor: Color.fromARGB(255, 249, 248, 248),
        elevation: 0.5,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
                size: 27,
              ))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Form(
                key: formkey,
                child: Column(children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        child: TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.streetAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                nameerror = "Name can't be empty";
                              });
                            } else if (value!.length < 3) {
                              setState(() {
                                nameerror = "Too short address";
                              });
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              nameerror = null;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Full Name',
                          ),
                        ),
                      )),
                  if (nameerror != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      "$nameerror",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        child: TextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                addresserror = "Address can't be empty";
                              });
                            } else if (value!.length < 3) {
                              setState(() {
                                addresserror = "Too short address ";
                              });
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              addresserror = null;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Address',
                          ),
                        ),
                      )),
                  if (addresserror != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      "$addresserror",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        child: TextFormField(
                          controller: cityController,
                          keyboardType: TextInputType.streetAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                cityerror = "City name can't be empty";
                              });
                            } else if (value!.length < 3) {
                              setState(() {
                                cityerror = "Too short city name";
                              });
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              cityerror = null;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'City',
                          ),
                        ),
                      )),
                  if (cityerror != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      "$cityerror",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        child: TextFormField(
                          controller: zipController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                ziperror = "Zip code can't be empty";
                              });
                            } else if (value.length < 6) {
                              setState(() {
                                ziperror = "Please enter valid zip code";
                              });
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              ziperror = null;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Zip Code (Postal Code)',
                          ),
                        ),
                      )),
                  if (ziperror != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      "$ziperror",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        child: TextFormField(
                          controller: stateController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                stateerror = "State name can't be empty";
                              });
                            } else if (value.length < 3) {
                              stateerror = "Too short State name";
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              stateerror = null;
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'State/Province/Region',
                          ),
                        ),
                      )),
                  if (stateerror != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: Text(
                                      "$stateerror",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
                                if (formkey.currentState!.validate()) {}

                                updateAddress(
                                    widget.Id,
                                    nameController.text.toString(),
                                    addressController.text.toString(),
                                    cityController.text.toString(),
                                    zipController.text.toString(),
                                    stateController.text.toString());

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => All_AddressP()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'SAVE ADDRESS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
