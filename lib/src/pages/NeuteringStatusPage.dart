import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Webview.dart';
import '../../api.dart';
import '../../loginscreen.dart';
import 'NeuteringStatusChangePage.dart';
import 'RegisterPetDetailsPage.dart';
import 'ServerError.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class NeuteringStatusPage extends StatefulWidget {
  @override
  NeuteringStatusPageState createState() => NeuteringStatusPageState();
}

class NeuteringStatusPageState extends State<NeuteringStatusPage> {
  Widget get _spacer => const SizedBox(height: 12);

  Widget get _spacerwith => const SizedBox(width: 12);

  Widget get _cardSpacer => const SizedBox(height: 4);
  late SharedPreferences prefs;
  var Token;
  late List listdata;
  late Map dattt;
  bool loading = false;
  bool loadingdone = false;
  var VefifyStatus;
  var formId = "";
  String IsNeuteringValue = "";

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
    mainResponse();
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
          title: const Text('Neutering Status',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 16.0,
                  color: MyColors.whiteColor)),
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
                              "Not Any Pets Found for Neutering.",
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
                : ListView.builder(
                    itemCount: listdata?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Colors.blue[50],
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(listdata?[index]["formId"],
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal)),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0),
                                          child: Text("",
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: MyColors.yellow,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: _screen.width * 0.20,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "http://petregistration.mynoida.co.in/" +
                                                            listdata?[index][
                                                                    "mainDocFormResponse"]
                                                                [
                                                                "upload_dog1_url"]),
                                                    fit: BoxFit.cover)),
                                          ),
                                          _spacerwith,
                                          Container(
                                            width: _screen.width * 0.60,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Pet Name",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      listdata[index]
                                                          ["nickName"],
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Pet Age",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata[index]["dob"],
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Pet Des.",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata[index]
                                                          ["breedName"],
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Owner Name",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata[index]
                                                          ["ownerName"],
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Valid Upto",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      DateFormat('dd-MMM-yyy')
                                                          .format(DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  listdata[
                                                                          index]
                                                                      [
                                                                      'expiryDate'])),
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Neutering Status",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata[index]['isNeutering'] == null
                                                          ? ""
                                                          : listdata[index]['isNeutering'],
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    IconsButton(
                                      onPressed: () => {
                                        formId = listdata?[index]["formId"],
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    NeuteringStatusChangePage(
                                                        formId))),
                                      },
                                      text: 'Update Your Pet Neutering Status',
                                      iconData: Icons.update,
                                      color: MyColors.primaryColor,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    }));
  }

  void mainResponse() async {
    try {
      http.Response response = await NeuteringStatuspet();
      print(response.body);
      if (response.statusCode == 200) {
        dattt = jsonDecode(response.body);
        setState(() {
          if (dattt["response"].isEmpty) {
            loading = true;
          } else {
            loading = false;
            listdata = dattt["response"];
          }
        });
        await Future.delayed(Duration(seconds: 3), () {
          setState(() {
            loadingdone = true;
          });
        });
      } else {
        await Future.delayed(Duration(seconds: 3), () {
          setState(() {
            loadingdone = true;
          });
        });
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

  Future<http.Response> NeuteringStatuspet() {
    return http.get(
      Uri.parse(ROOT + AllPetNeuteringStatus),
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
        position: StyledToastPosition(align: Alignment.topCenter, offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }
}
