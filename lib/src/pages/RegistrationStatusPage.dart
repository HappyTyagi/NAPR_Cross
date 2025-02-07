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

class RegistrationStatusPage extends StatefulWidget {
  @override
  RegistrationStatusPageState createState() => RegistrationStatusPageState();
}

class RegistrationStatusPageState extends State<RegistrationStatusPage> {
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
          title: const Text('Pet Status',
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
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
                              "Not Any Pets Found for Pending Registration .",
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
                        onTap: () {
                          var formId = listdata?[index]["formId"];
                          var amount = listdata[index]["amount"] == null
                              ? ""
                              : listdata[index]["amount"];
                          var dogurl1 = listdata?[index]["mainDocFormResponse"]
                              ["upload_dog1_url"];
                          var dogurl2 = listdata?[index]["mainDocFormResponse"]
                              ["upload_dog2_url"];
                          var dogurl3 = listdata?[index]["mainDocFormResponse"]
                              ["upload_dog3_url"];
                          var photourl = listdata?[index]["mainDocFormResponse"]
                              ["upload_photo_url"];
                          var vaccinationbook = listdata?[index]
                          ["mainDocFormResponse"]["upload_valid_book"] ?? "";
                          var txnId = listdata?[index]["txnId"] == null
                              ? ""
                              : listdata?[index]["txnId"];
                          var petname = listdata?[index]["nickName"] == null
                              ? ""
                              : listdata?[index]["nickName"];
                          var ownerName = listdata?[index]["ownerName"] == null
                              ? ""
                              : listdata?[index]["ownerName"];
                          var ownerNumber =
                              listdata?[index]["ownerNumber"] == null
                                  ? ""
                                  : listdata?[index]["ownerNumber"];
                          var address = listdata?[index]["address"] == null
                              ? ""
                              : listdata?[index]["address"];
                          var dob = listdata?[index]["dob"] == null
                              ? ""
                              : listdata?[index]["dob"];
                          var verifierState =
                              listdata?[index]["verifierState"] == null
                                  ? ""
                                  : listdata?[index]["verifierState"];
                          var upload_id_url = listdata?[index]
                              ["mainDocFormResponse"]["upload_id_url"];
                          var breedName = listdata?[index]["breedName"] == null
                              ? ""
                              : listdata?[index]["breedName"];
                          var approverRemark =
                              listdata?[index]["approverRemark"] == null
                                  ? ""
                                  : listdata?[index]["approverRemark"];
                          var verifierRemark =
                              listdata?[index]["verifierRemark"] == null
                                  ? ""
                                  : listdata?[index]["verifierRemark"];
                          var approverState =
                              listdata?[index]["approverState"] == null
                                  ? ""
                                  : listdata?[index]["approverState"];

                          DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(
                              listdata?[index]["createdOn"]);
                          var Expiredate =
                              DateFormat('dd-MMM-yyy').format(tsdate);
                          var docId = listdata?[index]["mainDocFormResponse"]["doc_form_id"];
                          var rabbiesDate = listdata?[index]["rabbiesDate"] == null ? "" : DateTime.fromMillisecondsSinceEpoch(
                              listdata?[index]["rabbiesDate"]);

                          // print("Avn  :--"+listdata?[index]["verifierRemark"]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPetDetailsPage(
                                        formId,
                                        amount,
                                        dogurl1,
                                        dogurl2,
                                        dogurl3,
                                        photourl,
                                        vaccinationbook,
                                        txnId,
                                        petname,
                                        ownerName,
                                        ownerNumber,
                                        address,
                                        dob,
                                        verifierState,
                                        upload_id_url,
                                        breedName,
                                        approverRemark,
                                        verifierRemark,
                                        approverState,
                                        Expiredate,
                                        docId,
                                       rabbiesDate.toString()
                                      )));
                        },
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
                                    SizedBox(
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

                                        Row(
                                          children: [
                                            Text(
                                                listdata?[index]["verifierState"] ==
                                                    "IB"
                                                    ? "Under Verification"
                                                    : listdata?[index][
                                                "verifierState"] ==
                                                    "RT"
                                                    ? "Reject"
                                                    : listdata?[index][
                                                "approverState"] ==
                                                    "RT"
                                                    ? "Reject"
                                                    : listdata?[index][
                                                "verifierState"] ==
                                                    "AP"
                                                    ? "Pending"
                                                    : listdata?[index][
                                                "approverState"] ==
                                                    "AP"
                                                    ? "Complete"
                                                    : listdata?[index]["approverState"] ==
                                                    null
                                                    ? "Under Verification"
                                                    : "Pending",
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: listdata?[index][
                                                    "verifierState"] ==
                                                        "RT"
                                                        ? MyColors.red
                                                        : listdata?[index]
                                                    ["approverState"] ==
                                                        "RT"
                                                        ? MyColors.red
                                                        : MyColors.yellow,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal)),
                                            SizedBox(width: 10,),
                                            Icon(Icons.chevron_right)
                                          ],
                                        )
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
                                                            listdata?[index]["mainDocFormResponse"]
                                                                ["upload_dog1_url"]),
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
                                                      listdata?[index]
                                                          ["nickName"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
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
                                                      listdata?[index]["dob"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Pet Des.",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata?[index]
                                                          ["breedName"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
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
                                                      listdata?[index]
                                                          ["ownerName"],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Registration Date",
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
                                                                  listdata?[
                                                                          index]
                                                                      [
                                                                      'createdOn'])),
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 2,
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
                                                                  listdata?[
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
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    }
                    )
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

  Future<http.Response> Registepet() {
    return http.get(
      Uri.parse(ROOT + AllregisterPetStatus),
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
