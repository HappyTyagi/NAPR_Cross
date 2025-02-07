import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Webview.dart';
import '../../api.dart';
import 'RegisterPetDetailsPage.dart';
import 'ServerError.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class VaccinationCenterPage extends StatefulWidget {
  @override
  VaccinationCenterPageState createState() => VaccinationCenterPageState();
}

class VaccinationCenterPageState extends State<VaccinationCenterPage> {
  Widget get _spacer => const SizedBox(height: 12);

  Widget get _spacerwith => const SizedBox(width: 12);

  Widget get _cardSpacer => const SizedBox(height: 4);
  late SharedPreferences prefs;
  var Token;
  late List doctorlist;
  late Map dattt;
  bool loading = false;
  bool loadingdone = false;
  var VefifyStatus;

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  Future retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
      Token = prefs.getString('TokenNo')!;
    });
    DoctorListAPI();
  }

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          elevation: 0.0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: MyColors.whiteColor),
            onPressed: () {
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          title: const Text('Vaccination Center',
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
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.privacy_tip_sharp,color: MyColors.whiteColor),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 10,color: MyColors.whiteColor),
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
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person,color: MyColors.whiteColor),
                    Text('Profile', style: TextStyle(fontSize: 10,color: MyColors.whiteColor)),
                  ],
                ),
              ),
            )
          ],
        ),
        backgroundColor: MyColors.whiteColor,
        body: !loadingdone
            ? CardListSkeleton(
                isCircularImage: true,
                isBottomLinesActive: true,
                length: 5,
              )
            : loading
                ? Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 58.0),
                            child: Container(
                                height: MediaQuery.of(context).size.width,
                                child: Lottie.asset(
                                    'assets/images/data_found.json')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "Not Any Found for vaccination center .",
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        10.0)),
                                color: Colors.blue[50],
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: const [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Pet Owner Important Notes ",style: TextStyle(
                                            fontSize:
                                            14,
                                            color: Colors.red,
                                            fontWeight:
                                            FontWeight
                                                .bold)),
                                      ),
                                      SizedBox(height: 5,),
                                      Text("Pet Owner Can Contact vaccination agency for free vaccination of AntiRabbis and 6in1 vaccination.",style: TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight
                                              .normal)),
                                    ],
                                  ),
                                )),
                          ),
                          Expanded(
                            child: SizedBox(
                                child: ListView.builder(
                                    itemCount: doctorlist.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.all(8.0),
                                          child: Card(
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)
                                              ),
                                              color: Colors.blue[50],
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Text(
                                                                  "Doctor Name",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  doctorlist[
                                                                          index]
                                                                      ["name"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 6,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Hospital Name",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                Text(
                                                                  doctorlist[
                                                                          index]
                                                                      [
                                                                      "hospitalName"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 6,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Mobile",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                Text(
                                                                  doctorlist[
                                                                          index]
                                                                      [
                                                                      "mobile"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 6,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Email Id",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                Text(
                                                                  doctorlist[
                                                                          index]
                                                                      [
                                                                      "emailId"],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  width: _screen
                                                                          .width *
                                                                      0.20,
                                                                  child:
                                                                      const Text(
                                                                    "Address",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: _screen
                                                                          .width *
                                                                      0.60,
                                                                  child: Text(
                                                                    doctorlist[
                                                                            index]
                                                                        [
                                                                        'address'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      );
                                    })),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ));
  }

  void DoctorListAPI() async {
    http.Response response =
        await registrationform('1676006153000', '1676006153000');
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      setState(() {
        if (data["response"].isEmpty) {
          loading = true;
        } else {
          loading = false;
          doctorlist = data['response'];
        }
      });
      await Future.delayed(Duration(seconds: 3), () {
        setState(() {
          loadingdone = true;
        });
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      String Message = "Some error . Please try again?";
      AnimatedToast(Message);
      await Future.delayed(Duration(seconds: 3), () {
        setState(() {
          loadingdone = true;
        });
      });
    }
  }

  Future<http.Response> registrationform(String longitude, String latitude) {
    return http.post(
      Uri.parse(ROOT + AllDoctorList),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(
          <String, String>{'longitude': longitude, 'latitude': latitude}),
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
