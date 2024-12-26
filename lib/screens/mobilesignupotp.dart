import 'dart:async';


import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:country_picker/country_picker.dart';

import 'SignupOTPwidgetCHILD.dart';

class MobileSignupWidget extends StatefulWidget {
  var phoneNumber;
  MobileSignupWidget({this.phoneNumber});

  @override
  State<MobileSignupWidget> createState() => _MobileSignupWidgetState();
}

class _MobileSignupWidgetState extends State<MobileSignupWidget> {
  var OTPrequested = false;
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
    super.initState();
    startTimer();

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

  bool cooldown = false;
  var maxseconds = 120;
  bool recaptchaverifying = false;

  bool num_already_stored = false;

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
  //COOLDOWN



// 17006
  var countryselected = '91';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 242),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SignupOTPwidgetCHILD(phoneNumber: widget.phoneNumber),
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
