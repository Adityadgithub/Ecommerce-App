import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/productdetailsP.dart';
import 'categoryprodmodel.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  bool apicalled = false;
  var prodlist;
  List prodId = [];
  List prodName = [];
  List prodPrice = [];
  List prodImage = [];
  List prodRatings = [];

  List productmodelist = [];
  List searchmodelist = [];

  bool opensearchfield = false;
  Map searchList = Map();

  TextEditingController searchController = TextEditingController();

  var searchdata = false;

  var searchLength;

  var searchNameList = [];
  var idNameList = [];

  var controllerData;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<List> callapi() async {
    // print('apicalled');
    var url = Uri.parse('http://thenirmanstore.com/v1/product/products');
    // // print(_googleSignIn.currentUser?.photoUrl.toString());
    var responce = await http.post(url, body: {});
    var json = jsonDecode(responce.body);
    setState(() {
      apicalled = true;
    });
    // print(apicalled);
    // print('json msg printed?');
    // print(json['data']);
    var data = await json['data'];
// Remove this -
   data = [
      {
        "id": "1",
        "product_name": "Dell XPS 13",
        "short_description": "Dell XPS 13 Ultrabook",
        "long_description": "Dell XPS 13 Ultrabook with InfinityEdge display",
        "product_highlights": "Ultra-thin and powerful",
        "discount_percent": "0.00",
        "price": "1200.00",
        "stock": "500",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image": "assets/images/temp/products/prod1.png",
            "catalog_image":
                "assets/images/temp/products/prod1.png",
            "cart_image": "assets/images/temp/products/prod1.png"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "2",
        "product_name": "MacBook Pro",
        "short_description": "Apple MacBook Pro 16-inch",
        "long_description": "Apple MacBook Pro 16-inch with M1 chip",
        "product_highlights": "Powerful performance",
        "discount_percent": "0.00",
        "price": "2500.00",
        "stock": "5000",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image": "assets/images/temp/products/prod2.jpeg",
            "catalog_image":
                "assets/images/temp/products/prod2.jpeg",
            "cart_image": "assets/images/temp/products/prod2.jpeg"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "3",
        "product_name": "HP Spectre x360",
        "short_description": "HP Spectre x360 Convertible",
        "long_description": "HP Spectre x360 Convertible with 4K display",
        "product_highlights": "Versatile and sleek",
        "discount_percent": "0.00",
        "price": "1500.00",
        "stock": "500",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image":
                "assets/images/temp/products/prod3.png",
            "catalog_image":
                "assets/images/temp/products/prod3.png",
            "cart_image": "assets/images/temp/products/prod3.png"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "4",
        "product_name": "Lenovo ThinkPad X1 Carbon",
        "short_description": "Lenovo ThinkPad X1 Carbon",
        "long_description": "Lenovo ThinkPad X1 Carbon Ultrabook",
        "product_highlights": "Durable and lightweight",
        "discount_percent": "0.00",
        "price": "1800.00",
        "stock": "5000",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image":
                "assets/images/temp/products/prod4.jpeg",
            "catalog_image":
                "assets/images/temp/products/prod4.jpeg",
            "cart_image":
                "assets/images/temp/products/prod4.jpeg"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "5",
        "product_name": "Asus ZenBook 14",
        "short_description": "Asus ZenBook 14 Ultrabook",
        "long_description": "Asus ZenBook 14 Ultrabook with NanoEdge display",
        "product_highlights": "Compact and powerful",
        "discount_percent": "0.00",
        "price": "1100.00",
        "stock": "500",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image":
                "assets/images/temp/products/prod5.jpeg",
            "catalog_image":
                "assets/images/temp/products/prod5.jpeg",
            "cart_image": "assets/images/temp/products/prod5.jpeg"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "6",
        "product_name": "Acer Swift 3",
        "short_description": "Acer Swift 3 Notebook",
        "long_description": "Acer Swift 3 Notebook with AMD Ryzen",
        "product_highlights": "Affordable and efficient",
        "discount_percent": "0.00",
        "price": "700.00",
        "stock": "500",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image":
                "assets/images/temp/products/prod6.jpeg",
            "catalog_image":
                "assets/images/temp/products/prod6.jpeg",
            "cart_image": "assets/images/temp/products/prod6.jpeg"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "7",
        "product_name": "Microsoft Surface Laptop 4",
        "short_description": "Microsoft Surface Laptop 4",
        "long_description": "Microsoft Surface Laptop 4 with touch screen",
        "product_highlights": "Elegant and powerful",
        "discount_percent": "0.00",
        "price": "1300.00",
        "stock": "50",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image":
                "assets/images/temp/products/prod7.jpeg",
            "catalog_image":
                "assets/images/temp/products/prod7.jpeg",
            "cart_image":
                "assets/images/temp/products/prod7.jpeg"
          }
        ],
        "product_ratings": 4
      },
      {
        "id": "8",
        "product_name": "Razer Blade 15",
        "short_description": "Razer Blade 15 Gaming Laptop",
        "long_description": "Razer Blade 15 Gaming Laptop with RTX graphics",
        "product_highlights": "High performance gaming",
        "discount_percent": "0.00",
        "price": "2000.00",
        "stock": "500",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image":
                "assets/images/temp/products/prod8.jpg",
            "catalog_image":
                "assets/images/temp/products/prod8.jpg",
            "cart_image": "assets/images/temp/products/prod8.jpg"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "9",
        "product_name": "Google Pixelbook Go",
        "short_description": "Google Pixelbook Go Chromebook",
        "long_description": "Google Pixelbook Go Chromebook with Chrome OS",
        "product_highlights": "Lightweight and portable",
        "discount_percent": "0.00",
        "price": "650.00",
        "stock": "1",
        "min_order_qty": "1",
        "returnable": "1",
        "available": "1",
        "variants": "0",
        "unit": "Piece",
        "product_image": [
          {
            "search_image":
                "assets/images/temp/products/prod9.png",
            "catalog_image":
                "assets/images/temp/products/prod9.png",
            "cart_image":
                "assets/images/temp/products/prod9.png"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "14",
        "product_name": "LG Gram 17",
        "short_description": "LG Gram 17 Ultrabook",
        "long_description": "LG Gram 17 Ultrabook with large display",
        "product_highlights": "Lightweight and large screen",
        "discount_percent": "10.00",
        "price": "1700.00",
        "stock": "0",
        "min_order_qty": "0",
        "returnable": "0",
        "available": "1",
        "variants": "0",
        "unit": null,
        "product_image": [
          {
            "search_image": "assets/images/temp/products/prod1.png",
            "catalog_image":
                "assets/images/temp/products/prod1.png",
            "cart_image": "assets/images/temp/products/prod1.png"
          },
          {
            "search_image": "assets/images/temp/products/prod1.png",
            "catalog_image":
                "assets/images/temp/products/prod1.png",
            "cart_image": "assets/images/temp/products/prod1.png"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "16",
        "product_name": "MSI GS66 Stealth",
        "short_description": "MSI GS66 Stealth Gaming Laptop",
        "long_description": "MSI GS66 Stealth with NVIDIA graphics",
        "product_highlights": "Slim and powerful",
        "discount_percent": "4818.00",
        "price": "4848.00",
        "stock": "1",
        "min_order_qty": "0",
        "returnable": "0",
        "available": "1",
        "variants": "0",
        "unit": null,
        "product_image": [
          {
            "search_image":
                "https://example.com/images/msi_gs66_stealth_search.jpg",
            "catalog_image":
                "https://example.com/images/msi_gs66_stealth_catalog.jpg",
            "cart_image": "https://example.com/images/msi_gs66_stealth_cart.jpg"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "17",
        "product_name": "Alienware m15 R4",
        "short_description": "Alienware m15 R4 Gaming Laptop",
        "long_description": "Alienware m15 R4 with advanced cooling",
        "product_highlights": "High performance gaming",
        "discount_percent": "5686868.00",
        "price": "3000.00",
        "stock": "2",
        "min_order_qty": "0",
        "returnable": "0",
        "available": "1",
        "variants": "0",
        "unit": null,
        "product_image": [
          {
            "search_image":
                "https://example.com/images/alienware_m15_r4_search.jpg",
            "catalog_image":
                "https://example.com/images/alienware_m15_r4_catalog.jpg",
            "cart_image": "https://example.com/images/alienware_m15_r4_cart.jpg"
          }
        ],
        "product_ratings": ""
      },
      {
        "id": "18",
        "product_name": "Huawei MateBook X Pro",
        "short_description": "Huawei MateBook X Pro Ultrabook",
        "long_description": "Huawei MateBook X Pro with FullView display",
        "product_highlights": "Sleek and powerful",
        "discount_percent": "48.00",
        "price": "1200.00",
        "stock": "2",
        "min_order_qty": "0",
        "returnable": "0",
        "available": "1",
        "variants": "0",
        "unit": null,
        "product_image": [
          {
            "search_image":
                "https://example.com/images/huawei_matebook_x_pro_search.jpg",
            "catalog_image":
                "https://example.com/images/huawei_matebook_x_pro_catalog.jpg",
            "cart_image":
                "https://example.com/images/huawei_matebook_x_pro_cart.jpg"
          }
        ],
        "product_ratings": ""
      }
    ];

    var datalength = json['data'].length;
    // print('Datalength $datalength');

    for (int i = 0; i < datalength; i++) {
      prodId.add(data[i]['id']);
      prodName.add(data[i]['product_name']);
      prodImage.add(data[i]['product_image'][0]['search_image']);
      prodPrice.add(data[i]['price']);
      prodRatings.add(data[i]['product_ratings']);

      // // print('x');
    }

    for (int i = 0; i < prodName.length; i++) {
      productmodelist.add(CategoryProductsModel(
        id: prodId[i],
        price: prodPrice[i],
        image: prodImage[i],
        title: prodName[i],
        ratings: 5,
        ratedby: 7,
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

  Future<void> Search(keyword) async {
    try {
      var headers = {
        'Cookie': 'ci_session=b7d35ec4aeb297701d1f65a735a2716a258f5888'
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://thenirmanstore.com/v1/product/products'));
      request.fields.addAll({'keyword': keyword});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var data = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        setState(() {
          searchList = jsonDecode(data);
        });
        if (searchList['status'] == 1) {
          searchdata = true;
          // print(searchList);

          searchLength = searchList['data'].length;
        } else {
          // print(searchList);
          // print(searchdata);
        }
      } else {
        // print(response.reasonPhrase);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  void initState() {
    callapi();
    super.initState();
  }

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            leading: opensearchfield == false
                ? SizedBox()
                : IconButton(
                    onPressed: () {
                      setState(() {
                        opensearchfield = false;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      opensearchfield = true;
                    });
                    controllerData = searchController.text.toString();
                    if (controllerData.isEmpty) {
                      controllerData = false;
                    } else {
                      Search(searchController.text.toString());
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
              )
            ],
            centerTitle: true,
            title: opensearchfield == false
                ? Text(
                    "Products",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                : TextFormField(
                    onFieldSubmitted: (e) {
                      controllerData = searchController.text.toString();
                      if (controllerData.isEmpty) {
                        controllerData = false;
                      } else {
                        Search(searchController.text.toString());
                      }
                    },
                    controller: searchController,
                    enabled: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search")),
            backgroundColor: Color.fromARGB(255, 249, 248, 248),
            elevation: 0,
          ),
          body: FutureBuilder(
            future: callapi(),
            builder: (BuildContext context, snapshot) {
              return searchList.isNotEmpty && opensearchfield == true
                  ? FutureBuilder(
                      future: Search(searchController.text.toString()),
                      builder: (context, snapshot) {
                        return Container(
                            padding: EdgeInsets.only(top: 10),
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: searchList['status'] == 0
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cancel_outlined),
                                        SizedBox(width: 8),
                                        Text(
                                          'No Products Found',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                : FutureBuilder(
                                    future: Search(
                                        searchController.text.toString()),
                                    builder: (context, snapshot) {
                                      return ListView.builder(
                                          itemCount: searchList['data'].length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 249, 248, 248),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProductDetailsP(
                                                                    prodid: searchList[
                                                                            'data']
                                                                        [
                                                                        index]['id'],
                                                                  )));
                                                    },
                                                    child: Flex(
                                                      direction:
                                                          Axis.horizontal,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                            width: 50,
                                                            image: NetworkImage(
                                                              searchList['data']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'product_image'][0]
                                                                  [
                                                                  'search_image'],
                                                            )),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Text(
                                                              searchList['data']
                                                                      [index][
                                                                  'product_name'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade800,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_outlined,
                                                          size: 18,
                                                          color: Colors
                                                              .blue.shade800,
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          });
                                    }));
                      })
                  : Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Column(children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25.0),
                            child: GridView.count(
                              // mainAxisSpacing: 5,
                              childAspectRatio:
                                  MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height / 2),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              children: [...productmodelist],
                            ),
                          ),
                        ),
                      ]));
            },
          )),
    );
  }
}
