import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Webview.dart';
import '../../api.dart';
import 'AppUpdate.dart';
import 'GridDashboard.dart';
import 'package:http/http.dart' as http;
import 'ServerError.dart';
import 'SettingPage.dart';
import 'UnderMaintenance.dart';
import 'UserAcceptDialog.dart';
import 'isNeuteringDialog.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var TokenNumber = "";
  String? Accept;
  var UserName = "";
  late SharedPreferences prefs;
  DateTime pre_backpress = DateTime.now();
  String? UserAccept;

  @override
  void initState() {
    super.initState();
    // retrieve();
    useracceptpopup();
  }


  useracceptpopup() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      UserAccept = prefs.getString('useraccept');
      if (UserAccept == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserAcceptDialog(),
          ),
        );
        return;
      }else{
        retrieve();
      }
    });
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      UserName = prefs.getString('UserName')!;
      TokenNumber = prefs.getString('TokenNo')!;
      Accept = prefs.getString('accept');
      mainResponse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
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
            title: const Text(
              "NAPR",
              style: TextStyle(fontSize: 20,color: MyColors.white),
            ),
            elevation: 0.5,
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Privacy_Policy(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    const Icon(Icons.privacy_tip_sharp, color: MyColors.whiteColor),
                    Text(
                      'Privacy Policy',
                      style: GoogleFonts.lato(
                        fontSize: 10,
                        color: MyColors.whiteColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () {
                    //delete();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingPage(),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      const Icon(Icons.person, color: MyColors.whiteColor),
                      Text(
                        'Profile',
                        style: GoogleFonts.lato(
                            fontSize: 10,
                            color: MyColors.whiteColor,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade50,
          body: Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(
                          "Hi ,",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          UserName,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/logo_new.png',
                  width: 150,
                ),
                Text(
                  "नोएडा अथॉरिटी",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GridDashboard()
              ],
            ),
          )),
    );
  }

  delete() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('TokenNo');
    // TokenNumber = "";
    // setState((){});
  }

  void mainResponse() async {
    try {
      http.Response response = await AppInfo();
      print(response.body);
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        var androidMobileVersion = int.parse(data['response']['androidMobileVersion']);
        var andServerMaintains = data['response']['andServerMaintains'];
        var neutering = data['response']['neutering'];
        var userImage = data['response']['userImage'];
        var ioServerMaintains = data['response']['ioServerMaintains'];
        var iosMobileVersion = int.parse(data['response']['iosMobileVersion']);
        var msg = data['response']['msg'];
        prefs.setString('userImage', userImage.toString());

        if (Platform.isAndroid) {
          if (andServerMaintains == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UnderMaintenance(msg.toString()),
              ),
            );
            return;
          }
          if (androidMobileVersion > 1325) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AppUpdate(),
              ),
            );
            return;
          }
        } else if (Platform.isIOS) {
          if (ioServerMaintains == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UnderMaintenance(msg.toString()),
              ),
            );
            return;
          }
          if (iosMobileVersion > 1323) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AppUpdate(),
              ),
            );
            return;
          }
        }
        if (neutering == true) {
          if (Accept == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IsNuteringDialog(),
              ),
            );
            return;
          }
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ServerError(),
          ),
        );
      }
    } catch (exception) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ServerError(),
        ),
      );
    }
  }

  Future<http.Response> AppInfo() {
    return http.get(
      Uri.parse(ROOT + AppInfoAPI),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': TokenNumber,
      },
    );
  }

  void AnimatedToast(String message) {
    showToast(message,
        context: context,
        textStyle: TextStyle(color: MyColors.white),
        animation: StyledToastAnimation.slideFromTop,
        backgroundColor: MyColors.primaryColor,
        reverseAnimation: StyledToastAnimation.slideFromLeftFade,
        position: StyledToastPosition(align: Alignment.topCenter, offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }
}
