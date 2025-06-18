import 'package:go_wallet/pages/SendMoney_Page.dart';
import 'package:go_wallet/pages/inbox_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_wallet/screens/add_money/addmoneyscreen.dart';
import 'package:go_wallet/screens/bank/bank_screen.dart';
import 'package:go_wallet/screens/bkash/bkash_one.dart';
import 'package:go_wallet/screens/history/history_screen.dart';
import 'package:go_wallet/screens/nagad/nagad.dart';
import 'package:go_wallet/screens/report/report_screen.dart';
import 'package:go_wallet/screens/rocket/rocket.dart';
import 'package:go_wallet/screens/upay/upay.dart';

import '../data/home_page_first_part_data.dart';
import '../screens/reffer/reffer.dart';

class PartOneHome extends StatefulWidget {
  const PartOneHome({Key? key}) : super(key: key);

  @override
  State<PartOneHome> createState() => _PartOneHomeState();
}

class _PartOneHomeState extends State<PartOneHome> {
  bool isExpanded = false;

  // See more toggle
  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  // Loading part
  void showLoadingAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return Center(
          child: Center(
            child: Image(image: AssetImage('assets/loading.gif')),
          ),
        );
      },
    );

    // Simulate a short delay before navigating
    Future.delayed(Duration(seconds: 1), () {
      // Hide the loading animation dialog
      Navigator.of(context).pop();

      showCustomSnackbar(context, 'Clicked');

      // Navigate to the next page
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SendMoneyPage()),
      );*/
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight =
        isExpanded ? 380 : 240; // Adjust the heights as needed
    return Container(
      height: containerHeight,
      padding: EdgeInsets.all(0.0), // Add padding for the shadow effect
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                child: GridView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Cannot scroll the GridView section
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigation logic based on the index
                        if (index == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMoneyScreen()),
                          );
                        } else if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReferScreen()),
                          );
                        } else if (index == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BkashOneScreen()),
                          );
                        } else if (index == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NagadOneScreen()),
                          );
                        } else if (index == 4) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RocketOneScreen()),
                          );
                        } else if (index == 5) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpayOneScreen()),
                          );
                        } else if (index == 6) {
                          // Add the screen for 'Bank'
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankTransferScreen()),
                          );
                        } else if (index == 7) {
                          // Add the screen for 'Report'
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReportScreen()),
                          );
                        } /*else if (index == 8) {
                          // Add the screen for 'History'
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HistoryScreen()),
                          );
                        }*/
                      },
                      child: Container(
                        child: menuodel[index],
                      ),
                    );
                  },
                  itemCount: menuodel.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue, // You can customize the color here
      duration:
          Duration(seconds: 3), // Set how long the message will be visible
      behavior:
          SnackBarBehavior.fixed, // Will appear at the bottom of the screen
      shape: RoundedRectangleBorder(
        // Custom shape
        borderRadius: BorderRadius.circular(10),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
