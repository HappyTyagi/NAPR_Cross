import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Webview.dart';
import '../../api.dart';
import 'ComplaintHistoryDetailsPage.dart';
import 'RaiseComplaintPage.dart';
import 'ServerError.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ComplaintHistoryPage extends StatefulWidget {
  @override
  ComplaintHistoryPageState createState() => ComplaintHistoryPageState();
}

class ComplaintHistoryPageState extends State<ComplaintHistoryPage> {
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
          title: const Text('Complaint History',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 16.0,
                  color: MyColors.whiteColor)),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RaiseComplaintPage()));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 3, color: Colors.white)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'New Complaint',
                        style: TextStyle(
                            fontSize: 10,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
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
                              "Not Any Found for register pet  complaint.",
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
                      return GestureDetector(
                        onTap: () {
                          var complaintId =
                              listdata[index]["complaintId"] == null
                                  ? ""
                                  : listdata[index]["complaintId"];
                          var createdOn =
                              listdata[index]["createdOn"].toString() == null
                                  ? ""
                                  : listdata[index]["createdOn"].toString();
                          var nameOfComplainer =
                              listdata[index]["nameOfComplainer"] == null
                                  ? ""
                                  : listdata[index]["nameOfComplainer"];
                          var petName = listdata[index]["petName"] == null
                              ? ""
                              : listdata[index]["petName"];
                          var addressType =
                              listdata[index]["addressType"] == null
                                  ? ""
                                  : listdata[index]["addressType"];
                          var pincode = listdata[index]["pincode"] == null
                              ? ""
                              : listdata[index]["pincode"];
                          var reason = listdata[index]["reason"] == null
                              ? ""
                              : listdata[index]["reason"];
                          var detailsOfComplainer =
                              listdata[index]["detailsOfComplainer"] == null
                                  ? ""
                                  : listdata[index]["detailsOfComplainer"];
                          var photoUrl = listdata[index]["photoUrl"].toString();
                          var photoUrl2 =
                              listdata[index]["photoUrl2"].toString();
                          var photoUrl3 =
                              listdata[index]["photoUrl3"].toString();
                          var photoUrl4 =
                              listdata[index]["photoUrl4"].toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ComplaintHistoyDetailsPage(
                                          complaintId,
                                          createdOn,
                                          nameOfComplainer,
                                          petName,
                                          addressType,
                                          pincode,
                                          reason,
                                          detailsOfComplainer,
                                          photoUrl,
                                          photoUrl2,
                                          photoUrl3,
                                          photoUrl4)));
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
                                        Text("",
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.lato(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                fontStyle: FontStyle.normal)),
                                        Row(
                                          children: [
                                            Text("Processing",
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    color: MyColors.yellow,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal)),
                                            SizedBox(width: 10,),
                                            Icon(Icons.chevron_right)
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: _screen.width * 0.1,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(
                                                    Icons.announcement_outlined,
                                                    color:
                                                        MyColors.primaryColor)),
                                          ),
                                          Container(
                                            width: _screen.width * 0.40,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Complaint ID",
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: _screen.width * 0.35,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  listdata[index]
                                                      ["complaintId"],
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: _screen.width * 0.1,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(Icons.person_pin,
                                                    color:
                                                        MyColors.primaryColor)),
                                          ),
                                          Container(
                                            width: _screen.width * 0.40,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Owner Name",
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: _screen.width * 0.35,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  listdata[index]["ownerName"],
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: _screen.width * 0.1,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(Icons.pets,
                                                    color:
                                                        MyColors.primaryColor)),
                                          ),
                                          Container(
                                            width: _screen.width * 0.40,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Pet Name",
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: _screen.width * 0.35,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  listdata[index]["petName"],
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: _screen.width * 0.1,
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(
                                                  Icons
                                                      .admin_panel_settings_sharp,
                                                  color: MyColors.primaryColor,
                                                )),
                                          ),
                                          Container(
                                            width: _screen.width * 0.40,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Complaint Raised on",
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.lato(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: _screen.width * 0.35,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  listdata[index]["address"]
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
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
      Uri.parse(ROOT + ComplaintHistory),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void AnimatedToast(String message) {
    showToast(message,
        context: context,
        animation: StyledToastAnimation.rotate,
        reverseAnimation: StyledToastAnimation.fadeRotate,
        position: StyledToastPosition.center,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }
}
