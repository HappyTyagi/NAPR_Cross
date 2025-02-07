import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:ndialog/ndialog.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:lottie/lottie.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HashService.dart';
import '../../api.dart';
import '../../custom_toast_content_widget.dart';
import 'NewRegistration_Screen.dart';
import 'RegisterPendingDocumentPage.dart';
import 'ServerError.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class RegisterPendingPetStatusPage extends StatefulWidget {
  const RegisterPendingPetStatusPage({super.key});

  @override
  RegisterPendingPetStatusPageState createState() =>
      RegisterPendingPetStatusPageState();
}

class RegisterPendingPetStatusPageState extends State<RegisterPendingPetStatusPage>
    implements PayUCheckoutProProtocol {
  Widget get _spacer => const SizedBox(height: 12);
  Widget get _spacerwith => const SizedBox(width: 12);
  Widget get _cardSpacer => const SizedBox(height: 4);
  late SharedPreferences prefs;
  late PayUCheckoutProFlutter _checkoutPro;
  static const merchantKey = "4gcXBD"; // Add you Merchant Key
  static const iosSurl = "https://payu.herokuapp.com/success";
  static const iosFurl = "https://payu.herokuapp.com/failure";
  static const androidSurl = "https://payu.herokuapp.com/success";
  static const androidFurl = "https://payu.herokuapp.com/failure";
  var Token;
  var PhoneNumber;
  var formIddelete = "";
  List? listdata;
  late Map dattt;
  bool loading = false;
  bool loadingdone = false;
  var VefifyStatus;

  static String mobilenumber = "";
  static String formId = "";
  static String nickName = "";
  static String breedName = "";
  static String dob = "";
  static String createdOn = "";
  static String amount = "";
  static String orderid = "";
  static String ownerpayname = "";

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);
    retrieve();
  }

  Future retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
      Token = prefs.getString('TokenNo')!;
      PhoneNumber = prefs.getString('PhoneNumber')!;
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
          title: const Text('Pending Pets Status',
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
                            builder: (context) => NewRegistrationPage()));
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
                        'New Registration',
                        style: TextStyle(
                            fontSize: 10,
                            color: MyColors.white,
                            fontWeight: FontWeight.bold),
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
                                child: Lottie.asset('assets/images/data_found.json')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "Not Any Pets Found for Pending Registration . click registration and register new pet pets.",
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 11.0),
                                          child: Text(
                                              listdata?[index]["formId"],
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal)),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            NDialog(
                                              dialogStyle: DialogStyle(
                                                  titleDivider: true),
                                              title: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                    "Unregister Pets Data"),
                                              ),
                                              content: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                    "Are you sure to unregister this pets.If YES this pets details never show next time."),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                    child: const Text("CANCEL",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .primaryColor)),
                                                    onPressed: () =>
                                                        Navigator.pop(context)),
                                                TextButton(
                                                    child: const Text("YES",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .primaryColor)),
                                                    onPressed: () => {
                                                      Navigator.pop(context),
                                                          formIddelete =
                                                              listdata?[index]
                                                                  ["formId"],
                                                          DeleteRowdata(),
                                                        }),
                                              ],
                                            ).show(context);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(right: 18.0),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          _spacerwith,
                                          Container(
                                            width: _screen.width * 0.80,
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
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
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
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Breed Name",
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
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "Order Id",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Text(
                                                      listdata?[index]
                                                          ["orderId"],
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
                                                    Text(
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
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      child: AnimatedButton(
                                                        width: 115,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        text: listdata?[index][
                                                                    "mainDocFormResponse"] ==
                                                                null
                                                            ? 'Upload Document'
                                                            : 'Proceed to Payment',
                                                        color: MyColors
                                                            .primaryColor,
                                                        pressEvent: () async {
                                                          formId = listdata?[
                                                                          index]
                                                                      [
                                                                      "formId"] ==
                                                                  null
                                                              ? ""
                                                              : listdata?[index]
                                                                  ["formId"];
                                                          nickName = listdata?[
                                                                          index]
                                                                      [
                                                                      "nickName"] ==
                                                                  null
                                                              ? ""
                                                              : listdata?[index]
                                                                  ["nickName"];
                                                          breedName = listdata?[
                                                                          index]
                                                                      [
                                                                      "breedName"] ==
                                                                  null
                                                              ? ""
                                                              : listdata?[index]
                                                                  ["breedName"];
                                                          dob = listdata?[index]
                                                                      ["dob"] ==
                                                                  null
                                                              ? ""
                                                              : listdata?[index]
                                                                  ["dob"];

                                                          DateTime tsdate = DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  listdata?[
                                                                          index]
                                                                      [
                                                                      "createdOn"]);
                                                          createdOn = DateFormat(
                                                                  'dd-MMM-yyy')
                                                              .format(tsdate);
                                                          mobilenumber =
                                                              listdata?[index][
                                                                  "ownerNumber"];
                                                          orderid = listdata?[
                                                                          index]
                                                                      [
                                                                      "orderId"] ==
                                                                  null
                                                              ? ""
                                                              : listdata?[index]
                                                                  ["orderId"];
                                                          ownerpayname = listdata?[
                                                                          index]
                                                                      [
                                                                      "ownerName"] ==
                                                                  null
                                                              ? ""
                                                              : listdata?[index]
                                                                  ["ownerName"];
                                                          amount = listdata?[
                                                                          index]
                                                                      [
                                                                      "amount"] ==
                                                                  null
                                                              ? ""
                                                              : listdata?[index]
                                                                  ["amount"];
                                                          if (listdata?[index][
                                                                  "mainDocFormResponse"] ==
                                                              null) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => RegisterPendingDocumentPage(
                                                                        mobilenumber,
                                                                        formId,
                                                                        amount,
                                                                        orderid,
                                                                        ownerpayname,
                                                                        nickName,
                                                                        breedName,
                                                                        dob,
                                                                        createdOn)));
                                                          } else {
                                                            // _checkoutPro
                                                            //     .openCheckoutScreen(
                                                            //   payUPaymentParams:
                                                            //       createPayUPaymentParams(),
                                                            //   payUCheckoutProConfig:
                                                            //       createPayUConfigParams(),
                                                            // );
                                                            Dialogs.bottomMaterialDialog(
                                                                msg: 'Cards(credit/debit) payment option is currently unavailable. Please use UPI option to complete this transaction. ',
                                                                msgStyle: const TextStyle(color: Colors.black54),
                                                                title: 'Payment Option',
                                                                context: context,
                                                                actions: [
                                                                  IconsButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    text: 'CANCEL',
                                                                    iconData: Icons.cancel,
                                                                    color: MyColors.primaryColor,
                                                                    textStyle: TextStyle(color: Colors.white),
                                                                    iconColor: Colors.white,
                                                                  ),
                                                                  IconsButton(
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                      _checkoutPro.openCheckoutScreen(
                                                                        payUPaymentParams:
                                                                        createPayUPaymentParams(),
                                                                        payUCheckoutProConfig:
                                                                        createPayUConfigParams(),
                                                                      );
                                                                    },
                                                                    text: 'OK',
                                                                    iconData: Icons.payment,
                                                                    color: MyColors.primaryColor,
                                                                    textStyle: TextStyle(color: Colors.white),
                                                                    iconColor: Colors.white,
                                                                  ),
                                                                ]);


                                                          }
                                                        },
                                                      ),
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
      Uri.parse(ROOT + AllPendingPet + PhoneNumber),
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

  void DeleteRowdata() async {
    try {
      http.Response response = await Deletepet();
      print(response.body);
      if (response.statusCode == 200) {
        dattt = jsonDecode(response.body);
        setState(() {
          if (dattt["response"].isEmpty) {
            loading = true;
          } else {
            loading = false;
            listdata = dattt["response"];
            showToastWidget(
                IconToastWidget.success(msg: 'Pet Delete Successfully.'),
                context: context,
                position: StyledToastPosition.center,
                animation: StyledToastAnimation.scale,
                reverseAnimation: StyledToastAnimation.fade,
                duration: Duration(seconds: 4),
                animDuration: Duration(seconds: 1),
                curve: Curves.elasticOut,
                reverseCurve: Curves.linear);
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

  Future<http.Response> Deletepet() {
    return http.get(
      Uri.parse(ROOT + ClosePendingPet + formIddelete),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void paymentinfo(String txnData) async {
    try {
      http.Response response = await paymentinfodata(formId, txnData);
      print(response.body);
      var data = jsonDecode(response.body.toString());
      var msg = data["response"]["msg"];
      if (response.statusCode == 200) {
        AwesomeDialog(
            context: context,
            padding: const EdgeInsets.all(8.0),
            headerAnimationLoop: false,
            dismissOnTouchOutside: false,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Payment Success',
            desc:
                'Your Pet is Register Successfully. Now It s under Verification. It will be take time 1 or 2 days.',
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
        AnimatedToast("Some error Please try again?");
      }
    } catch (e) {
      AnimatedToast("Internal Server Error. Please try again?");
    }
  }

  Future<http.Response> paymentinfodata(String formId, String txnData) {
    return http.post(
      Uri.parse(ROOT + UpdatePaymentInfo),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(<String, String>{'formId': formId, 'txnData': txnData}),
    );
  }

  void paymentinfo1(String txnData) async {
    try {
      http.Response response = await paymentinfodata1(formId, txnData);
      print(response.body);
      var data = jsonDecode(response.body.toString());
      var msg = data["response"]["msg"];
      if (response.statusCode == 200) {
        AwesomeDialog(
            context: context,
            padding: const EdgeInsets.all(8.0),
            headerAnimationLoop: false,
            dismissOnTouchOutside: false,
            dialogType: DialogType.warning,
            animType: AnimType.bottomSlide,
            title: 'Payment Confirmation Pending',
            desc: 'If your amount is debit. please wait 3-7 working day.',
            btnOkColor: MyColors.yellow,
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
        AnimatedToast("Some error Please try again?");
      }
    } catch (e) {
      AnimatedToast("Internal Server Error. Please try again?");
    }
  }

  Future<http.Response> paymentinfodata1(String formId, String txnData) {
    return http.post(
      Uri.parse(ROOT + UpdatePaymentInfo1),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(<String, String>{'formId': formId, 'txnData': txnData}),
    );
  }

  showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Text(content),
            ),
            actions: [okButton],
          );
        });
  }

  @override
  generateHash(Map response) {
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server
    Map hashResponse = {};
    //Keep the salt and hash calculation logic in the backend for security reasons. Don't use local hash logic.
    //Uncomment following line to test the test hash.
    hashResponse = HashService.generateHash(response);
    _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  onPaymentSuccess(dynamic response) {
    paymentinfo(response.toString());
    //showAlertDialog(context, "onPaymentSuccess", response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    paymentinfo1(response.toString());
    //showAlertDialog(context, "onPaymentFailure", response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
    showToastWidget(IconToastWidget.success(msg: 'Payment Cancel '),
        context: context,
        position:
            const StyledToastPosition(align: Alignment.topCenter, offset: 57),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear);

    AwesomeDialog(
        context: context,
        padding: const EdgeInsets.all(18.0),
        headerAnimationLoop: false,
        dismissOnTouchOutside: false,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Payment Canceled',
        desc:
            'Now your pet information registered but payment not complete. Now check in New Registration Page',
        btnOkColor: MyColors.yellow,
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

  @override
  onError(Map? response) {
    paymentinfo1(response.toString());
    //showAlertDialog(context, "onError", response.toString());
  }

  static Map createPayUPaymentParams() {
    var siParams = {
      PayUSIParamsKeys.isFreeTrial: false,
      PayUSIParamsKeys.billingAmount: '1', //Required
      PayUSIParamsKeys.billingInterval: 1, //Required
      PayUSIParamsKeys.paymentStartDate:
          DateFormat("yyyy-MM-dd").format(DateTime.now()), //Required
      PayUSIParamsKeys.paymentEndDate:
          DateFormat("yyyy-MM-dd").format(DateTime.now()), //Required
      PayUSIParamsKeys.billingCycle: //Required
          'daily',
      //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON',
      //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX',
      //MAX, EXACT
    };

    var additionalParam = {
      PayUAdditionalParamKeys.udf1: mobilenumber,
      PayUAdditionalParamKeys.udf2: orderid,
      PayUAdditionalParamKeys.udf3: formId,
      PayUAdditionalParamKeys.udf4: ownerpayname,
      PayUAdditionalParamKeys.udf5: "udf5",
    };

    var spitPaymentDetails = {
      "type": "absolute",
      "splitInfo": {
        merchantKey: {
          "aggregatorSubTxnId": DateTime.now().millisecond,
          //unique for each transaction
          "aggregatorSubAmt": "1"
        }
      }
    };
    var payUPaymentParams = {
      PayUPaymentParamKey.key: merchantKey,
      PayUPaymentParamKey.amount: amount,
      PayUPaymentParamKey.productInfo: "NAPR",
      PayUPaymentParamKey.firstName: ownerpayname,
      PayUPaymentParamKey.email: "test@gmail.com",
      PayUPaymentParamKey.phone: mobilenumber,
      PayUPaymentParamKey.ios_surl: iosSurl,
      PayUPaymentParamKey.ios_furl: iosFurl,
      PayUPaymentParamKey.android_surl: androidSurl,
      PayUPaymentParamKey.android_furl: androidFurl,
      PayUPaymentParamKey.environment: "0",
      //0 => Production 1 => Test
      PayUPaymentParamKey.userCredential: mobilenumber,
      //Pass user credential to fetch saved cards => A:B - Optional
      PayUPaymentParamKey.transactionId: orderid,
      PayUPaymentParamKey.additionalParam: additionalParam,
      PayUPaymentParamKey.enableNativeOTP: true,
      // PayUPaymentParamKey.splitPaymentDetails: json.encode(spitPaymentDetails),
      // PayUPaymentParamKey.userToken: DateTime.now().millisecondsSinceEpoch.toString(),
      //Pass a unique token to fetch offers. - Optional
    };

    return payUPaymentParams;
  }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": ""},
      {"EMI": ""},
      {"NetBanking": ""},
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var enforcePaymentList = [
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
    ];

    var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [
          PayUPaymentTypeKeys.emi,
          PayUPaymentTypeKeys.card
        ]
      },
      {
        "custom_note": "Payment options custom note",
        "custom_note_category": null
      }
    ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#25272C",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "Noida Authority",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      // PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      // PayUCheckoutProConfigKeys.merchantLogo: "logo_sbi.png",
      //PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}
