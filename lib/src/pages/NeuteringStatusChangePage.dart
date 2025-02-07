import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import '../../DetailScreen.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Webview.dart';
import '../../api.dart';
import '../../loading.dart';
import 'ServerError.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class NeuteringStatusChangePage extends StatefulWidget {
  var formId = "";

  NeuteringStatusChangePage(this.formId);

  @override
  NeuteringStatusChangePageState createState() =>
      NeuteringStatusChangePageState();
}

class NeuteringStatusChangePageState extends State<NeuteringStatusChangePage> {
  var Token = "";
  var neuteringdata;

  late SharedPreferences prefs;
  late Map dattt;
  late Map neutering;
  bool loading = false;
  String IsNeuteringValue = "";
  final IsNeuteringHorizontal = ["YES", "NO"];
  var isNeutering = "";

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Token = prefs.getString('TokenNo')!;
      GetUserData();
    });
  }

  void showdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        context = context;
        return Loading("Please wait ...");
      },
    );
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
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          title: Text('Update Neutering Status',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal)),
          // actions: <Widget>[
          //   InkWell(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const Privacy_Policy(),
          //         ),
          //       );
          //     },
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(Icons.privacy_tip_sharp),
          //         Text('Privacy Policy',
          //             style: GoogleFonts.lato(
          //                 fontSize: 10,
          //                 fontWeight: FontWeight.w700,
          //                 fontStyle: FontStyle.normal)),
          //       ],
          //     ),
          //   ),
          //   const SizedBox(
          //     width: 16,
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.only(right: 10),
          //     child: InkWell(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => SettingPage(),
          //           ),
          //         );
          //       },
          //       child: Column(
          //         children: const [
          //           Icon(Icons.person, color: MyColors.whiteColor),
          //           Text(
          //             'Profile',
          //             style: TextStyle(
          //                 fontSize: 10, fontFamily: AutofillHints.addressState),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ],
        ),
        backgroundColor: MyColors.whiteColor,
        body: !loading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 5),
                        Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: Colors.blue[50],
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Owner Name",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        neuteringdata['ownerName'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Owner Number",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        neuteringdata['ownerNumber'],
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Pet Name",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        neuteringdata['nickName'],
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Breed Name",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        neuteringdata['breedName'],
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Pet Age",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        neuteringdata['dob'],
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Registration Date ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd-MMM-yyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                neuteringdata['createdOn'])),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    margin: const EdgeInsets.only(top: 18.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Pet's Photos",
                                            style: GoogleFonts.lato(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_dog1_url'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_dog1_url']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text("Pet Photo1",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_dog2_url'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_dog2_url']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text("Pet With Owner",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_dog3_url'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_dog3_url']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text("Pet Photo2",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_valid_book'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_valid_book']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Vaccination",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_id_url'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_id_url']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text("Upload Photo ID",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_photo_url'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_photo_url']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text("Owner Photo",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_sign_url'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_sign_url']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Signature",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                var imageurl = neuteringdata["mainDocFormResponse"]['upload_id_proof'];
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailScreen(imageurl)));
                                              },
                                              child: Card(
                                                elevation: 10,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      shape: BoxShape.rectangle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "http://petregistration.mynoida.co.in/${neuteringdata["mainDocFormResponse"]['upload_id_proof']}"),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text("Address Proof",
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FontStyle.normal))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 10),
                                        child: Text("Neutering Status",
                                            style: GoogleFonts.lato(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal)),
                                      ),
                                      RadioGroup<String>.builder(
                                        direction: Axis.horizontal,
                                        groupValue: IsNeuteringValue,
                                        horizontalAlignment:
                                            MainAxisAlignment.spaceAround,
                                        onChanged: (value) => setState(() {
                                          IsNeuteringValue = value ?? '';
                                          IsNeuteringValue == "YES"
                                              ? isNeutering = "1"
                                              : IsNeuteringValue == "NO"
                                                  ? isNeutering = "0"
                                                  : isNeutering == "";
                                        }),
                                        items: IsNeuteringHorizontal,
                                        fillColor: MyColors.primaryColor,
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                        itemBuilder: (item) =>
                                            RadioButtonBuilder(
                                          item,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 40,
                            child: AnimatedButton(
                              width: MediaQuery.of(context).size.width * 0.60,
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                              buttonTextStyle: TextStyle(),
                              pressEvent: () async {
                                if (isNeutering.isEmpty) {
                                  AnimatedToast(
                                      "Please Select Neutering Status");
                                } else {
                                  showdialog(context);
                                  UpdateNeutring();
                                }
                              },
                              text: 'UPDATE',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ]),
                ),
              ));
  }

  void GetUserData() async {
    try {
      http.Response response = await getuserdata();
      print(response.body);
      if (response.statusCode == 200) {
        neutering = jsonDecode(response.body);
        setState(() {
          neuteringdata = neutering["response"];
        });
        loading = true;
      } else {
        loading = true;
        AnimatedToast("Internal Server Error");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ServerError(),
        //   ),
        // );
      }
    } catch (exception) {
      AnimatedToast(exception.toString());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ServerError(),
      //   ),
      // );
    }
  }

  Future<http.Response> getuserdata() {
    return http.get(
      Uri.parse(ROOT + AllPetStatusByFormId + widget.formId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void UpdateNeutring() async {
    http.Response response = await neuteringform(
        widget.formId,
        isNeutering);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Navigator.of(context, rootNavigator: true).pop();
      AwesomeDialog(
          context: context,
          padding: const EdgeInsets.all(8.0),
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Neutering Status',
          desc:
          'Your Pet is Neutering Status Update Successfully.',
          btnOkOnPress: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
                  (route) => false,
            );
          }).show();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      String Message = "Some error . Please try again?";
      AnimatedToast(Message);
    }
  }

  Future<http.Response> neuteringform(
      String formId,
      String isNeutering,
      ) {
    return http.post(
      Uri.parse(ROOT + updateNeutering),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(<String, String>{
        'formId': formId,
        'isNeutering': isNeutering,
      }),
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
