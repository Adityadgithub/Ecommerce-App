import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'categorymodel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map imagelist = Map();

  int currentIndex = 0;

  var totalbanner;
  Future<void> GerBanners() async {
    try {
      var headers = {
        'Cookie': 'ci_session=736d2514b557f8ea78af77bd46bbd2193e853946'
      };
      var request = http.MultipartRequest(
          'GET', Uri.parse('https://thenirmanstore.com/v1/home/banners'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        imagelist = jsonDecode(data);
        totalbanner = imagelist['data'].length;
        // print(imagelist);
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  List prodName = [];
  List prodImage = [];
  List prodId = [];
  List categorymodelist = [];
  Future<List> callapi() async {
    // print('apicalled');
    var url = Uri.parse('https://thenirmanstore.com/v1/home/categories');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    var responce = await http.get(
      url,
    );
    var json = jsonDecode(responce.body);
    // // print(responce.statusCode);
    // print('json msg printed?');
    // print(json['data']);
    // print(json.length);

    var data = json['data'];

    //  Remove this
    data = [
      {
        'name': 'Laptops',
        'image_file':
            'assets/images/temp/categoryLaptop.jpg',
        'id': 9
      },
      {
        'name': 'Equipments',
        'image_file':
            'assets/images/temp/categoryEquip.jpg',
        'id': 11
      },
      {
        'name': 'Services',
        'image_file':
            'assets/images/temp/categoryService.jpg',
        'id': 13
      }
    ];
    var datalength = json.length;

    for (int i = 0; i < datalength; i++) {
      prodName.add(data[i]['name']);
      prodImage.add(data[i]['image_file']);
      prodId.add(data[i]['id']);

      // // print('x');
    }

    for (int i = 0; i < prodName.length; i++) {
      categorymodelist.add(CategoryModel(
        id: prodId[i],
        image: prodImage[i],
        title: prodName[i],
      ));
    }
    // name = data[0]['name'];
    setState(() {});
    // print(prodName);
    // if (json['status'] == 1) {
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => HomePage(),
    //       ));
    // } else {
    //   setState(() {
    //     _error = json['message'];
    //   });
    // }
    return prodName;
  }

  @override
  void initState() {
    callapi();
    // print('object');
    GerBanners();
    super.initState();
  }

  Widget loadingShimmer() => Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.grey[400]!,
        period: const Duration(seconds: 1),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to Exit'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Stack(alignment: Alignment.bottomRight, children: [
            //  imagelist['data']==null?Center(child: CircularProgressIndicator())
            Container(
              child: Align(
                alignment: Alignment.bottomRight,
                child: CarouselSlider.builder(
                  carouselController: carouselController,
                  itemBuilder: (context, index, realIndex) =>
                      imagelist['data'] != null
                          ? Image(
                              image: NetworkImage(
                                  imagelist['data'][index]['bannerimg']),
                              fit: BoxFit.cover,
                            )
                          : loadingShimmer(),

                  // FancyShimmerImage(
                  //     imageUrl: imagelist['data'][index]['bannerimg']),
                  options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      autoPlay: true,
                      aspectRatio: 2,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        currentIndex = index;
                      }),
                  itemCount: totalbanner ??= 0,
                ),
                //
                // Image(
                //     height: 100,
                //     fit: BoxFit.cover,
                //     image: AssetImage('assets/images/postertext.png')),
              ),
            ),
          ]),
          SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  child: Column(children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Categories',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Select a category to view it's products!",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Text(
                        //     'View all',
                        //     style: TextStyle(
                        //         fontSize: 13, fontWeight: FontWeight.bold),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(height: 20),
                    categorymodelist.isNotEmpty
                        ? GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: [...categorymodelist],
                          )
                        : Container(
                            height: 300,
                            child: Center(
                                child: CircularProgressIndicator.adaptive())),
                  ]),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
