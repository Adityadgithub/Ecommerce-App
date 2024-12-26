import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'All_AddressP.dart';
import 'SplashScreen.dart';

// ignore: must_be_immutable
class AddAddressP extends StatefulWidget {
  AddAddressP({this.isfirstAddress});
  var isfirstAddress;

  @override
  State<AddAddressP> createState() => _AddAddressPState();
}

class _AddAddressPState extends State<AddAddressP> {
  var valuefirst = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  Map datalsit = Map();

  String? nameerror;

  String? addresserror;

  String? cityerror;

  String? ziperror;

  String? stateerror;

  Future<void> AddAddressP(
      full_name, address, city, postcode, state, Default) async {
    try {
      var headers = {
        'x-access-token': '$globalusertoken',
        'Cookie': 'ci_session=d8a218bacd60260e9622b4e8942267929bab1e32'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('http://thenirmanstore.com/v1/account/add_address'));
      request.fields.addAll({
        'full_name': full_name,
        'address': address,
        'city': city,
        'postcode': postcode,
        'state': state,
        'default': Default
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        datalsit = jsonDecode(data);
        if (datalsit['status'] == 1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => All_AddressP()));
        } else {
          CircularProgressIndicator();
        }
        // print(datalsit);
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                            } else if (value.length < 3) {
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
                  if (widget.isfirstAddress != 1) ...[
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.blue.shade800,
                      title: const Text(' Set as default address'),
                      value: this.valuefirst,
                      onChanged: (bool? value) {
                        setState(() {
                          this.valuefirst = value!;
                        });
                      },
                    )
                  ],
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
                                var checkboxValue;
                                if (valuefirst == true) {
                                  checkboxValue = 1;
                                } else {
                                  checkboxValue = 0;
                                }
                                // print(nameController.text.toString());
                                // print(addressController.text.toString());
                                // print(cityController.text.toString());
                                // print(zipController.text.toString());
                                // print(stateController.text.toString());

                                if (nameerror == null &&
                                    addresserror == null &&
                                    cityerror == null &&
                                    ziperror == null &&
                                    stateerror == null) {
                                  AddAddressP(
                                      nameController.text.toString(),
                                      addressController.text.toString(),
                                      cityController.text.toString(),
                                      zipController.text.toString(),
                                      stateController.text.toString(),
                                      checkboxValue.toString());
                                }

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => All_Address()));
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
