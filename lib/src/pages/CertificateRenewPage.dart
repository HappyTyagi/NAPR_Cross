import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../Webview.dart';
import '../../api.dart';
import '../../loading.dart';
import '../../loginscreen.dart';
import '../../thems.dart';
import 'ServerError.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class CertificateRenewPage extends StatefulWidget {
  @override
  CertificateRenewPageState createState() => new CertificateRenewPageState();
}

class CertificateRenewPageState extends State<CertificateRenewPage> {
  Widget get _spacer => const SizedBox(height: 12);

  Widget get _cardSpacer => const SizedBox(height: 4);
  final certificateController = TextEditingController();
  late SharedPreferences prefs;
  var Token;
  var renewdata;
  late Map dattt;
  bool loading = false;
  bool loadingdata = false;
  var RabiesVaccinationDate;
  var NextRabiesVaccinationDate;
  var CertificateExpired;

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  Future retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Token = prefs.getString('TokenNo')!;
    });
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
        title: Text('Verify Certificate',
            style: GoogleFonts.lato(
                fontSize: 16,
                color: MyColors.whiteColor,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal)),
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
              children: [
                Icon(Icons.privacy_tip_sharp,color: MyColors.whiteColor),
                Text('Privacy Policy',
                    style: GoogleFonts.lato(
                        fontSize: 10,
                        color: MyColors.whiteColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal)),
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
                children: [
                  const Icon(Icons.person,color: MyColors.whiteColor),
                  Text('Profile',
                      style: GoogleFonts.lato(
                          fontSize: 10,
                          color: MyColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal)),
                ],
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.55,
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        controller: certificateController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: "Certificate No.",
                          contentPadding: EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    AnimatedButton(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text('Search',
                          style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal)),
                      color: MyColors.primaryColor,
                      onPressed: () {
                        if (certificateController.text.isEmpty) {
                          String Message = "Please Enter Certificate No.";
                          AnimatedToast(Message);
                        // } else if (certificateController.text.length != 10) {
                        //   String Message =
                        //       "Please Enter Valid Certificate No.";
                        //   AnimatedToast(Message);
                        }
                          else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              context = context;
                              return Loading("Please Wait...");
                            },
                          );
                          setState(() {
                            loading = false;
                            mainResponse();
                          });
                        }
                      },
                      enabled: true,
                      shadowDegree: ShadowDegree.light,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: !loading
                      ? Center(
                          child: Text(
                              "Please enter certificate number and search data",
                              style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal)),
                        )
                      : !loadingdata
                          ? Lottie.asset('assets/images/data_found.json',
                              height: MediaQuery.of(context).size.width * 50)
                          : Card(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 150.0,
                                        height: 150.0,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "http://petregistration.mynoida.co.in/" +
                                                        renewdata[
                                                            "ownerPhotoUrl"]),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text("Certificate Number",
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal)),
                                    Text(renewdata["certificateNo"],
                                        style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Owner Name",
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal)),
                                    Text(
                                      renewdata["ownerName"],
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Pet Name",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    Text(
                                      renewdata["petNAme"],
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Rabies Vaccination Date",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    Text(
                                      RabiesVaccinationDate.toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Rabies Vaccination Next Date",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    Text(
                                      NextRabiesVaccinationDate.toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                      textAlign: TextAlign.justify,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Certificate Expired",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    Text(
                                      CertificateExpired.toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              )),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void mainResponse() async {
    try {
      http.Response response = await Registepet();
      print(response.body);
      if (response.statusCode == 200) {
        dattt = jsonDecode(response.body);
        setState(() {
          if (dattt["response"].isEmpty) {
            loading = true;
            loadingdata = false;
          } else {
            loading = true;
            loadingdata = true;
            renewdata = dattt["response"];
            int rabiesVaccinationDate =
                dattt["response"]["rabiesVaccinationDate"];
            DateTime tsdate =
                DateTime.fromMillisecondsSinceEpoch(rabiesVaccinationDate);
            RabiesVaccinationDate = DateFormat('dd-MMM-yyy').format(tsdate);

            int nextRabiesVaccinationDate =
                dattt["response"]["nextRabiesVaccinationDate"];
            DateTime tsdate1 =
                DateTime.fromMillisecondsSinceEpoch(nextRabiesVaccinationDate);
            NextRabiesVaccinationDate =
                DateFormat('dd-MMM-yyy').format(tsdate1);

            int certificateExpired = dattt["response"]["certificateExpired"];
            DateTime tsdate2 =
                DateTime.fromMillisecondsSinceEpoch(certificateExpired);
            CertificateExpired = DateFormat('dd-MMM-yyy').format(tsdate2);
          }
        });
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        loading = true;
        loadingdata = false;
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ServerError(),
        ),
      );
    }
  }

  Future<http.Response> Registepet() {
    return http.get(
      Uri.parse(
          ROOT + CertificateRenew + certificateController.text.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
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
        position: StyledToastPosition(align: Alignment.topCenter,offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }
}
