import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../DetailScreen.dart';
import '../../Webview.dart';
import '../../loginscreen.dart';
import 'SettingPage.dart';
import 'main_screen.dart';

class ComplaintHistoyDetailsPage extends StatefulWidget {
  String complaintId;
  String createdOn;
  String nameOfComplainer;
  String petName;
  String addressType;
  String pincode;
  String reason;
  String detailsOfComplainer;
  String photoUrl;
  String photoUrl2;
  String photoUrl3;
  String photoUrl4;

  ComplaintHistoyDetailsPage(
      this.complaintId,
      this.createdOn,
      this.nameOfComplainer,
      this.petName,
      this.addressType,
      this.pincode,
      this.reason,
      this.detailsOfComplainer,
      this.photoUrl,
      this.photoUrl2,
      this.photoUrl3,
      this.photoUrl4);

  @override
  ComplaintHistoyDetailsPageState createState() =>
      new ComplaintHistoyDetailsPageState();
}

class ComplaintHistoyDetailsPageState extends State<ComplaintHistoyDetailsPage> {
  Widget get _spacer => const SizedBox(height: 12);
  Widget get _cardSpacer => const SizedBox(height: 4);
  Widget get _spacerwith => const SizedBox(width: 12);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screen =  MediaQuery.of(context).size;
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
        title: const Text('Complaint Details',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 16.0,
                color: MyColors.whiteColor)),
        actions: <Widget>[
          InkWell(
            onTap: (){
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
                Icon(Icons.privacy_tip_sharp),
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 10),
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
                  Icon(Icons.person),
                  Text('Profile', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.blue[50],
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            //physics: BouncingScrollPhysics(),
            child:  Column(
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
                          padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                          child: Text(
                            "Owner Details",
                            style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal),
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
                                child:  Text(
                                  "Complaint ID",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.complaintId,textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
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
                              width: _screen.width * 0.40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  "Created On",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.createdOn,textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
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
                              width: _screen.width * 0.40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  "Name of Complainer",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.nameOfComplainer,textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
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
                              width: _screen.width * 0.40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  "Pet Name",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.petName,textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
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
                              width: _screen.width * 0.40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  "Address Type",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.addressType,textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
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
                              width: _screen.width * 0.40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  "Pincode",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.pincode,textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
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
                              width: _screen.width * 0.40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  "Reason",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.reason,textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
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
                              width: _screen.width * 0.40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  "Details of Complainer",textAlign: TextAlign.left,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Container(
                              width: _screen.width * 0.45,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child:  Text(
                                  widget.detailsOfComplainer,textAlign: TextAlign.right,
                                  style: GoogleFonts.lato(fontSize: 12,fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
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
                          padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                          child: Text(
                            "Photos",
                            style: GoogleFonts.lato(fontSize: 15,fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      _spacer,
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                var imageurl = widget.photoUrl;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(imageurl)));
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "http://petregistration.mynoida.co.in/" + widget.photoUrl),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                var imageurl = widget.photoUrl2;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(imageurl)));
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "http://petregistration.mynoida.co.in/" + widget.photoUrl2),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                var imageurl = widget.photoUrl3;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(imageurl)));
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "http://petregistration.mynoida.co.in/" + widget.photoUrl3),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                var imageurl = widget.photoUrl4;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailScreen(imageurl)));
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  height: 200.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "http://petregistration.mynoida.co.in/" + widget.photoUrl4),
                                          fit: BoxFit.cover)),
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
              ],
            ),
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
        position: StyledToastPosition(align: Alignment.topCenter,offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }
}
