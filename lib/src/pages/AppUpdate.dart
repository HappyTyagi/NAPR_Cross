import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../Webview.dart';
import '../../thems.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'SettingPage.dart';


class AppUpdate extends StatefulWidget {
  @override
  State<AppUpdate> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {
  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          elevation: 0.0,
          centerTitle: false,
          title: const Text('App Update Available',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 16.0,
                  color: MyColors.whiteColor)),

          actions: <Widget>[
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Privacy_Policy(),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.privacy_tip_sharp),
                  Text('Privacy Policy',style: TextStyle(fontSize: 10),),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.person),
                    Text('Profile',style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            // Load a Lottie file from your assets
            Lottie.asset('assets/images/appupdate.json'),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("New version is now available",style: TextStyle(fontSize: 20,)),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("with the new version your have access to more feature and resolved the bug.Please click the button below to update your application.",style: TextStyle(fontSize: 15,)),
            ),

            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: AnimatedButton(
                height: 45,
                width: MediaQuery.of(context).size.width* 0.80,
                child: Text(
                  ' Update Application',
                  style: TextStyle(
                    fontSize: 15,
                    color: MyColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: MyColors.primaryColor,
                onPressed: () {
                  if (Platform.isAndroid || Platform.isIOS) {
                    final appId = Platform.isAndroid ? 'com.nmc.pets' : '1597273844';
                    final url = Uri.parse(
                      Platform.isAndroid
                          ? "market://details?id=$appId"
                          : "https://apps.apple.com/in/app/../../-noida-authority-pet-reg/id$appId");
                     launchUrl(url, mode: LaunchMode.externalApplication,
                    );
                  }
                  },
                enabled: true,
                shadowDegree: ShadowDegree.light,
              ),
            ),
          ],
        ),
      ),
    );
  }
}