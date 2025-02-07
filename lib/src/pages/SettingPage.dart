import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import '../../PetPrivacyPolicyPDF.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Webview.dart';
import '../../loginscreen.dart';
import 'CertificateRenewPage.dart';
import 'main_screen.dart';

class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => new SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  late SharedPreferences prefs;
  var UserName = "";
  var PhoneNumber = "";
  var userImage = "";
  DateTime pre_backpress = DateTime.now();

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      UserName = prefs.getString('UserName')!;
      PhoneNumber = prefs.getString('PhoneNumber')!;
      userImage = prefs.getString('userImage')!;
      print(userImage);
    });
  }

  delete() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('TokenNo');
    prefs.remove('userImage');
    prefs.remove('PhoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
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
            elevation: 0.0,
            centerTitle: false,
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios, color: MyColors.whiteColor),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            title: const Text('User Information',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 16.0,
                    color: MyColors.whiteColor)),
            actions: <Widget>[
              InkWell(
                onTap: () {
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
            ],
          ),
          backgroundColor: MyColors.whiteColor,
          body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child:
                                Stack(fit: StackFit.loose, children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "http://petregistration.mynoida.co.in/$userImage"),
                                            fit: BoxFit.cover)),
                                  ),
                                ],
                              ),
                              // Padding(
                              //     padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: const <Widget>[
                              //         CircleAvatar(
                              //           backgroundColor: MyColors.primaryColor,
                              //           radius: 25.0,
                              //           child: Icon(
                              //             Icons.camera_alt,
                              //             color: Colors.white,
                              //           ),
                              //         )
                              //       ],
                              //     )),
                            ]),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffFFFFFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            UserName,
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal),
                          ),
                          Text(
                            PhoneNumber,
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal),
                          ),
                          Divider(
                            color: Colors.black,
                            height: 25,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: _screen.width * 0.50,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: [
                                            Text(
                                              "   What New",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              "        V_1325/3.0.25",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: _screen.width * 0.45,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Version History",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              "10-Jul-2024",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.black26,
                            height: 15,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Provider',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'New Okhla Industrial Development Authority',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.black26,
                            height: 15,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 13.0),
                                      child: Container(
                                        width: _screen.width * 0.50,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "   Language",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: _screen.width * 0.35,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "English",
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: Colors.black26,
                            height: 15,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 13.0),
                                      child: Container(
                                        width: _screen.width * 0.60,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "   Dog Policy",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedButton(
                                      height: 35,
                                      width: _screen.width * 0.30,
                                      child: Text(
                                        'Show',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: MyColors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      color: MyColors.primaryColor,
                                      onPressed: () async {
                                        var pdfurl="http://petregistration.mynoida.co.in/data/noida/dog_policy.pdf";
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PetPrivacyPolicyPDF(pdfurl),
                                          ),
                                        );
                                      },
                                      enabled: true,
                                      shadowDegree: ShadowDegree.light,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: Colors.black26,
                            height: 15,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       child: Row(
                          //         mainAxisAlignment:
                          //         MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Padding(
                          //             padding:
                          //             const EdgeInsets.only(left: 13.0),
                          //             child: Container(
                          //               width: _screen.width * 0.60,
                          //               child: Align(
                          //                 alignment: Alignment.centerLeft,
                          //                 child: Text(
                          //                   "   Dog Certificate",
                          //                   textAlign: TextAlign.left,
                          //                   style: GoogleFonts.lato(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w700,
                          //                       fontStyle: FontStyle.normal),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           AnimatedButton(
                          //             height: 35,
                          //             width: _screen.width * 0.30,
                          //             child: Text(
                          //               'Check',
                          //               style: TextStyle(
                          //                 fontSize: 15,
                          //                 color: MyColors.white,
                          //                 fontWeight: FontWeight.w500,
                          //               ),
                          //             ),
                          //             color: MyColors.primaryColor,
                          //             onPressed: () async {
                          //               Navigator.push(context,
                          //                   MaterialPageRoute(builder: (context) => CertificateRenewPage()));
                          //             },
                          //             enabled: true,
                          //             shadowDegree: ShadowDegree.light,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // const Divider(
                          //   color: Colors.black26,
                          //   height: 15,
                          //   thickness: 2,
                          //   indent: 5,
                          //   endIndent: 5,
                          // ),


                          Padding(
                            padding: const EdgeInsets.only(left: 21.0),
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "CopyRight",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "   New Okhla Industrial Development Authority",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.black26,
                            height: 15,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 21.0),
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Contact for any issues in payment and email ",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Padding(
                          //             padding:
                          //                 const EdgeInsets.only(left: 13.0),
                          //             child: Container(
                          //               width: _screen.width * 0.30,
                          //               child: Align(
                          //                 alignment: Alignment.centerLeft,
                          //                 child: Text(
                          //                   "   Mobile :-",
                          //                   textAlign: TextAlign.left,
                          //                   style: GoogleFonts.lato(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w700,
                          //                       fontStyle: FontStyle.normal),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           Container(
                          //             width: _screen.width * 0.60,
                          //             child: Align(
                          //               alignment: Alignment.centerRight,
                          //               child: Text(
                          //                 "9205691275",
                          //                 textAlign: TextAlign.right,
                          //                 style: GoogleFonts.lato(
                          //                     fontSize: 13,
                          //                     fontWeight: FontWeight.w500,
                          //                     color: Colors.blue,
                          //                     fontStyle: FontStyle.normal),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          //
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(left: 13.0),
                                      child: Container(
                                        width: _screen.width * 0.30,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "   Contact :-",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: _screen.width * 0.60,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Column(
                                          children: [
                                            Text(
                                              "0120-2425025",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              "0120-2425026",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                            Text(
                                              "0120-2425027",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.lato(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blue,
                                                  fontStyle: FontStyle.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 13.0),
                                      child: Container(
                                        width: _screen.width * 0.30,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "   Email Id :-",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: _screen.width * 0.60,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "noida@noidaauthorityonline.com",
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          AnimatedButton(
                            height: 40,
                            child: Text(
                              'LOGOUT',
                              style: TextStyle(
                                fontSize: 15,
                                color: MyColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            color: MyColors.primaryColor,
                            onPressed: () async {
                              delete();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            enabled: true,
                            shadowDegree: ShadowDegree.light,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
