import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirman_store/screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/homepage.dart';

class SignupOTPwidgetCHILD extends StatefulWidget {
  var phoneNumber;
  SignupOTPwidgetCHILD({this.phoneNumber});

  @override
  State<SignupOTPwidgetCHILD> createState() => _SignupOTPwidgetCHILDState();
}

class _SignupOTPwidgetCHILDState extends State<SignupOTPwidgetCHILD> {
  bool OTPrequested = false;
  var countryselected = '91';
  bool numberverified = false;
  String? numbererror;

  var otp;
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

  var otperror;

  bool recaptchaverifying = false;

  //COOLDOWN

  bool cooldown = true;
  var maxseconds = 120;

  bool verifyingfailed = false;

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (maxseconds == 0) {
        timer.cancel();
        setState(() {
          cooldown = false;
        });
      } else {
        // setState(() {
        maxseconds--;
        // });
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
    setState(() {
      globalusertoken = key;
    });
  }

  //OTP Error Widget
  Widget showOTPAlert() {
    return Column(
      children: [
        if (otpfieldempty == true)
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
                      "Please enter full OTP",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
          ),
        if (otpfieldempty == false && otperror != null)
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

  Future<void> verifyPhoneNumber() async {
    try {
      var url = Uri.parse('https://thenirmanstore.com/v1/account/login');
      // // print(_googleSignIn.currentUser?.photoUrl.toString());
      var responce = await http.post(url, body: {
        'type': '1',
        'phone': '${widget.phoneNumber}',
      });
      var json = jsonDecode(responce.body);
      // print(json);
      if (json['status'] == 1) {
        numbererror = null;
        setState(() {
          OTPrequested = true;
        });
      } else {
        setState(() {
          numbererror = json['message'];
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  verifyotp() async {
    if (otp1Controller.text.isNotEmpty ||
        otp2Controller.text.isNotEmpty ||
        otp3Controller.text.isNotEmpty ||
        otp4Controller.text.isNotEmpty ||
        otp5Controller.text.isNotEmpty ||
        otp6Controller.text.isNotEmpty) {
      try {
        var url = Uri.parse('https://thenirmanstore.com/v1/account/otp_verify');
        // // print(_googleSignIn.currentUser?.photoUrl.toString());
        var responce = await http.post(url, body: {
          'otp': '$otp',
          'phone': '${widget.phoneNumber}',
        });
        var json = jsonDecode(responce.body);
        // print(json);
        if (json['status'] == 1) {
          _setKey(json['data']['token']);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        } else {
          setState(() {
            otperror = json['message'];
          });
        }
      } catch (e) {
        // print(e);
      }
    } else {
      setState(() {
        otpfieldempty = true;
      });
    }
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Duration duration = Duration(seconds: maxseconds);
    String formattedTime = formatDuration(duration);
    return recaptchaverifying == false
        ? Form(
            key: _formkey,
            child: Column(
              children: [
                if (verifyingfailed == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Verification Failed, please try again later",
                            style: TextStyle(
                                color: Color.fromARGB(255, 7, 15, 22),
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 20),
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'SignUp');
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          'An OTP is sent to your mobile number ${widget.phoneNumber}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: otp1Controller,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      onChanged: (value) {
                                        // print('+$otp+');
                                        setState(() {
                                          otpfieldempty = false;
                                          otperror = null;
                                          otp = '${otp1Controller.text}';
                                          if (value.length >= 1) {
                                            otp1FocusNode.unfocus();
                                            FocusScope.of(context).nextFocus();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: otp2Controller,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      onChanged: (value) {
                                        // print('+$otp+');
                                        setState(() {
                                          otpfieldempty = false;
                                          otperror = null;
                                          otp =
                                              '${otp1Controller.text}${otp2Controller.text}';
                                          if (value.length >= 1) {
                                            otp2FocusNode.unfocus();
                                            FocusScope.of(context).nextFocus();
                                          }
                                          if (value.length < 1) {
                                            otp2FocusNode.unfocus();
                                            FocusScope.of(context)
                                                .previousFocus();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: otp3Controller,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      onChanged: (value) {
                                        otpfieldempty = false;
                                        otperror = null;
                                        // print('+$otp+');
                                        setState(() {
                                          otp =
                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}';
                                          if (value.length >= 1) {
                                            otp3FocusNode.unfocus();
                                            FocusScope.of(context).nextFocus();
                                          }
                                          if (value.length < 1) {
                                            otp3FocusNode.unfocus();
                                            FocusScope.of(context)
                                                .previousFocus();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: otp4Controller,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      onChanged: (value) {
                                        otpfieldempty = false;
                                        otperror = null;
                                        // print('+$otp+');
                                        setState(() {
                                          otp =
                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}';
                                          if (value.length >= 1) {
                                            otp4FocusNode.unfocus();
                                            FocusScope.of(context).nextFocus();
                                          }
                                          if (value.length < 1) {
                                            otp4FocusNode.unfocus();
                                            FocusScope.of(context)
                                                .previousFocus();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: otp5Controller,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      onChanged: (value) {
                                        otpfieldempty = false;
                                        otperror = null;
                                        // print('+$otp+');
                                        setState(() {
                                          otp =
                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}${otp5Controller.text}';

                                          if (value.length >= 1) {
                                            otp5FocusNode.unfocus();
                                            FocusScope.of(context).nextFocus();
                                          }
                                          if (value.length < 1) {
                                            otp5FocusNode.unfocus();
                                            FocusScope.of(context)
                                                .previousFocus();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: otp6Controller,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                      ],
                                      onChanged: (value) {
                                        otpfieldempty = false;
                                        otperror = null;
                                        // print('+$otp+');
                                        setState(() {
                                          otp =
                                              '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}${otp5Controller.text}${otp6Controller.text}';
                                          if (value.length >= 1) {
                                            otp4FocusNode.unfocus();
                                            FocusScope.of(context).unfocus();
                                          }

                                          if (value.length < 1) {
                                            otp5FocusNode.unfocus();
                                            FocusScope.of(context)
                                                .previousFocus();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          labelStyle: TextStyle(fontSize: 15)),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (cooldown == true) Text(formattedTime),
                        SizedBox(width: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Didn't recieved code?",
                                style: TextStyle(
                                    color: cooldown
                                        ? Color.fromARGB(160, 158, 158, 158)
                                        : Colors.black)),
                            TextButton(
                              onPressed: () {
                                if (cooldown == false) {
                                  verifyPhoneNumber();
                                }
                              },
                              child: Text("Send again",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: cooldown
                                          ? Color.fromARGB(134, 33, 149, 243)
                                          : Colors.blue)),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
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
                        verifyotp();
                      }
                      setState(() {});
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
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Verifying you're not a robot,\nhold tight!",
                    style: TextStyle(
                        color: Color.fromARGB(255, 7, 15, 22),
                        fontWeight: FontWeight.bold)),
                SizedBox(width: 25),
                CircularProgressIndicator.adaptive()
              ],
            ),
          );
  }

  bool validator() {
    if (_formkey.currentState!.validate()) {
      return true;
    }
    return false;
  }
}
