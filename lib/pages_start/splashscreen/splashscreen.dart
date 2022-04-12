import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BLBSplashScreen extends StatefulWidget {
  const BLBSplashScreen({ Key? key }) : super(key: key);

  @override
  _BLBSplashScreenState createState() => _BLBSplashScreenState();
}

class _BLBSplashScreenState extends State<BLBSplashScreen> {

  @override
  void initState() {
    Timer(
      const Duration(
        seconds: 3
      ),
      () => Navigator.pushReplacementNamed(context, 'LoginPage')
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).primaryColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset(
                  'assets/iconSignIn.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                SpinKitSpinningLines(
                  color: Theme.of(context).hintColor,
                  size: 110,
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}