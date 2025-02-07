import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SuperEasyPermissionsMain.dart';
import '../../api.dart';
import '../../loading.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ServerError.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class VaccinationAppointmentReschedule extends StatefulWidget {
  String formId;
  String appointmentId;
  String mobile;

  VaccinationAppointmentReschedule(this.formId,this.appointmentId,this.mobile);

  @override
  VaccinationAppointmentRescheduleState createState() =>
      new VaccinationAppointmentRescheduleState();
}

class VaccinationAppointmentRescheduleState extends State<VaccinationAppointmentReschedule> {
  Widget get _spacer => const SizedBox(height: 12);

  Widget get _cardSpacer => const SizedBox(height: 4);

  Widget get _spacerwith => const SizedBox(width: 12);
  TextEditingController vaccinationdate = TextEditingController();
  var Token = "";
  int _user= 0;
  var mobilenumber = "";
  var vaccinationlist;
  List<dynamic> doctorlist = [];
  var doctorid = "";
  var slottingTime = "";
  bool doctordetail = false;
  bool checkbutton = false;
  late List listdata;
  late SharedPreferences prefs;
  late Map dattt;
  late Map vaccinationdata;
  bool loading = false;
  bool loadinggrid = false;
  bool loadinggriddone = false;
  var indexvalue;
  int selectedCard = -1;
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();

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
      DoctorListAPI();
      // GetVaccinationRescheduleData();
    });
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
        title: const Text('Vaccination Reschedule Appointment',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 16.0,
                color: MyColors.whiteColor)),
      ),
      backgroundColor: Colors.blue[50],
      body: !loading
          ? CardListSkeleton(
              isCircularImage: true,
              isBottomLinesActive: true,
              length: 5,
            )
          : SingleChildScrollView(
              //physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 3.0, bottom: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pet Details",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                              Container(
                                width: _screen.width * 0.45,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    vaccinationlist['nickName'],
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _cardSpacer,
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: _screen.width * 0.40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Breed Name",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                              Container(
                                width: _screen.width * 0.45,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    vaccinationlist['breedName'],
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _cardSpacer,
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                              Container(
                                width: _screen.width * 0.45,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    vaccinationlist['ownerName'],
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _cardSpacer,
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: _screen.width * 0.40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "valid Upto",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                              Container(
                                width: _screen.width * 0.45,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    DateFormat('dd-MMM-yyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            vaccinationlist['expiryDate'])),
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _cardSpacer,
                      ]),
                    ),
                  ),
                  _spacer,
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 3.0, bottom: 1.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select Appointment",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                        ),
                        _spacer,
                        Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 50,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(
                                        color: Colors.black87, width: 0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 8),
                                    child: DropDownTextField(
                                      enableSearch: false,
                                      searchShowCursor: false,
                                      clearOption: true,
                                      keyboardType: TextInputType.text,
                                      autovalidateMode: AutovalidateMode.always,
                                      clearIconProperty:
                                          IconProperty(color: Colors.black),
                                      searchDecoration: const InputDecoration(
                                          hintText: "search  here"),
                                      dropDownList: doctorlistdata(),
                                      onChanged: (val) {
                                        doctorid = val.value;
                                        setState(() {
                                          doctordetail = true;
                                          _user = doctorlistdata().indexOf(val);
                                          checkbutton=false;
                                          _btnController2.reset();
                                          selectedCard = -1;
                                          slottingTime = "";
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                bottom: 36,
                                child: Container(
                                    color: Colors.white,
                                    child: const Text('Hospital Name',
                                        style: TextStyle(
                                            color: MyColors.primaryColor))),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          width: double.maxFinite,
                          margin: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.black87),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.black87),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  hintText: "Select Appointment Date",
                                  labelText: "Appointment Date",
                                  labelStyle:
                                      TextStyle(color: MyColors.primaryColor),
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 0, bottom: 0),
                                  alignLabelWithHint: false,
                                  filled: true,
                                ),
                                controller: vaccinationdate,
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_month),
                                color: MyColors.primaryColor,
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2028),
                                    //initialDatePickerMode: DatePickerMode.year,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData(
                                          primaryColor: MyColors.primaryColor,
                                          // accentColor: MyColors.primaryColor,
                                          colorScheme: const ColorScheme.light(
                                              primary: MyColors.primaryColor),
                                          buttonBarTheme: ButtonBarThemeData(
                                            buttonTextTheme:
                                                ButtonTextTheme.accent,
                                          ),
                                        ),
                                        child: child ?? Container(),
                                      );
                                    },
                                  );
                                  if (date != null) {
                                    var formatter = DateFormat('yyyy-MM-dd');
                                    vaccinationdate.text =
                                        formatter.format(date);
                                    _btnController2.reset();
                                    selectedCard = -1;
                                    checkbutton = false;
                                    slottingTime = "";
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.60,
                                //margin: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Click Button and check Doctor Appointment",
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      color: MyColors.yellow,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.20,
                                //margin: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 35,
                                  width: 55,
                                  child: RoundedLoadingButton(
                                    color: MyColors.primaryColor,
                                    successColor: MyColors.primaryColor,
                                    controller: _btnController2,
                                    animateOnTap: checkbutton,
                                    onPressed: () {
                                      if (doctorid.isEmpty) {
                                        AnimatedToast("Please Select Hospital Name");
                                      } else if (vaccinationdate.text.isEmpty) {
                                        AnimatedToast("Please Select Appointment Date");
                                      } else {
                                        _btnController2.start();
                                        VaccinationSlotResponse();
                                        setState(() {
                                          checkbutton = true;
                                          // _btnController2.success();
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              context = context;
                                              return Loading("Please wait...");
                                            },
                                          );
                                        });
                                      }
                                    },
                                    valueColor: Colors.white,
                                    borderRadius: 10,
                                    child: const Text("Check",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _spacer,
                      ]),
                    ),
                  ),
                  _spacer,
                  !loadinggrid
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Please Select Hospital Name and Date then check Slotting Time",
                                  style: GoogleFonts.lato(
                                      fontSize: 14,
                                      color: MyColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Please Select Any One Slotting Time",
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: MyColors.primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: 200,
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 4,
                                    crossAxisSpacing: 1.0,
                                    mainAxisSpacing: 1.0,
                                    children:
                                        List.generate(listdata.length,(index) {
                                      return GestureDetector(
                                        onTap: () {
                                          slottingTime =
                                              listdata[index]["slottingTime"];
                                          setState(() {
                                            listdata[index]["slottingStatus"] ==
                                                "0"
                                                ? selectedCard = index
                                                : AnimatedToast(
                                                "Selected Slot Already Appoint.");
                                          });

                                        },
                                        child: Card(
                                          color: selectedCard == index ? MyColors.yellow : MyColors.primaryColor,
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Center(
                                              child: Text(
                                                listdata[index]["slottingTime"],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  _spacer,
                  Visibility(
                    visible: doctordetail,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Text(
                                "Doctor Details",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Doctor Name",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  doctorlist[_user]['name'],
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          _spacer,
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Hospital Name",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  doctorlist[_user]['hospitalName'],
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          _spacer,
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Mobile Number",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  doctorlist[_user]['mobile'],
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          _spacer,
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email ID",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  doctorlist[_user]['emailId'],
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ],
                            ),
                          ),
                          _spacer,
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: _screen.width * 0.20,
                                  child: Text(
                                    "Address",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                                Container(
                                  width: _screen.width * 0.60,
                                  child: Text(
                                    doctorlist[_user]['address'],
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _spacer,
                        ]),
                      ),
                    ),
                  ),
                  _spacer,
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      child: AnimatedButton(
                        width: MediaQuery.of(context).size.width * 0.60,
                        text: 'Book Appointment',
                        borderRadius: BorderRadius.circular(10.0),
                        color: MyColors.primaryColor,
                        pressEvent: () async {
                          if (doctorid.isEmpty) {
                            AnimatedToast("Please Select Hospital Name");
                          } else if (vaccinationdate.text.isEmpty) {
                            AnimatedToast("Please Select Appointment Date");
                          }else if (!checkbutton) {
                            AnimatedToast("Please Check Doctor Appointment");
                          } else if (slottingTime.isEmpty) {
                            AnimatedToast("Please Select Slotting Time");
                          } else {
                            mobilenumber = vaccinationlist['ownerNumber'];
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  context = context;
                                  return Loading("Please wait...");
                                },
                              );
                              AppointmentAPI();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }

  void GetUserData() async {
    try {
      http.Response response = await getuserdata();
      // print(response.body);
      if (response.statusCode == 200) {
        vaccinationdata = jsonDecode(response.body);
        setState(() {
          vaccinationlist = vaccinationdata["response"];
        });
        loading = true;
      } else {
        loading = true;
        AnimatedToast("Internal Server Error");
      }
    } catch (exception) {
      AnimatedToast(exception.toString());
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


  void GetVaccinationRescheduleData() async {
    try {
      http.Response response = await getvaccinationdata();
      print("Avn"+response.body);
      if (response.statusCode == 200) {
        // vaccinationdata = jsonDecode(response.body);
        // setState(() {
        //   vaccinationlist = vaccinationdata["response"];
        // });
        // loading = true;
      } else {
        loading = true;
        AnimatedToast("Internal Server Error");
      }
    } catch (exception) {
      AnimatedToast(exception.toString());
    }
  }

  Future<http.Response> getvaccinationdata() {
    return http.get(
      Uri.parse(ROOT + PendingVaccinationData),
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

  void DoctorListAPI() async {
    http.Response response =
        await registrationform('1676006153000', '1676006153000');
    // print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      setState(() {
        doctorlist = data['response'];
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      String Message = "Some error . Please try again?";
      AnimatedToast(Message);
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

  void AppointmentAPI() async {
    http.Response response = await appointment(
        doctorid, widget.formId, vaccinationdate.text, mobilenumber,slottingTime,widget.appointmentId);
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
          title: 'Book Appointment Status',
          desc: 'Your Pet Vaccination Appintment Successfully Register.',
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
      var data = jsonDecode(response.body.toString());
      AwesomeDialog(
          context: context,
          padding: const EdgeInsets.all(8.0),
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          title: 'Appointment Status',
          btnOkColor: MyColors.yellow,
          desc: data['response']['message'],
          btnOkOnPress: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
              (route) => false,
            );
          }).show();
    }
  }
  Future<http.Response> appointment(String doctorId, String formId,
      String appointmentDate, String mobileNumber,String slottingtime,String appointmentId) {
    return http.post(
      Uri.parse(ROOT + ReScheduleVaccinationAppointment),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(<String, String>{
        'doctorId': doctorId,
        'formId': formId,
        'appointmentDate': appointmentDate,
        'mobileNumber': mobileNumber,
        'slottingtime': slottingtime,
        'appointmentId': appointmentId,
      }),
    );
  }

  List<DropDownValueModel> doctorlistdata() {
    List<DropDownValueModel> doctorlistiteam = [];
    for (var i = 0; i < doctorlist.length; i++) {
      doctorlistiteam.add(DropDownValueModel(
          name: doctorlist[i]['hospitalName'],
          value: doctorlist[i]['doctorId']));
    }
    return doctorlistiteam;
  }

  void VaccinationSlotResponse() async {
    try {
      http.Response response =
          await vaccinationslot(doctorid, vaccinationdate.text.toString());
      // print(response.body);
      if (response.statusCode == 200) {
        dattt = jsonDecode(response.body);
        setState(() {
          if (dattt["response"].isEmpty) {
            loadinggrid = false;
            _btnController2.error();
          } else {
            loadinggrid = true;
            listdata = dattt["response"]['slotList'];
            _btnController2.success();
          }
        });
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
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

  Future<http.Response> vaccinationslot(String docId, String date) {
    return http.post(
      Uri.parse(ROOT + VaccinationSlot),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(<String, String>{
        'docId': docId,
        'date': date,
      }),
    );
  }
}
