import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../Webview.dart';
import '../../loginscreen.dart';
import '../../thems.dart';
import 'SettingPage.dart';


class UnderMaintenance extends StatefulWidget {
  String appinfo;
  UnderMaintenance(this.appinfo);

  @override
  State<UnderMaintenance> createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  DateTime pre_backpress = DateTime.now();
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 1);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 1),
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
          title: const Text('App Under Maintenance',
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
            Lottie.asset('assets/images/maintenance_progress.json'),
            Padding(
              padding: EdgeInsets.all(35.0),
              child: Text(widget.appinfo ,style: GoogleFonts.lato(
                  fontSize: 16,
                  letterSpacing: .2,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal)),
            )
          ],
        ),
      ),
    );
  }
}