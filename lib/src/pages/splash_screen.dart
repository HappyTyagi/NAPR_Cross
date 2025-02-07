import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../notificationservice/local_notification_service.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../loginscreen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    retrieve();
    // // 1. This method call when app in terminated state and you get a notification
    // // when you click on notification app open from terminated state and you can get notification data in this method
    //
    // FirebaseMessaging.instance.getInitialMessage().then(
    //       (message) {
    //     print("FirebaseMessaging.instance.getInitialMessage");
    //     if (message != null) {
    //       print("New Notification");
    //       // if (message.data['_id'] != null) {
    //       //   Navigator.of(context).push(
    //       //     MaterialPageRoute(
    //       //       builder: (context) => DemoScreen(
    //       //         id: message.data['_id'],
    //       //       ),
    //       //     ),
    //       //   );
    //       // }
    //     }
    //   },
    // );
    //
    // // 2. This method only call when App in forground it mean app must be opened
    // FirebaseMessaging.onMessage.listen(
    //       (message) {
    //     print("FirebaseMessaging.onMessage.listen");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data11 ${message.data}");
    //       LocalNotificationService.createanddisplaynotification(message);
    //
    //     }
    //   },
    // );
    //
    // // 3. This method only call when App in background and not terminated(not closed)
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //       (message) {
    //     print("FirebaseMessaging.onMessageOpenedApp.listen");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data22 ${message.data['_id']}");
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: MyColors.primaryColor,
        // brightness: Brightness.light,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text("V_1325/3.0.25",
                    style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal)),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .7,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/lord_buddha.png"),
                fit: BoxFit.none,
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .1,
            child:  Center(
              child: Text(
                "PET REGISTRATION \n        MOBILE APP",
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
            ),
          ),
        ],
      ),
    );
  }

  retrieve() async {
    var instance = await SharedPreferences.getInstance();
    var TokenNo = instance.getString("TokenNo");
    if (TokenNo != null) {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        ),
      );
    }
  }

  void AnimatedToast(String message) {
    showToast(message,
        context: context,
        textStyle: TextStyle(color: MyColors.white),
        animation: StyledToastAnimation.slideFromTop,
        backgroundColor: MyColors.primaryColor,
        reverseAnimation: StyledToastAnimation.slideFromLeftFade,
        position: StyledToastPosition(align: Alignment.topCenter,offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }
}
