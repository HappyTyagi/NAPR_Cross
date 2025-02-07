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
import 'ServerError.dart';
import 'VaccinationAppointmentReschedule.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class BookvaccinationAppointMentStatus extends StatefulWidget {
  @override
  BookvaccinationAppointMentStatusState createState() =>
      BookvaccinationAppointMentStatusState();
}

class BookvaccinationAppointMentStatusState
    extends State<BookvaccinationAppointMentStatus> {
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
  var Currentdate;


  @override
  void initState() {
    super.initState();
    retrieve();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    Currentdate = formatter.format(now);
    // print(Currentdate);
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
    final _screen = MediaQuery
        .of(context)
        .size;
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
          title: const Text('Book Vaccination Status',
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
                      height: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Lottie.asset(
                          'assets/images/data_found.json')),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Not Any Pets Found for Pending Vaccination .",
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
            itemCount: listdata.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
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
                              Text(listdata[index]['mainForm']["formId"] ?? "",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal)),
                              Text(
                                  listdata[index]["getAllDoctorDetails"]
                                  ['isCancel'] ==
                                      "1"
                                      ? "Cancel By Doctor"
                                      : listdata[index]['getAllDoctorDetails']
                                  ['isComplete'] ==
                                      "0"
                                      ? "Pending"
                                      : listdata[index]
                                  ["getAllDoctorDetails"]
                                  ['isComplete'] ==
                                      "1"
                                      ? "Complete"
                                      : "Pending",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: listdata[index]
                                      ["getAllDoctorDetails"]
                                      ['isCancel'] ==
                                          "1"
                                          ? MyColors.red
                                          : listdata[index]
                                      ["getAllDoctorDetails"]
                                      ['isComplete'] ==
                                          "0"
                                          ? MyColors.yellow
                                          : listdata[index]
                                      ["getAllDoctorDetails"]
                                      ['isComplete'] ==
                                          "1"
                                          ? MyColors.green
                                          : MyColors.yellow,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: _screen.width * 0.85,
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
                                            listdata[index]['mainForm']
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
                                                fontWeight:
                                                FontWeight.normal),
                                          ),
                                          Text(
                                            listdata[index]['mainForm']
                                            ["dob"],
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.normal),
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
                                            "Doctor Name",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.normal),
                                          ),
                                          Text(
                                            listdata[index]
                                            ['docterDetiails']
                                            ["name"],
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.normal),
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
                                            "Appointment Date",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.normal),
                                          ),
                                          Text(
                                            DateFormat('dd-MMM-yyy').format(
                                                DateTime.fromMillisecondsSinceEpoch(
                                                    listdata[index]['getAllDoctorDetails']
                                                    ["appointmentDate"])),
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
                                            "Visit Time",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                FontWeight.normal),
                                          ),
                                          Text(
                                            listdata[index][
                                            'getAllDoctorDetails']
                                            ["slottingTime"],
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
                                          SizedBox(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.35,
                                            child: const Text(
                                              "Hospital Name",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.50,
                                            child: Text(
                                              listdata[index]
                                              ['docterDetiails']
                                              ["hospitalName"],
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
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
                                          SizedBox(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.35,
                                            child: const Text(
                                              "Address",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                0.50,
                                            child: Text(
                                              listdata[index]
                                              ['docterDetiails']
                                              ["address"],
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Visibility(
                                        visible: listdata[index][
                                        "getAllDoctorDetails"]
                                        ['isCancel'] ==
                                            "1"
                                            ? false
                                            : true,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                              "Doctor Verify Code",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: MyColors
                                                      .primaryColor,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              listdata[index][
                                              'getAllDoctorDetails']
                                              ["userCode"],
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: MyColors
                                                      .primaryColor,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Visibility(
                                        visible: listdata[index][
                                        "getAllDoctorDetails"]
                                        ['isCancel'] ==
                                            "1"
                                            ? true
                                            : false,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            const Text(
                                              "Cancel Reason",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
                                            Text(
                                              listdata[index]['getAllDoctorDetails']
                                              [
                                              "cancelReason"] ==
                                                  null
                                                  ? ""
                                                  : listdata[index][
                                              'getAllDoctorDetails']
                                              ["cancelReason"],
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight
                                                      .normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Visibility(
                                        visible: DateTime.parse(Currentdate)
                                            .isAfter(DateTime.parse(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.fromMillisecondsSinceEpoch(
                                                    listdata[index]['getAllDoctorDetails']["appointmentDate"]))))
                                            ? true
                                            : false,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            SizedBox(
                                              width:
                                              MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.55,
                                              child: const Text(
                                                "Reschedule Appointment",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              child: AnimatedButton(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.30,
                                                color: MyColors
                                                    .primaryColor,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10.0),
                                                buttonTextStyle:
                                                TextStyle(),
                                                pressEvent: () async {
                                                  var formid=listdata[index]['getAllDoctorDetails']["formId"];
                                                  var appointmentId =listdata[index]['getAllDoctorDetails']["appointmentId"];
                                                  var mobile =listdata[index]['docterDetiails']["mobile"];
                                                  Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  VaccinationAppointmentReschedule(formid,appointmentId,mobile)));

                                                },
                                                text: 'Reschedule',
                                              ),
                                            ),
                                          ],
                                        ),
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
      Uri.parse(ROOT + UserAppointment),
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
