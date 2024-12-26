import 'package:flutter/material.dart';

class MyOrderModel extends StatelessWidget {
  var order_id;
  var order_no;
  var order_date;
  var order_track_status;
  var total_qty;
  var total_amount;
  MyOrderModel(
      {this.order_id,
      this.order_date,
      this.order_no,
      this.order_track_status,
      this.total_amount,
      this.total_qty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Order No - $order_no',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('$order_date',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        )),
                  ],
                ),
                SizedBox(height: 5),
                Divider(),
                SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Quantity:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text('$total_qty',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'Total Amount:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('$total_amount',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('₹',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.grey,
                      onTap: () {
                        Navigator.pushNamed(context, 'OrderDetails');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 17, vertical: 8),
                          child: Text(
                            'Details',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '$order_track_status',
                      style: TextStyle(
                          color: order_track_status == 'Cancelled'
                              ? Colors.red
                              : Colors.green),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
