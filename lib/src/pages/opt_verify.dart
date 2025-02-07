import 'dart:async';
import 'dart:convert';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lottie/lottie.dart';
import '../../src/pages/main_screen.dart';
import '../../thems.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';
import '../../loading.dart';
import '../../loginscreen.dart';
import 'package:http/http.dart' as http;

class PinCodeVerificationScreen extends StatefulWidget {
  String username;
  String phoneNumber;

  PinCodeVerificationScreen(this.username,this.phoneNumber);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;
  TextEditingController textEditingController = TextEditingController();
  late StreamController<ErrorAnimationType> errorController;
  late SharedPreferences prefs;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        ResenrOtp();
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        elevation: 0.0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: MyColors.whiteColor),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        title: const Text('Noida Authority Pet Registration',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 16.0,
                color: MyColors.whiteColor)),
      ),
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          Column(
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height / 4,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("assets/images/mobile_verify.png"),
              //     ),
              //   ),
              // ),
              Lottie.asset('assets/images/reg.json', height: MediaQuery.of(context).size.height /4),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryColor,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, top: 20.0, right: 30.0),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: false,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    errorBorderColor: MyColors.primaryColor,
                    inactiveFillColor:MyColors.primaryColor ,
                    selectedFillColor: MyColors.primaryColor,
                    inactiveColor: MyColors.primaryColor,
                    selectedColor: Colors.black26,
                    activeColor: Colors.black26,
                    activeFillColor: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 40,
                    fieldWidth: 40,
                  ),
                  cursorColor: Colors.white,
                  backgroundColor: Colors.white70,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle: TextStyle(fontSize: 20, height: 1.6,color: Colors.white),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                  boxShadows: const [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.white,
                      blurRadius: 10,
                    )
                  ],
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " RESEND",
                          recognizer: onTapRecognizer,
                          style: const TextStyle(
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: AnimatedButton(
                  height: 40,
                  width: 200,
                  child: Text(
                    ' VERIFY OTP',
                    style: TextStyle(
                      fontSize: 15,
                      color: MyColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  color: MyColors.primaryColor,
                  onPressed: () {
                    if(textEditingController.text.toString().isEmpty){
                      AnimatedToast("Please Enter Valid OTP");
                    }else if(textEditingController.text.toString().length !=6){
                      AnimatedToast("Please Enter Valid OTP");
                    }else{
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            context = context;
                            return Loading("Please wait. We will check the otp ...");
                          },
                        );
                        mainResponse();
                      });
                    }
                  },
                  enabled: true,
                  shadowDegree: ShadowDegree.light,
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void mainResponse() async {
    http.Response response = await VerifyOTP(
        textEditingController.text, widget.phoneNumber);
    print(response.body);
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var TokenNo=data["response"]["tokenNo"];
      var UserName= data["response"]["userName"];
      var CREATERID= data["response"]["cretedId"];
      prefs = await SharedPreferences.getInstance();
      prefs.setString('TokenNo', TokenNo.toString());
      prefs.setString('UserName', UserName.toString());
      prefs.setString('CreaterID', CREATERID.toString());
      prefs.setString('PhoneNumber', widget.phoneNumber);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
            (route) => false,
      );
    } else if (response.statusCode == 400) {
      Navigator.of(context, rootNavigator: true).pop();
      var message=data["response"]["message"];
      AnimatedToast(message);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      String Message = "Please try again?";
      AnimatedToast(Message);
    }
  }

  Future<http.Response> VerifyOTP(String otp, String mobileno) {
    return http.post(
      Uri.parse(ROOT + VERIFYOTP),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'otp': otp, 'mobileNo': mobileno}),
    );
  }


  void ResenrOtp() async {
    http.Response response = await setresendotp(
        widget.username.toString(), widget.phoneNumber.toString());
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      var name = data["response"]["message"];
      String Message = name;
      AnimatedToast(Message);
    } else {
      String Message = "Please try again?";
      AnimatedToast(Message);
    }
  }

  Future<http.Response> setresendotp(String name, String job) {
    return http.post(
      Uri.parse(ROOT + LOGIN),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'mobileNo': job}),
    );
  }

  void AnimatedToast(String message) {
    showToast(message,
        context: context,
        textStyle: TextStyle(color: MyColors.white),
        animation: StyledToastAnimation.slideFromTop,
        backgroundColor: MyColors.primaryColor,
        reverseAnimation: StyledToastAnimation.slideFromLeftFade,
        position: const StyledToastPosition(align: Alignment.topCenter,offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }
}
