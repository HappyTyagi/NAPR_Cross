import 'dart:convert';
import 'package:animated_button/animated_button.dart';
import 'package:dialog_kh/dialog_kh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../PaymentReceptScreen.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../DetailScreen.dart';
import '../../PDFViewerScreen.dart';
import '../../Webview.dart';
import '../../api.dart';
import '../../loading.dart';
import 'RejectDocumentPage.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class RegisterPetDetailsPage extends StatefulWidget {
  String formId;
  String amount;
  String dogurl1;
  String dogurl2;
  String dogurl3;
  String photourl;
  String vaccinationbook;
  String txnId;
  String petname;
  String ownerName;
  String ownerNumber;
  String address;
  String dob;
  String verifierState;
  String upload_id_url;
  String breedName;
  String approverRemark;
  String verifierRemark;
  String approverState;
  String Expiredate;
  String docId;
  String rabbiesDate;

  RegisterPetDetailsPage(
    this.formId,
    this.amount,
    this.dogurl1,
    this.dogurl2,
    this.dogurl3,
    this.photourl,
    this.vaccinationbook,
    this.txnId,
    this.petname,
    this.ownerName,
    this.ownerNumber,
    this.address,
    this.dob,
    this.verifierState,
    this.upload_id_url,
    this.breedName,
    this.approverRemark,
    this.verifierRemark,
    this.approverState,
    this.Expiredate,
    this.docId,
    this.rabbiesDate,
  );

  @override
  RegisterPetDetailsPageState createState() => new RegisterPetDetailsPageState();
}

class RegisterPetDetailsPageState extends State<RegisterPetDetailsPage> {
  TextEditingController owneremailid = TextEditingController();

  Widget get _spacer => const SizedBox(height: 12);

  Widget get _cardSpacer => const SizedBox(height: 4);

