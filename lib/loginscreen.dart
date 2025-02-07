import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:animated_button/animated_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:pets/src/pages/UserAcceptDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../src/pages/opt_verify.dart';
import '../../thems.dart';
import 'package:http/http.dart' as http;
import 'SuperEasyPermissionsMain.dart';
import 'api.dart';
import 'loading.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _filePermission = 'Not Enabled';
  String name = "";
  final usernameController = TextEditingController();
  final mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences prefs;
  String? UserAccept;
  bool checked = false;

  @override
  void initState() {
    super.initState();
    // getToken();
    permisssion();
    retrieve();
  }


  retrieve() async {
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
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, top: 100.0, right: 0.0, bottom: 0.0),
              child: Image.asset(
                "assets/images/noida_logo_white.png",
                height: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "PET REGISTRATION \n          User APP",
                style: TextStyle(
                  fontSize: 22,
                  color: MyColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 20.0, right: 20.0, bottom: 0.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50.0,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: usernameController,
                      textAlign: TextAlign.start,
                      cursorColor: Colors.white,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.zero,
                          hintText: "User Name",
                          hintStyle:
                          const TextStyle(color: Colors.white60),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          prefixIcon: const Icon(
                              Icons.account_box_outlined,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 70.0,
                    child: TextFormField(
                      maxLength: 10,
                      controller: mobileController,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.zero,
                          hintText: "Mobile Number",
                          hintStyle: TextStyle(color: Colors.white60),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          prefixIcon:
                          Icon(Icons.phone, color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  AnimatedButton(
                    height: 40,
                    // child: Text('LOGIN/SIGN UP',
                    child: Text('Continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: MyColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    color: MyColors.white,
                    onPressed: () async {
                      if (usernameController.text.isEmpty) {
                        String Message = "Please Enter User";
                        AnimatedToast(Message);
                      } else if (mobileController.text.isEmpty) {
                        String Message = "Please Enter Your Mobile Number";
                        AnimatedToast(Message);
                      } else if (mobileController.text.length != 10) {
                        String Message = "Please Enter Valid Mobile Number";
                        AnimatedToast(Message);
                      } else {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              context = context;
                              return Loading(
                                  "Please wait. We will send the otp ...");
                            },
                          );
                          mainResponse();
                        });
                      }
                    },
                    enabled: true,
                    shadowDegree: ShadowDegree.light,
                  ),
                ],
              ),
            )
          ],
        ),
    )
    ;
  }

  void AnimatedToast(String message) {
    showToast(message,
        context: context,
        textStyle: TextStyle(color: MyColors.primaryColor),
        animation: StyledToastAnimation.slideFromTop,
        backgroundColor: MyColors.white,
        reverseAnimation: StyledToastAnimation.slideFromLeftFade,
        position: StyledToastPosition(align: Alignment.topCenter,offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }

  void permisssion() async {
    bool result = await SuperEasyPermissionsMain.askPermission(Permissions.camera);
    bool result1 = await SuperEasyPermissionsMain.askPermission(Permissions.mediaLibrary);
    bool result12 = await SuperEasyPermissionsMain.askPermission(Permissions.photos);
    bool result13 = await SuperEasyPermissionsMain.askPermission(Permissions.storage);
    setState(() => _filePermission = 'Granted !');
  }


  void mainResponse() async {
    try {
      http.Response response = await login(
          usernameController.text.toString(), mobileController.text.toString());
      print(response.body);
      var data = jsonDecode(response.body.toString());
      var name = data["response"]["message"];
      String message = name;
      AnimatedToast(message);
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (context) => PinCodeVerificationScreen(
                    usernameController.text.toString(),
                    mobileController.text.toString())));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        AnimatedToast("Some error Please try again?");
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      AnimatedToast("Internal Server Error. Please try again?");
    }
  }

  Future<http.Response> login(String name, String job) {
    return http.post(
      Uri.parse(ROOT + LOGIN),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'mobileNo': job}),
    );
  }

  // void getToken() async{
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //   FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  //   LocalNotificationService.initialize();
  //   await FirebaseMessaging.instance.getToken().then((value){
  //     setState(() {
  //       var TOKENNO= value;
  //       AnimatedToast("TOKENNO"+TOKENNO.toString());
  //       print("TOKENNO"+TOKENNO.toString());
  //     });
  //   });
  // }

  Future<void> backgroundHandler(RemoteMessage message) async {
    print(message.data.toString());
    print(message.notification!.title);
  }
}
