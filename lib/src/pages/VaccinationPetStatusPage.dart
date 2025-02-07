import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api.dart';
import 'BookVaccinationAppointmentStatus.dart';
import 'ServerError.dart';
import 'VaccinationAppointmentReschedule.dart';
import 'VaccinationDetailsPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class VaccinationPetStatusPage extends StatefulWidget {
  @override
  VaccinationPetStatusPageState createState() =>
      VaccinationPetStatusPageState();
}

class VaccinationPetStatusPageState extends State<VaccinationPetStatusPage> {
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
          title: const Text('Pet Vaccination Status',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 16.0,
                  color: MyColors.whiteColor)),
          // actions: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.only(bottom: 8.0),
          //     child: Align(
          //       alignment: Alignment.bottomCenter,
          //       child: InkWell(
          //         onTap: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => BookvaccinationAppointMentStatus()));
          //         },
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Container(
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(50),
          //                   border: Border.all(width: 2, color: Colors.white)),
          //               child: const Icon(
          //                 Icons.add,
          //                 color: Colors.white,
          //               ),
          //             ),
          //             const Text(
          //               'Vaccination Status',
          //               style: TextStyle(
          //                 fontSize: 10,),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          //   const SizedBox(
          //     width: 16,
          //   ),
          // ],
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
                              "Not Any Pets Found for Pending Vaccination.",
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
                          if (listdata?[index]["approverState"] == null ||
                              listdata?[index]["approverState"] == "RT") {
                            AwesomeDialog(
                                context: context,
                                padding: const EdgeInsets.all(8.0),
                                headerAnimationLoop: false,
                                dismissOnTouchOutside: false,
                                dialogType: DialogType.warning,
                                animType: AnimType.bottomSlide,
                                btnOkColor: MyColors.yellow,
                                title: 'Verification Status',
                                desc: 'Your Pet verification is currently Pending/Rejected. Please wait verify first then book vaccination appointment.',
                                btnOkOnPress: () {

                                }).show();
                          } else {
                            var formId = listdata?[index]["formId"];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VaccinationDetailsPage(formId)));
                          }
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
                                                listdata?[index]
                                                    ["registrationExpire"],
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: MyColors.red,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                        FontStyle.normal)),
                                            Icon(Icons.chevron_right)
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 10.0),
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
                                                    Text(
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
                                                  height: 4,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
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
                                                  height: 4,
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
                                                  height: 4,
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
                                                                  listdata[
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Penalty Amount",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata[index][
                                                                  "penaltyAmount"] ==
                                                              null
                                                          ? "0"
                                                          : listdata[index][
                                                                  "penaltyAmount"] +
                                                              "Rs",
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
                                                      "Day Remaining",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata[index]
                                                              ['dayRemaining'] +
                                                          " Days",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: MyColors.red,
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
                    }));
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
      Uri.parse(ROOT + VaccinationData),
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
