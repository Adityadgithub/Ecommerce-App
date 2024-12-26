import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key, required this.number}) : super(key: key);
  final String number;

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

var otperror;

// Future<void> VerifyOtp(
//
//   String otp,
//     String number,
// ) async {
//   try {
//     var headers = {
//       'Cookie': 'ci_session=ee3f94e6a37c42ab6636820c8cc8dd071c09696c'
//     };
//     var request = http.MultipartRequest('POST', Uri.parse('https://thenirmanstore.com/v1/account/otp_verify'));
//     request.fields.addAll({
//       'otp': otp,
//       'phone': number
//     });
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       // print(await response.stream.bytesToString());
//
//     }
//     else {
//
//       // print(response.reasonPhrase);
//       otperror = response.reasonPhrase;
//     }
//
//   } catch (e) {
//
//     // print(e.toString());
//   }
// }

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
// TextEditingController OtpController = TextEditingController();

class _VerifyOTPState extends State<VerifyOTP> {
  String? otp;

  var otpfieldempty;

  String? formattedTime;

  var _error;

  @override
  Widget build(BuildContext context) {
    void _setKey(String key) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', key);
      // print('set key');
    }

    Future<void> VerifyOtp(
      String otp,
      String number,
    ) async {
      try {
        var url = Uri.parse('https://thenirmanstore.com/v1/account/otp_verify');
        // // print(_googleSignIn.currentUser?.photoUrl.toString());
        var responce =
            await http.post(url, body: {'otp': otp, 'phone': number});  
        var json = jsonDecode(responce.body);
        // // print(responce.statusCode);
        // print(json['message']);
        // print(json['data']['token']);
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
        // print(e.toString());
      }
    }

    bool cooldown = false;
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
          setState(() {
            maxseconds--;
          });
        }
      });
    }

    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

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
                    child:
                        Icon(Icons.error_outline_outlined, color: Colors.red),
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
                    child:
                        Icon(Icons.error_outline_outlined, color: Colors.red),
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

    Duration duration = Duration(seconds: maxseconds);
    String formattedTime = formatDuration(duration);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showOTPAlert(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        'An OTP is sent to your mobile number ${widget.number}'),
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
                                        if (value.length < 1) {
                                          otp1FocusNode.unfocus();
                                          FocusScope.of(context)
                                              .previousFocus();
                                        }
                                      });
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
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

                  // SizedBox(height: 5),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     if (cooldown == true) Text(formattedTime),
                  //     SizedBox(width: 8),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text("Didn't recieved code?",
                  //             style: TextStyle(
                  //                 color: cooldown
                  //                     ? Color.fromARGB(160, 158, 158, 158)
                  //                     : Colors.black)),
                  //         TextButton(
                  //           onPressed: () {
                  //             if (cooldown == false) {
                  //               verifyPhoneNumber(context);
                  //             }
                  //           },
                  //           child: Text("Send again",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: cooldown
                  //                       ? Color.fromARGB(134, 33, 149, 243)
                  //                       : Colors.blue)),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // color: Color.fromARGB(255, 255, 255, 18),

                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  onPressed: () {
                    otp =
                        '${otp1Controller.text}${otp2Controller.text}${otp3Controller.text}${otp4Controller.text}${otp5Controller.text}${otp6Controller.text}';

                    VerifyOtp(
                      otp.toString(),
                      widget.number,
                    );
                    // print(widget.number);
                  },
                  child: Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
