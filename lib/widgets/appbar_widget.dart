import 'package:go_wallet/utilis/curved_navbar_utilis.dart';
import 'package:go_wallet/widgets/banner_widget.dart';
import 'package:go_wallet/widgets/big_banner_widget.dart';
import 'package:go_wallet/widgets/bottom_navigation_widget.dart';
import 'package:go_wallet/widgets/drawerHead_widget.dart';
import 'package:go_wallet/widgets/last_section.dart';
import 'package:go_wallet/widgets/more_section_widget.dart';
import 'package:go_wallet/widgets/my_Bkash_widget.dart';
import 'package:go_wallet/widgets/part_one_section.dart';
import 'package:go_wallet/widgets/suggestion.widget.dart';
import 'package:flutter/material.dart';

import '../models/user_session.dart';
import 'offeres_widget.dart';
import 'package:go_wallet/models/balance_manager.dart';
import 'package:go_wallet/widgets/notice_banner.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppBarWidgetState();
}

class AppBarWidgetState extends State<AppBarWidget> {
  final GlobalKey<AppBarWidgetState> appBar_key =
      new GlobalKey<AppBarWidgetState>();
  bool _isAnimation = false;
  bool _isBalanceShown = false;
  bool _isBalance = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: CurvedAppBarShape(),
        toolbarHeight: 70,
        backgroundColor: Colors.blue,
        key: appBar_key,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 12.0, bottom: 4.0),
                  child: FutureBuilder<String>(
                    future: UserSession.getProfileImage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 40,
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(snapshot.data!),
                          onBackgroundImageError: (_, __) =>
                              const Icon(Icons.person, size: 40),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //User Name

                    Row(
                      children: [
                        FutureBuilder<String>(
                          future: UserSession.getName(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? '',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          },
                        ),
                        SizedBox(width: 5),
                        FutureBuilder<String>(
                          future: UserSession.getUserId(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? '',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    //Button
                    InkWell(
                        onTap: animate,
                        child: Container(
                            width: 150,
                            height: 28,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child:
                                Stack(alignment: Alignment.center, children: [
                              //Amount
                              AnimatedOpacity(
                                  opacity: _isBalanceShown ? 1 : 0,
                                  duration: Duration(milliseconds: 500),
                                  child: StreamBuilder<String>(
                                    stream: BalanceManager().balanceStream,
                                    builder: (context, snapshot) {
                                      return Text(
                                        '৳ ${BalanceManager().getFormattedBalance()}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                  )),

                              //Balance
                              AnimatedOpacity(
                                  opacity: _isBalance ? 1 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: const Text('Tap for balance',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800))),

                              //Circle
                              AnimatedPositioned(
                                  duration: const Duration(milliseconds: 1100),
                                  left: _isAnimation == false ? 5 : 130,
                                  curve: Curves.fastOutSlowIn,
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const FittedBox(
                                          child: Text('৳',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17)))))
                            ])))
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 12.0),
            child: InkWell(
              child: SizedBox(
                  width: 34,
                  height: 34,
                  child: Image.asset(
                    'assets/icons/sim.png',
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
      // endDrawer: DrawerWidget(),
      body: ListView(
        children: [
          PartOneHome(),
          SizedBox(height: 9),
          NoticeBanner(),
          SizedBox(height: 9),
          MyBkashWidget(),
          SizedBox(height: 3),

          /*SuggestionWidget(),
          OffersWidget(),
          MoreSectionWidtget(),
          BigBannerWidget(),
          LastSectionWidget(),*/
        ],
      ),
    );
  }

  void animate() async {
    _isAnimation = true;
    _isBalance = false;
    setState(() {});

    await Future.delayed(Duration(milliseconds: 800),
        () => setState(() => _isBalanceShown = true));
    await Future.delayed(
        Duration(seconds: 3), () => setState(() => _isBalanceShown = false));
    await Future.delayed(Duration(milliseconds: 200),
        () => setState(() => _isAnimation = false));
    await Future.delayed(
        Duration(milliseconds: 800), () => setState(() => _isBalance = true));
  }
}
