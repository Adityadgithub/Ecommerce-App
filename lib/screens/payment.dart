import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int _groupValue = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 234, 234),
      appBar: AppBar(
        title: Text(
          'Payments',
          style: TextStyle(
              color: Colors.black, fontSize: 22.5, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: SizedBox(),
        backgroundColor: Color.fromARGB(255, 249, 248, 248),
        elevation: 0.5,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
                size: 27,
              ))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Material(
              elevation: 3,
              child: Container(
                height: 370,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('UPI/Wallet', style: TextStyle(fontSize: 17)),
                            SizedBox(width: 10),
                            Image(
                                height: 15,
                                image: AssetImage('assets/images/upi_icon.png'))
                          ],
                        ),
                        Radio(
                          value: 0,
                          groupValue: _groupValue,
                          onChanged: (value) {
                            setState(() {
                              _groupValue = value as int;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Credit / Debit / ATM Card',
                              style: TextStyle(fontSize: 17)),
                          Radio(
                            value: 1,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value as int;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Net Banking', style: TextStyle(fontSize: 17)),
                          Radio(
                            value: 2,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value as int;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cash on Delivery',
                              style: TextStyle(fontSize: 17)),
                          Radio(
                            value: 3,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value as int;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              elevation: 3,
              child: Container(
                color: Colors.white,
                height: 110,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('PRICE DETAILS',
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.currency_rupee_outlined, size: 17.5),
                                Text('19.99',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(30),
                              elevation: 5,
                              child: Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    // rgba(211, 38, 38, 0.25);
                                    color: Colors.blue[800],
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'CONTINUE',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                            )
                          ],
                        )
                      ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
