import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nirman_store/screens/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var loginpressed;
  var _error;
  var Email;
  var Password;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? emailerror;
  String? passworderror;
  //Error validation
  bool validator() {
    if (formkey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  void _setKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', key);
    // print('set key');
    setState(() {
    globalusertoken = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 228, 226, 226),
        elevation: 0,

      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8),
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    SizedBox(height: 100),
                    Center(
                      child: Form(
                        key: formkey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //error display (if any)
                            showAlert(),

                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value!.isEmpty) {
                                        setState(() {
                                          emailerror = "Email can't be empty";
                                        });
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        emailerror = null;
                                        _error = null;
                                        Email = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Email',
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 10),
                            if (emailerror != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: Text(
                                                "$emailerror",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value!.isEmpty) {
                                        setState(() {
                                          passworderror =
                                              "Password can't be empty";
                                        });
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        passworderror = null;
                                        Password = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Password',
                                    ),
                                  ),
                                )),
                            if (passworderror != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 3, bottom: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        children: [
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: Text(
                                                "$passworderror",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 13),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('ForgotPass');
                                  },
                                  child: const Text('Forget your password?')),
                            ),
                            // rgba(250,254,1,255)
                            Center(
                                child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  // color: Color.fromARGB(255, 255, 255, 18),
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {}
                                  var url = Uri.parse(
                                      'https://thenirmanstore.com/v1/account/login');
                                  // // print(_googleSignIn.currentUser?.photoUrl.toString());
                                  var responce = await http.post(url, body: {
                                    'type': '2',
                                    'email': '$Email',
                                    'password': '$Password'
                                  });
                                  var json = jsonDecode(responce.body);
                                  // // print(responce.statusCode);
                                  // print(json['message']);
                                  if (json['status'] == 1) {
                                    _setKey(json['data']['token']);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ));
                                  } else {
                                    setState(() {
                                      _error = json['message'];
                                    });
                                  }
                                },
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: Material(
                                borderRadius: BorderRadius.circular(30),
                                elevation: 2,
                                child: Container(
                                    height: 43,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // rgba(211, 38, 38, 0.25);
                                      color: Colors.blue[800],
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('MobileLogin');
                                        },
                                        child: Text(
                                          'Use Mobile Number',
                                          style: TextStyle(color: Colors.white),
                                        ))),
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, 'SignUp');
                                },
                                child: Text('Create a new account'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 20.0),
                    //   child: Column(
                    //     children: [
                    //       Center(child: Text('Or login with social account')),
                    //       SizedBox(height: 10),
                    //       Center(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             TextButton(
                    //               onPressed: () async {
                    //                 var _user;
                    //                 final googleUser =
                    //                     await GoogleSignIn().signIn();
                    //                 if (googleUser == null) return;
                    //                 _user = googleUser;
                    //                 final googleAuth =
                    //                     await googleUser.authentication;

                    //                 final credential =
                    //                     GoogleAuthProvider.credential(
                    //                         accessToken: googleAuth.accessToken,
                    //                         idToken: googleAuth.idToken);
                    //                 await FirebaseAuth.instance
                    //                     .signInWithCredential(credential);
                    //                 setState(() {});
                    //               },
                    //               child: const Image(
                    //                   height: 27,
                    //                   image: AssetImage(
                    //                       'assets/images/google.png')),
                    //             ),
                    //             TextButton(
                    //               onPressed: () {},
                    //               child: const Image(
                    //                   height: 27,
                    //                   image:
                    //                       AssetImage('assets/images/fb.png')),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ]),
            ),
          )),
    );
  }

  //Error Showing Widget
  Widget showAlert() {
    if (_error != null && emailerror == null && passworderror == null) {
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
