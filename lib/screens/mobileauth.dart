import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:country_picker/country_picker.dart';

import 'mobileloginwidget.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

var onlynumber;
var phoneNumber;
class _MobileLoginState extends State<MobileLogin> {

  var _error;


  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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

  String? numbererror;
  var otperror;

  @override
  void initState() {
    // startTimer();
    super.initState();


    otp1FocusNode = FocusNode();
    otp2FocusNode = FocusNode();
  }

  @override
  void dispose() {
    otp1FocusNode.dispose();
    otp2FocusNode.dispose();
    otp1Controller.dispose();
    otp2Controller.dispose();
    super.dispose();
  }

  String? authStatus;
  //Error validation
  bool validator() {
    if (formkey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  var _verId;

  String otp = "";

  //COOLDOWN
  //
  // bool cooldown = true;
  // var maxseconds = 120;
  // bool recaptchaverifying = false;
  //
  // bool num_already_stored = false;
  //
  // void startTimer() {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     if (maxseconds == 0) {
  //       timer.cancel();
  //       setState(() {
  //         cooldown = false;
  //       });
  //     } else {
  //       setState(() {
  //         maxseconds--;
  //       });
  //     }
  //   });
  // }
  //
  // String formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "$twoDigitMinutes:$twoDigitSeconds";
  // }
  // //COOLDOWN


  Future<void> verifyPhoneNumber() async {
    try {
      var url = Uri.parse('https://thenirmanstore.com/v1/account/login');
      // // print(_googleSignIn.currentUser?.photoUrl.toString());
      var responce = await http.post(url, body: {
        'type': '1',
        'phone': '$phoneNumber',
      });
      var json = jsonDecode(responce.body);
      // print(json);
      if (json['status'] == 1) {
        numbererror = null;

      } else {
        setState(() {
          numbererror = json['message'];
        });
      }
    } catch (e) {
      // print(e);
    }
  }




// 17006
  var countryselected = '91';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 228, 226, 226),
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            // await auth.currentUser!.delete();

            _error = null;
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
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
                      'Login with Mobile Nddumber',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 23),
                    ),

                     Form(key: formkey,
                      child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [

                                          Expanded(
                                            child: TextFormField(
                                              initialValue: onlynumber,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(10),
                                              ],
                                              validator: (value) {
                                                if (value!.contains(',')) {
                                                  numbererror =
                                                  "Invalid input. Please enter numbers only";
                                                }
                                                if (value.contains('.')) {
                                                  numbererror =
                                                  "Invalid input. Please enter numbers only";
                                                }
                                                if (value.contains('-')) {
                                                  numbererror =
                                                  "Invalid input. Please enter numbers only";
                                                }
                                                if (value.contains(' ')) {
                                                  numbererror =
                                                  "Invalid input. Please enter numbers only without any spaces";
                                                }
                                                if (value.isEmpty) {
                                                  numbererror = "Field can't be empty";
                                                }
                                                if (value.length < 10) {
                                                  numbererror =
                                                  "Please enter full 10 digit number";
                                                }
                                              },
                                              onChanged: (value) {
                                                // print('+$otp+');
                                                setState(() {
                                                  numbererror = null;
                                                  // _numbererror = null;
                                                  phoneNumber = '+$countryselected$value';
                                                  onlynumber = value;
                                                  // print(phoneNumber);
                                                });
                                              },
                                              decoration: InputDecoration(

                                                  border: InputBorder.none,
                                                  labelText: 'Enter your mobile number',
                                                  labelStyle: TextStyle(fontSize: 15)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (otperror == true)
                                        Row(
                                          children: [],
                                        )
                                    ],
                                  ),
                                )),
                            if (numbererror != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10.0,),
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
                                                "$numbererror",
                                                style: TextStyle(
                                                    color: Colors.red, fontSize: 13),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
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

                                        await verifyPhoneNumber();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MobileLoginWidget(),));


                                      }
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Get OTP' ,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),                    SizedBox(height: 15),

                          ],
                        ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: [
                          // Center(
                          //     child:
                          //         Text('Or MobileLogin with social account')),
                          // SizedBox(height: 10),
                          // Center(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       TextButton(
                          //         onPressed: () async {
                          //           // var _user;
                          //           // final googleUser =
                          //           //     await GoogleSignIn().signIn();
                          //           // if (googleUser == null) return;
                          //           // _user = googleUser;
                          //           // final googleAuth =
                          //           //     await googleUser.authentication;
                          //           //
                          //           // final credential =
                          //           //     GoogleAuthProvider.credential(
                          //           //         accessToken: googleAuth.accessToken,
                          //           //         idToken: googleAuth.idToken);
                          //           // await FirebaseAuth.instance
                          //           //     .signInWithCredential(credential);
                          //           // setState(() {});
                          //         },
                          //         child: const Image(
                          //             height: 27,
                          //             image: AssetImage(
                          //                 'assets/images/google.png')),
                          //       ),
                          //
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ]),
            ),
          )),
    );
  }

  //OTP Error Widget
  Widget showOTPAlert() {
    return otpfieldempty == true
        ? Container(
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
          )
        : SizedBox();
  }

  //Error Showing Widget
  Widget showAlert() {
    if (_error != null) {
      return Container(
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
                  "$_error",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
