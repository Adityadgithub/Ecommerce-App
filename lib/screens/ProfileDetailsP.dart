import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'SplashScreen.dart';
import 'editprofileP.dart';

class ProfileScreenP extends StatefulWidget {
  const ProfileScreenP({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreenP> createState() => _ProfileScreenPState();
}

class _ProfileScreenPState extends State<ProfileScreenP> {
  late String getData;
  Map getList = Map();
  var url = 'https://thenirmanstore.com/';

  bool apicalled = false;
  Future<void> getProfile() async {
    try {
      var headers = {
        'x-access-token':
        '$globalusertoken',
        'Cookie': 'ci_session=dc51f8d959bc6201cd8ebc94d6b71a9e04d3cb65'
      };
      var request = http.MultipartRequest('GET',
          Uri.parse('https://thenirmanstore.com/v1/account/get_profile'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      getData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          getList = jsonDecode(getData);
        });
        apicalled = true;
        // print('apicalled');
        // print(getList);
        // print(getList['data']['profile_picture']);
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
    setState(() {
      
    });
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // if (pickedFile != null) {
    //  File imageFile = File(
    //       pickedFile.path as List<Object>, ArgumentError.notNull().toString());
    // }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // if (pickedFile != null) {
    //   File imageFile = File(
    //       pickedFile.path as List<Object>, ArgumentError.notNull().toString());
    // }
  }

  var _value;
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: getList['status'] == 1
          ? Scaffold(
              appBar: AppBar(
                  title: Text(
                    'PROFILE',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.5,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){}),
                  backgroundColor: Color.fromARGB(255, 249, 248, 248),
                  elevation: 0.5,
                  actions: [
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                      onSelected: (newValue) {
                        if (newValue == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileP(
                                        defaultimage: getList['data']
                                            ['profile_picture'],
                                        name: getList['data']['username'],
                                        email: getList['data']['email'],
                                      )));
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Edit profile"),
                          value: 0,
                        ),
                      ],
                    )
                  ]),
              body: Container(


                child: FutureBuilder(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                child: Text(''),
                                foregroundImage: NetworkImage(
                                    getList['data']['profile_picture']),
                              ),
                              SizedBox(height: 16),
                              Text(
                                getList['data']['username'],
                                style: TextStyle(fontSize: 24),
                              ),
                              SizedBox(height: 8),
                              Text(
                                getList['data']['email'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height*.6165,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)
                            ),

                    // borderRadius: BorderRadius(
                    // topLeft: Radius.circular(60),
                    // topRight: Radius.circular(60)),
                            color: Colors.white),


                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.home),
                                title: Text('Address'),
                                subtitle: Text(getList['data']['city']),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.phone),
                                title: Text(getList['data']['phone']),
                              ),

                            ],
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ),
            )
          : Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.discreteCircle(
                        color: Colors.blue.shade800, size: 80),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Please wait")
                  ],
                ),
              ),
            ),
    );
  }
}
