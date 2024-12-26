import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'ProfileDetailsP.dart';
import 'SplashScreen.dart';

class EditProfileP extends StatefulWidget {
  EditProfileP(
      {Key? key,
      required this.defaultimage,
      required this.name,
      required this.email})
      : super(key: key);
  var name, email;
  var defaultimage;

  @override
  State<EditProfileP> createState() => _EditProfilePState();
}

class _EditProfilePState extends State<EditProfileP> {
  var _image;
  Map datalist = Map();
  String? newuserEmail;
  String? emailerror;

  final picker = ImagePicker();
  bool numberverified = false;

  String? nameerror;

  String? numbererror;
  Future<void> Edit_Profile(username, email, image) async {
    try {
      var headers = {
        'x-access-token': '$globalusertoken',
        'Cookie': 'ci_session=ae8f008e2d8e73193b335e79b7c6e080253f148c'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://thenirmanstore.com/v1/account/edit_profile'));
      if (_image != null) {
        request.fields.addAll({
          'username': username,
          'email': email,
        });

        request.files
            .add(await http.MultipartFile.fromPath('profile_picture', image));
      } else {
        request.fields.addAll(
            {'username': username, 'email': email, 'profile_picture': image});
      }
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          datalist = jsonDecode(data);
        });
        // print(datalist);
        if (datalist['status'] == 1) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ProfileScreenP()));
        } else {
          CircularProgressIndicator();
        }
        // print(datalist);
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  void initState() {
    nameController.text = widget.name;
    emailController.text = widget.email;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _getImage(ImageSource source) async {
      final pickedFile = await picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          // print('No image selected.');
        }
      });
    }

    void _updateProfile(name, phoneNumber) {
      setState(() {
        widget.name = name;
        widget.email = phoneNumber;
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'PROFILE',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22.5,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: SizedBox(),
          backgroundColor: Color.fromARGB(255, 249, 248, 248),
          elevation: 0.5,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Container(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text('Gallery'),
                                      onTap: () {
                                        _getImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                      onTap: () {
                                        _getImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      foregroundImage: _image == null
                          ? NetworkImage(widget.defaultimage)
                          : FileImage(_image) as ImageProvider

                      //_image==null? FileImage(_image!):AssetImage('assets/images/fb.png')as ImageProvider
                      ,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                nameerror = "Name can't be empty";
                              });
                            } else if (value.length < 3) {
                              setState(() {
                                nameerror = "Too short name";
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
                            labelText: 'Name',
                          ),
                        ),
                      )),
                  if (nameerror != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 10.0),
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
                  SizedBox(height: 10),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (emailController.text.isEmpty) {
                              emailerror = "email can't be empty";
                            }
                            var emailValidator =
                                EmailValidator.validate(value!);
                            if (value == null || value!.isEmpty) {
                              setState(() {
                                emailerror = "Email can't be empty";
                              });
                            } else if (emailValidator != true) {
                              // print(EmailValidator.validate(value!));
                              setState(() {
                                emailerror = "Invalid email address";
                              });
                            }
                          },
                          onChanged: ((value) {
                            setState(() {
                              emailerror = null;
                            });
                          }),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Email Address',
                          ),
                        ),
                      )),
                  if (emailerror != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 10.0),
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
                                      "$emailerror",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
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
                                if (formkey.currentState!.validate()) {
                                  var image;
                                  _image == null
                                      ? image = widget.defaultimage
                                      : image = _image.path;
                                  // print('image - ${widget.defaultimage}');
                                  // print(
                                      // "+++++++++${emailController.text.toString()}    ${nameController.text.toString()}");

                                  // print('emailerror - $emailerror');
                                  // print('nameerror - $nameerror');
                                  if (emailerror == null || nameerror == null) {
                                    Edit_Profile(nameController.text.toString(),
                                        emailController.text.toString(), image);
                                  }
                                }
                              },
                              child: Text(
                                'SAVE',
                                style: TextStyle(color: Colors.white),
                              ))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
