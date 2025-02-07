import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../loginscreen.dart';
import '../../thems.dart';

class UserAcceptDialog extends StatefulWidget {
  const UserAcceptDialog({super.key});

  @override
  UserAcceptDialogState createState() => UserAcceptDialogState();
}

class UserAcceptDialogState extends State<UserAcceptDialog> {
  bool agree = false;
  late SharedPreferences prefs;
  bool checked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, top: 40, right: 5, bottom: 15),
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, right: 4, bottom: 4),
            child: Dialog.fullscreen(
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Lottie.asset('assets/images/accept_address.json',
                      height: MediaQuery.of(context).size.height / 4),
                  SizedBox(
                    height: 40,
                  ),
                  const Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10, top: 20),
                    child: Text(" This application is specially design , develop and implemented for noida authority users only. The users who have the residence proof in Noida can registered in  this application.\n\n   In case any users outside noida authority registered their PET in the application and made the payment then their payment will not be refund.",
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          color: MyColors.black,
                          letterSpacing: 0,
                          decorationStyle: TextDecorationStyle.wavy,
                          fontStyle: FontStyle.normal),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.10,
                            child: Checkbox(
                              value: checked,
                              activeColor: MyColors.primaryColor,
                              onChanged: (value) {
                                if (value != null) {
                                  checked = value;
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: "I have read and accept",
                                style:
                                    TextStyle(color: Colors.black, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: "  Terms & Conditions",
                                    style: TextStyle(
                                        color: MyColors.primaryColor,
                                        fontSize: 14),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: IconsButton(
                      onPressed: () async => {
                        if (checked)
                          {
                            prefs = await SharedPreferences.getInstance(),
                            prefs.setString('useraccept', 'useraccept'),
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage(),
                              ),
                              (route) => false,
                            ),
                          }
                        else
                          {AnimatedToast("Please read and accept")}
                      },
                      text: 'Accept',
                      iconData: Icons.task_alt,
                      color: MyColors.primaryColor,
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