  Widget get _spacerwith => const SizedBox(width: 12);
  final certificateController = TextEditingController();
  var Token = "";
  var msgurl;
  late SharedPreferences prefs;
  final emailpattern = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Token = prefs.getString('TokenNo')!;
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
        title: const Text('Pet Details',
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
      backgroundColor: Colors.blue[50],
      body: Container(
        child: SingleChildScrollView(
          //physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: widget.verifierState == "RT"
                    ? Colors.redAccent
                    : widget.verifierState == "IB"
                        ? MyColors.yellow
                        : widget.verifierState == "AP" &&
                                widget.approverState != "AP"
                            ? MyColors.yellow
                            : widget.approverState == "AP" &&
                                    widget.verifierState == "AP"
                                ? Colors.green
                                : MyColors.yellow,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Text("Status :-",
                            style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.white)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: Text(
                            widget.verifierState == "AP" &&
                                    widget.approverState != "AP"
                                ? "Payment complete. Now its under verification."
                                : widget.approverState == "AP" &&
                                        widget.verifierState == "AP"
                                    ? "Complete. ( Pet Verified Successfully. )"
                                    : widget.verifierState == "IB"
                                        ? "Payment complete. Now its under verification. "
                                        : widget.verifierState == "RT"
                                            ? "Reject  ( ${widget.verifierRemark} )"
                                            : widget.approverState=="RT" ? "Reject  ( ${widget.approverRemark} )"  :"Payment complete. Now its under verification.",
                            style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  var petname = widget.petname;
                  var dob = widget.dob;
                  var breedName = widget.breedName;
                  var ownerName = widget.ownerName;
                  var ownerNumber = widget.ownerNumber;
                  var Expiredate = widget.Expiredate;
                  var formId = widget.formId;
                  var docId = widget.docId;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RejectDocumentPage(
                              petname,
                              dob,
                              breedName,
                              ownerName,
                              ownerNumber,
                              Expiredate,
                              formId,
                              docId)));
                },
                child: Visibility(
                  visible: widget.verifierState == "RT" ? true : widget.approverState=="RT" ? true : false,
                  child: Container(
                    color: MyColors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: Text(
                                "Click here and Re-Upload your Document :-",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white)),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: Icon(Icons.file_upload_outlined)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: _screen.width * 0.40,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        var imageurl = widget.dogurl1;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(imageurl)));
                      },
                      child: Stack(fit: StackFit.loose, children: <Widget>[
                        Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://petregistration.mynoida.co.in/${widget.dogurl1}"),
                                  fit: BoxFit.cover)),
                        ),
                      ]),
                    ),
                  ),
                  _spacerwith,
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: _screen.width * 0.50,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  "Pet Name",
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  widget.petname,
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  "Pet Age",
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  widget.dob,
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  "Breed Name",
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  widget.breedName,
                                  textAlign: TextAlign.left,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Photo",
                          style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        var imageurl = widget.dogurl2;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(imageurl)));
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://petregistration.mynoida.co.in/" +
                                          widget.dogurl2),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var imageurl = widget.dogurl3;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(imageurl)));
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://petregistration.mynoida.co.in/" +
                                          widget.dogurl3),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: _screen.width * 0.60,
                      child: Text(
                        "Registration Certificate",
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    AnimatedButton(
                      height: 40,
                      width: _screen.width * 0.34,
                      enabled: widget.approverState == "AP" ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.archive,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Download',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        if (widget.rabbiesDate.isEmpty) {
                          NDialog(
                            dialogStyle: DialogStyle(titleDivider: true),
                            title: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Vaccination Status"),
                            ),
                            content: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                  "Your Pet vaccination is currently Pending. Please vaccination first then download Certificate."),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  child: const Text("OK",
                                      style: TextStyle(
                                          color: MyColors.primaryColor)),
                                  onPressed: () => {
                                        Navigator.pop(context),
                                      }),
                            ],
                          ).show(context);
                        } else {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                context = context;
                                return Loading("Please wait...");
                              },
                            );
                            mainResponse();
                          });
                        }
                      },
                      shadowDegree: ShadowDegree.light,
                      color: MyColors.primaryColor,
                    ),
                  ],
                ),
              ),
              Visibility(
                // visible: widget.amount== 0 ? false : true,
                visible: false ,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: _screen.width * 0.60,
                        child: Text(
                          "Payment Slip",
                          style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      AnimatedButton(
                        height: 40,
                        width: _screen.width * 0.34,
                        enabled: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.archive,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          owneremailid.clear();
                          DialogKh.alertDialogKh(
                            context: context,
                            title: "Payment Receipt",
                            backgroundColorBtnSubmit: MyColors.primaryColor,
                            descColor: MyColors.primaryColor,
                            titleColor: MyColors.black,
                            description: "Please enter your email Id",
                            isTextField: true, // default: false
                            isAutoClosed: false, // default: true
                            txtEditController: owneremailid,
                            onSubmit: () {
                              if(owneremailid.text.isEmpty){
                                AnimatedToast("Please enter valid email id");
                              }else if(!emailpattern.hasMatch(owneremailid.text)){
                                AnimatedToast("Please enter valid email id");
                              }else {
                                Navigator.pop(context);
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      context = context;
                                      return Loading(
                                          "Please wait. We will check the Payment ...");
                                    },
                                  );
                                  // GetPayMentRecpet();
                                });
                              }
                            },
                          );
                        },
                        shadowDegree: ShadowDegree.light,
                        color: MyColors.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: _screen.width * 0.60,
                      child: Text(
                        "Vaccination Book",
                        style: GoogleFonts.lato(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    AnimatedButton(
                      height: 40,
                      width: _screen.width * 0.34,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.view_compact,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'View',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        var imageurl = widget.vaccinationbook;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(imageurl)));
                      },
                      shadowDegree: ShadowDegree.light,
                      color: MyColors.primaryColor,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Card(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Owner Details",
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    var imageurl = widget.photourl;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailScreen(imageurl)));
                                  },
                                  child: Container(
                                    width: _screen.width * 0.20,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 4.0,
                                            color: MyColors.primaryColor),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "http://petregistration.mynoida.co.in/" +
                                                    widget.photourl),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                                _spacerwith,
                                Container(
                                  width: _screen.width * 0.50,
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Full Name",
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.ownerName,
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.ownerNumber,
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: _screen.width * 0.10,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.home,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: _screen.width * 0.70,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    widget.address,
                                    style: GoogleFonts.lato(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: _screen.width * 0.45,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Owner Identity",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lato(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Aadhaar/Ration Card/Voter ID etc",
                                          style: GoogleFonts.lato(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.normal),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: _screen.width * 0.12,
                                ),
                                AnimatedButton(
                                  height: 40,
                                  width: _screen.width * 0.30,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.view_compact,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'View',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    var imageurl = widget.upload_id_url;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailScreen(imageurl)));
                                  },
                                  shadowDegree: ShadowDegree.light,
                                  color: MyColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            "Transaction Details",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: _screen.width * 0.40,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Form ID",
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
                                      widget.formId,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _spacer,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: _screen.width * 0.40,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Transaction ID",
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
                                      widget.txnId,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _spacer,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: _screen.width * 0.40,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Paid to NAPR",
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
                                      widget.amount,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.lato(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _spacer,
                    ]),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
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

  void mainResponse() async {
    http.Response response = await DownloadCertificate();
    print(response.body);
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var object = data["object"];
      var pdfurl = object;
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PDFViewerScreen(pdfurl)));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      String Message = "Download Failed Certificate. Please tyr Again.";
      AnimatedToast(Message);
    }
  }

  Future<http.Response> DownloadCertificate() {
    return http.get(
      Uri.parse(ROOTDownload + DownloadPDf),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'id': widget.formId,
        'link': 'http://petregistration.mynoida.co.in/',
        'Token': Token,
      },
    );
  }


  void GetPayMentRecpet() async {
    try {
      http.Response response = await recept(widget.formId);
      print(response.body);
      var data = jsonDecode(response.body.toString());
      var message = data["response"]["message"];
      msgurl = data["response"]["msg"];
      if (response.statusCode == 200) {
        SendMail();
        // Navigator.of(context, rootNavigator: true).pop();
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => PaymentreciptScreen(msgurl)));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        AnimatedToast("Some error Please try again?");
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      AnimatedToast("Internal Server Error. Please try again?");
    }
  }

  Future<http.Response> recept(String formId) {
    return http.post(
      Uri.parse(ROOT + Paymentrecept),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'formId': formId}),
    );
  }

  void SendMail() async {
    try {
      http.Response response = await sendemail(owneremailid.text,msgurl);
      print(response.body);
      var data = jsonDecode(response.body.toString());
      // var message = data["response"]["message"];
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PaymentreciptScreen(msgurl)));
        AnimatedToast("success");
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        AnimatedToast("Some error Please try again?");
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      AnimatedToast("Internal Server Error. Please try again send ?");
    }
  }

  Future<http.Response> sendemail(String email,String msgurl) {
    return http.post(
      Uri.parse(ROOT + SendEmail),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email,'url':msgurl}),
    );
  }
}
