import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../Webview.dart';
import '../../thems.dart';
import 'SettingPage.dart';
import 'main_screen.dart';

class ServerError extends StatefulWidget {
  @override
  State<ServerError> createState() => _ServerErrorState();
}

class _ServerErrorState extends State<ServerError> {
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
      child:  Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          elevation: 0.0,
          centerTitle: false,
          title: const Text('Server Error Page',
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
                  Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 10),
                  ),
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
                    Text('Profile', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            )
          ],
        ),
        body: ListView(
          children: [
            // Load a Lottie file from your assets
            Lottie.asset('assets/images/error.json'),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Oops!",
                  style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Something went wrong!. Please check your app is updated or not PlayStore/AppStore",
                  style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Please try again!",
                  style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: AnimatedButton(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Text(
                    ' Try Again',
                    style: TextStyle(
                      fontSize: 15,
                      color: MyColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  color: MyColors.primaryColor,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(),
                      ),
                          (route) => false,
                    );
                  },
                  enabled: true,
                  shadowDegree: ShadowDegree.light,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
