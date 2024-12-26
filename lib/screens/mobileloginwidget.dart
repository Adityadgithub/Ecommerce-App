import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'mobileauth.dart';

class MobileLoginWidget extends StatefulWidget {
  var phoneNumber;
   MobileLoginWidget({this.phoneNumber});

  @override
  State<MobileLoginWidget> createState() => _MobileLoginWidgetState();
}

class _MobileLoginWidgetState extends State<MobileLoginWidget> {
  bool OTPrequested = false;
  var countryselected = '91';
  bool numberverified = false;
  String? numbererror;

  var otp;
  var authStatus;

  var _verId;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
  TextEditingController otp5Controller = TextEditingController();
  TextEditingController otp6Controller = TextEditingController();

  FocusNode otp1FocusNode = FocusNode();
  FocusNode otp2FocusNode = FocusNode();
  FocusNode otp3FocusNode = FocusNode();
  FocusNode otp4FocusNode = FocusNode();
  FocusNode otp5FocusNode = FocusNode();
  FocusNode otp6FocusNode = FocusNode();

  bool otpfieldempty = false;

  var otperror = null;

  //COOLDOWN

  bool cooldown = true;
  var maxseconds = 120;

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (maxseconds == 0) {
        timer.cancel();
        setState(() {
          cooldown = false;
        });
      } else {
        setState(() {
          maxseconds--;
        });
      }
    });
    setState(() {});
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  //COOLDOWN

  void _setKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', key);
    // print('set key');
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  //OTP Error Widget
  Widget showOTPAlert() {
    return Column(
      children: [
        if (otperror != null)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.error_outline_outlined, color: Colors.red),
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      "$otperror",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
          ),
      ],
    );
  }

  Widget ShownumberAlert() {
    return Column(
      children: [
        if (numbererror != null)
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.error_outline_outlined, color: Colors.red),
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      "$numbererror",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
          ),
      ],
    );
  }

 

  // verifyotp() async {
  //   if (otp1Controller.text.isNotEmpty ||
  //       otp2Controller.text.isNotEmpty ||
  //       otp3Controller.text.isNotEmpty ||
  //       otp4Controller.text.isNotEmpty ||
  //       otp5Controller.text.isNotEmpty ||
  //       otp6Controller.text.isNotEmpty) {
  //     try {
  //       var url = Uri.parse('https://thenirmanstore.com/v1/account/otp_verify');
  //       // // print(_googleSignIn.currentUser?.photoUrl.toString());
  //       var responce = await http.post(url, body: {
  //         'otp': '$otp',
  //         'phone': '$phoneNumber',
  //       });
  //       var json = jsonDecode(responce.body);
  //       // print('api response : $json');
  //       if (json['status'] == 1) {
  //                 // print('api response : $json');

  //         _setKey(json['data']['token']);
  //         Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => HomePage(),
  //             ));
  //       } else if(json['status'] == 0) {
  //         setState(() {
  //           otperror = json['message'];
  //         });
  //         // print('Error msg - ');
  //         // print(json['message']);
  //       }
  //     } catch (e) {
  //       // print(e);
  //     }
  //   } else {
  //     setState(() {
  //       otpfieldempty = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(seconds: maxseconds);
    String formattedTime = formatDuration(duration);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 242, 242, 242),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 228, 226, 226),
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Login with Mobile Number',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                          ),
                          Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                if (otperror != null)
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                              Icons.error_outline_outlined,
                                              color: Colors.red),
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: Text(
                                              "$otperror",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                      ],
                                    ),
                                  ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MobileLogin(),
                                            ));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.edit_square,
                                            size: 19,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            'Edit number',
                                            style: TextStyle(fontSize: 13),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                          'An OTP is sent to your mobile number ${phoneNumber}'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 5, 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          otp1Controller,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        // print('+$otp+');
                                                        setState(() {
                                                          otpfieldempty = false;
                                                          otperror = null;
                                                          otp =
                                                              '${otp1Controller.text}';
                                                          if (value.length >=
                                                              1) {
                                                            otp1FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          }
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 5, 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          otp2Controller,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        // print('+$otp+');
                                                        setState(() {
                                                          otpfieldempty = false;
                                                          otperror = null;
                                                          otp =
                                                              '${otp1Controller.text}${otp2Controller.text}';
                                                          if (value.length >=
                                                              1) {
                                                            otp2FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          }
                                                          if (value.length <
                                                              1) {
                                                            otp2FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .previousFocus();
                                                          }
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 5, 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          otp3Controller,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        otpfieldempty = false;
                                                        otperror = null;
                                                        // print('+$otp+');
                                                        setState(() {
                                                          otp =
                                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}';
                                                          if (value.length >=
                                                              1) {
                                                            otp3FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          }
                                                          if (value.length <
                                                              1) {
                                                            otp3FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .previousFocus();
                                                          }
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 5, 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          otp4Controller,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        otpfieldempty = false;
                                                        otperror = null;
                                                        // print('+$otp+');
                                                        setState(() {
                                                          otp =
                                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}';
                                                          if (value.length >=
                                                              1) {
                                                            otp4FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          }
                                                          if (value.length <
                                                              1) {
                                                            otp4FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .previousFocus();
                                                          }
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 5, 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          otp5Controller,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        otpfieldempty = false;
                                                        otperror = null;
                                                        // print('+$otp+');
                                                        setState(() {
                                                          otp =
                                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}${otp5Controller.text}';

                                                          if (value.length >=
                                                              1) {
                                                            otp5FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .nextFocus();
                                                          }
                                                          if (value.length <
                                                              1) {
                                                            otp5FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .previousFocus();
                                                          }
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 5, 5),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          otp6Controller,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textAlign:
                                                          TextAlign.center,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            1),
                                                      ],
                                                      onChanged: (value) {
                                                        otpfieldempty = false;
                                                        otperror = null;
                                                        // print('+$otp+');
                                                        setState(() {
                                                          otp =
                                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}${otp5Controller.text}${otp6Controller.text}';
                                                          if (value.length >=
                                                              1) {
                                                            otp4FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                          }

                                                          if (value.length <
                                                              1) {
                                                            otp5FocusNode
                                                                .unfocus();
                                                            FocusScope.of(
                                                                    context)
                                                                .previousFocus();
                                                          }
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                              labelStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          15)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                    showOTPAlert(),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(formattedTime),
                                        SizedBox(width: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Didn't recieved code?",
                                                style: TextStyle(
                                                    color: cooldown
                                                        ? Color.fromARGB(
                                                            160, 158, 158, 158)
                                                        : Colors.black)),
                                            TextButton(
                                              onPressed: () {
                                                if (cooldown == false) {
                                                  // verifyPhoneNumber();
                                                }
                                              },
                                              child: Text("Send again",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: cooldown
                                                          ? Color.fromARGB(
                                                              134, 33, 149, 243)
                                                          : Colors.blue)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                // if (OTPrequested == false || numberverified == true)
                                //   Container(
                                //       decoration: BoxDecoration(
                                //           color: Colors.white,
                                //           borderRadius: BorderRadius.circular(5)),
                                //       child: Padding(
                                //         padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                                //         child: Column(
                                //           children: [
                                //             Row(
                                //               children: [
                                //                 // InkWell(
                                //                 //     onTap: () {
                                //                 //       // showCountryPicker(
                                //                 //       //   context: context,
                                //                 //       //   showPhoneCode:
                                //                 //       //       true, // optional. Shows phone code before the country name.
                                //                 //       //   onSelect: (Country country) {
                                //                 //       //     // print(
                                //                 //       //         'Select country: ${country.displayName}');
                                //                 //       //   },
                                //                 //       // );
                                //                 //       return showCountryPicker(
                                //                 //         context: context,
                                //                 //         //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                //                 //         // exclude: <String>['KN', 'MF'],
                                //                 //         favorite: <String>['IN'],
                                //                 //         //Optional. Shows phone code before the country name.
                                //                 //
                                //                 //         // showWorldWide: false,
                                //                 //         onSelect: (country) {
                                //                 //           setState(() {
                                //                 //             countryselected = country.phoneCode;
                                //                 //           });
                                //                 //           // print(
                                //                 //               'Select country: ${country.displayName}');
                                //                 //         },
                                //                 //         // Optional. Sets the theme for the country list picker.
                                //                 //         countryListTheme: CountryListThemeData(
                                //                 //           // Optional. Sets the border radius for the bottomsheet.
                                //                 //           borderRadius: BorderRadius.only(
                                //                 //             topLeft: Radius.circular(40.0),
                                //                 //             topRight: Radius.circular(40.0),
                                //                 //           ),
                                //                 //           // Optional. Styles the search field.
                                //                 //           inputDecoration: InputDecoration(
                                //                 //             labelText: 'Search',
                                //                 //             hintText: 'Start typing to search',
                                //                 //             prefixIcon:
                                //                 //                 const Icon(Icons.search),
                                //                 //             border: OutlineInputBorder(
                                //                 //               borderSide: BorderSide(
                                //                 //                 color: const Color(0xFF8C98A8)
                                //                 //                     .withOpacity(0.2),
                                //                 //               ),
                                //                 //             ),
                                //                 //           ),
                                //                 //         ),
                                //                 //       );
                                //                 //     },
                                //                 //     child: Row(
                                //                 //       children: [
                                //                 //         Row(
                                //                 //           children: [
                                //                 //             Text('+${countryselected}'),
                                //                 //           ],
                                //                 //         ),
                                //                 //         Icon(Icons.arrow_drop_down_sharp)
                                //                 //       ],
                                //                 //     )),
                                //                 // SizedBox(width: 8),
                                //                 Expanded(
                                //                   child: TextFormField(
                                //                     initialValue: onlynumber,
                                //                     keyboardType: TextInputType.number,
                                //                     inputFormatters: [
                                //                       LengthLimitingTextInputFormatter(10),
                                //                     ],
                                //                     validator: (value) {
                                //                       if (value!.contains(',')) {
                                //                         numbererror =
                                //                             "Invalid input. Please enter numbers only";
                                //                       }
                                //                       if (value.contains('.')) {
                                //                         numbererror =
                                //                             "Invalid input. Please enter numbers only";
                                //                       }
                                //                       if (value.contains('-')) {
                                //                         numbererror =
                                //                             "Invalid input. Please enter numbers only";
                                //                       }
                                //                       if (value.contains(' ')) {
                                //                         numbererror =
                                //                             "Invalid input. Please enter numbers only without any spaces";
                                //                       }
                                //                       if (value.isEmpty) {
                                //                         numbererror = "Field can't be empty";
                                //                       }
                                //                       if (value.length < 10) {
                                //                         numbererror =
                                //                             "Please enter full 10 digit number";
                                //                       }
                                //                     },
                                //                     onChanged: (value) {
                                //                       // print('+$otp+');
                                //                       setState(() {
                                //                         numbererror = null;
                                //                         // _numbererror = null;
                                //                         phoneNumber = '+$countryselected$value';
                                //                         onlynumber = value;
                                //                         // print(phoneNumber);
                                //                       });
                                //                     },
                                //                     decoration: InputDecoration(
                                //                         suffix: numberverified == true
                                //                             ? Icon(
                                //                                 Icons.verified_rounded,
                                //                                 color: Colors.blue,
                                //                               )
                                //                             : SizedBox(),
                                //                         border: InputBorder.none,
                                //                         labelText: 'Enter your mobile number',
                                //                         labelStyle: TextStyle(fontSize: 15)),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //             if (otperror == true)
                                //               Row(
                                //                 children: [],
                                //               )
                                //           ],
                                //         ),
                                //       )),
                                // if (numbererror != null)
                                //   Padding(
                                //     padding: const EdgeInsets.only(top: 10, bottom: 10.0,),
                                //     child: Column(
                                //       children: [
                                //         Container(
                                //           width: MediaQuery.of(context).size.width,
                                //           padding: EdgeInsets.all(0),
                                //           child: Row(
                                //             children: [
                                //               Container(
                                //                   width:
                                //                       MediaQuery.of(context).size.width - 100,
                                //                   child: Text(
                                //                     "$numbererror",
                                //                     style: TextStyle(
                                //                         color: Colors.red, fontSize: 13),
                                //                   )),
                                //             ],
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // SizedBox(height: 20),
                                Center(
                                    child: Container(
                                  width: 190,
                                  decoration: BoxDecoration(
                                      // color: Color.fromARGB(255, 255, 255, 18),
                                      color: Color.fromARGB(255, 0, 105, 192),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                    onPressed: () async {
                                      if (validator()) {
                                        //  verifyotp();
                                      }
                                      setState(() {});
                                      // print(otperror);
                                    },
                                    child: Text(
                                      'Verify OTP',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ])))));
  }

  bool validator() {
    if (_formkey.currentState!.validate()) {
      return true;
    }
    return false;
  }
}
