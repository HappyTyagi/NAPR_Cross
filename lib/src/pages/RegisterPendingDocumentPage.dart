import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../easy_permission_validator.dart';
import '../../permission.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HashService.dart';
import '../../SuperEasyPermissionsMain.dart';
import '../../Webview.dart';
import '../../api.dart';
import '../../custom_toast_content_widget.dart';
import '../../loading.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class RegisterPendingDocumentPage extends StatefulWidget {
  var mobilenumber11 = "";
  var formId11 = "";
  var amount11 = "";
  var orderid11 = "";
  var ownerpayname11 = "";
  var nickName11 = "";
  var breedName11 = "";
  var dob11 = "";
  var createdOn11 = "";

  RegisterPendingDocumentPage(
    this.mobilenumber11,
    this.formId11,
    this.amount11,
    this.orderid11,
    this.ownerpayname11,
    this.nickName11,
    this.breedName11,
    this.dob11,
    this.createdOn11,
  );

  @override
  RegisterPendingDocumentPageState createState() =>
      RegisterPendingDocumentPageState();
}

class RegisterPendingDocumentPageState
    extends State<RegisterPendingDocumentPage>
    implements PayUCheckoutProProtocol {
  late PayUCheckoutProFlutter _checkoutPro;
  var Token = "";
  late SharedPreferences prefs;
  static const merchantKey = "4gcXBD"; // Add you Merchant Key
  static const iosSurl = "https://payu.herokuapp.com/success";
  static const iosFurl = "https://payu.herokuapp.com/failure";
  static const androidSurl = "https://payu.herokuapp.com/success";
  static const androidFurl = "https://payu.herokuapp.com/failure";
  static String mobilenumber = "";
  static String ownerpayname = "";
  static String amount = "";
  static String formId = "";
  static String orderid = "";
  bool petphoto1 = false;
  bool petphoto2 = false;
  bool petwithowner = false;
  bool idproof = false;
  bool ownerphoto = false;
  bool ownersign = false;
  bool addressproof = false;
  bool vaccinationbook = false;
  bool vaccinationbookoptional = false;

  String _filePermission = 'Not Enabled';
  String _result = '';
  late bool camerapermission;
  late bool medialibpermission;
  late bool photopermission;
  late bool storagepermission;

  File? _petphoto1image;
  File? _petphotoimage2;
  File? _petwithownerimage;
  File? _idfroofimage;
  File? _ownerphotoimage;
  File? _ownersignimage;
  File? _addressproofimage;
  File? _vaccinationimage;
  File? _vaccinationimageoptionl;

  Future getImage(ImageSource source) async {
    var image = null;
    try {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
    } catch (e) {
      _permissionWithCustomPopup();
      return;
    }
    final imageTemporery = File(image.path);
    setState(() {
      if (petphoto1) {
        this._petphoto1image = imageTemporery;
      } else if (petwithowner) {
        this._petwithownerimage = imageTemporery;
      } else if (petphoto2) {
        this._petphotoimage2 = imageTemporery;
      } else if (idproof) {
        this._idfroofimage = imageTemporery;
      } else if (ownerphoto) {
        this._ownerphotoimage = imageTemporery;
      } else if (ownersign) {
        this._ownersignimage = imageTemporery;
      } else if (addressproof) {
        this._addressproofimage = imageTemporery;
      } else if (vaccinationbook) {
        this._vaccinationimage = imageTemporery;
      } else if (vaccinationbookoptional) {
        this._vaccinationimageoptionl = imageTemporery;
      }
    });
  }

  Future getImageCamera() async {
    var image = null;
    try {
      image = await await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return;
      }
    } catch (e) {
      _permissionWithCustomPopup();
      return;
    }
    final imageTemporery = File(image.path);
    setState(() {
      if (petphoto1) {
        this._petphoto1image = imageTemporery;
      } else if (petwithowner) {
        this._petwithownerimage = imageTemporery;
      } else if (petphoto2) {
        this._petphotoimage2 = imageTemporery;
      } else if (idproof) {
        this._idfroofimage = imageTemporery;
      } else if (ownerphoto) {
        this._ownerphotoimage = imageTemporery;
      } else if (ownersign) {
        this._ownersignimage = imageTemporery;
      } else if (addressproof) {
        this._addressproofimage = imageTemporery;
      } else if (vaccinationbook) {
        this._vaccinationimage = imageTemporery;
      } else if (vaccinationbookoptional) {
        this._vaccinationimageoptionl = imageTemporery;
      }
    });
  }

  @override
  void initState() {
    _checkoutPro = PayUCheckoutProFlutter(this);
    super.initState();
    retrieve();
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Token = prefs.getString('TokenNo')!;
    });
  }

  void showdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        context = context;
        return Loading("Please wait ...");
      },
    );
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
          title: Text('Register Pending Document',
              style: GoogleFonts.lato(
                  fontSize: 16,
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
                  Icon(Icons.privacy_tip_sharp),
                  Text('Privacy Policy',
                      style: GoogleFonts.lato(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal)),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
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
                  children: const [
                    Icon(Icons.person, color: MyColors.whiteColor),
                    Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 10, fontFamily: AutofillHints.addressState),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: MyColors.whiteColor,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Card(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Owner Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.ownerpayname11,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Pet Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.nickName11,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Breed Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.breedName11,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Pet Age",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.dob11,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Registration Date ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.createdOn11,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Add Pet's Photos",
                            style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = true;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = true;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _petphoto1image != null
                                              ? FileImage(
                                                  File(_petphoto1image!.path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Pet Photo1",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = true;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = true;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _petwithownerimage != null
                                              ? FileImage(
                                                  File(
                                                      _petwithownerimage!.path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Pet With Owner",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = true;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = true;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _petphotoimage2 != null
                                              ? FileImage(
                                                  File(_petphotoimage2!.path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Pet Photo2",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = true;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = true;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _idfroofimage != null
                                              ? FileImage(
                                                  File(_idfroofimage!.path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Upload Photo ID",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = true;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = true;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _ownerphotoimage != null
                                              ? FileImage(
                                                  File(_ownerphotoimage!.path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Owner Photo",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = true;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = true;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _ownersignimage != null
                                              ? FileImage(
                                                  File(_ownersignimage!.path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Signature",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = true;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = true;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _addressproofimage != null
                                              ? FileImage(File(
                                                  _addressproofimage!.path))
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Address Proof",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = true;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = true;
                                            vaccinationbookoptional = false;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _vaccinationimage != null
                                              ? FileImage(
                                                  File(_vaccinationimage!.path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Vaccination Book",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (camerapermission != true &&
                                    storagepermission != true) {
                                  _permissionWithCustomPopup();
                                } else {
                                  Dialogs.bottomMaterialDialog(
                                      msg: 'Please Select any One Option',
                                      title: 'Upload Document',
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: () {
                                            getImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = true;
                                          },
                                          text: 'Gallery',
                                          iconData: Icons.image_outlined,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                        IconsButton(
                                          onPressed: () {
                                            getImageCamera();
                                            Navigator.pop(context);
                                            petphoto1 = false;
                                            petphoto2 = false;
                                            petwithowner = false;
                                            idproof = false;
                                            ownerphoto = false;
                                            ownersign = false;
                                            addressproof = false;
                                            vaccinationbook = false;
                                            vaccinationbookoptional = true;
                                          },
                                          text: 'Camera',
                                          iconData: Icons.camera,
                                          color: MyColors.primaryColor,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          iconColor: Colors.white,
                                        ),
                                      ]);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _vaccinationimageoptionl !=
                                                  null
                                              ? FileImage(
                                                  File(_vaccinationimageoptionl!
                                                      .path),
                                                )
                                              : const AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Vaccination Optional",
                                style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        "You will be redirected to our payment gateway pay your application amount.",
                        style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal)),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: AnimatedButton(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.60,
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                      buttonTextStyle: TextStyle(),
                      pressEvent: () async {
                        if (_petphoto1image == null) {
                          AnimatedToast("Please Upload Pet Photo1");
                        } else if (_petwithownerimage == null) {
                          AnimatedToast("Please Upload Pet With Owner Photo");
                        } else if (_petphotoimage2 == null) {
                          AnimatedToast("Please Upload Pet Photo2");
                        } else if (_idfroofimage == null) {
                          AnimatedToast("Please Upload Owner ID Proof");
                        } else if (_ownerphotoimage == null) {
                          AnimatedToast("Please Upload Owner Photo");
                        } else if (_ownersignimage == null) {
                          AnimatedToast("Please Upload Owner Sign.");
                        } else if (_addressproofimage == null) {
                          AnimatedToast("Please Upload Owner Address Proof");
                        } else if (_vaccinationimage == null) {
                          AnimatedToast("Please Upload Pet Vaccination");
                        } else {
                          showdialog(context);
                          uploadImage(
                              _petphoto1image!.path,
                              _petphotoimage2!.path,
                              _petwithownerimage!.path,
                              _idfroofimage!.path,
                              _ownerphotoimage!.path,
                              _ownersignimage!.path,
                              _addressproofimage!.path,
                              _vaccinationimage!.path);
                        }
                      },
                      text: 'Proceed to Payment',
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
          ),
        ));
  }

  void permisssion() async {
    camerapermission =
        await SuperEasyPermissionsMain.askPermission(Permissions.camera);
    medialibpermission =
        await SuperEasyPermissionsMain.askPermission(Permissions.mediaLibrary);
    photopermission =
        await SuperEasyPermissionsMain.askPermission(Permissions.photos);
    storagepermission =
        await SuperEasyPermissionsMain.askPermission(Permissions.storage);
    setState(() => _filePermission = 'Granted !');
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
  Future<String> uploadImage(filename1, filename2, filename3, filename4,
      filename5, filename6, filename7, filename8) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(ROOT + NewRegisterDocument));
    request.fields['formId'] = widget.formId11;
    request.files.add(await http.MultipartFile.fromPath('pet1', filename1));
    request.files.add(await http.MultipartFile.fromPath('pet2', filename2));
    request.files.add(await http.MultipartFile.fromPath('pet3', filename3));
    request.files.add(await http.MultipartFile.fromPath('file4', filename4));
    request.files.add(await http.MultipartFile.fromPath('file5', filename5));
    request.files.add(await http.MultipartFile.fromPath('file6', filename6));
    request.files.add(await http.MultipartFile.fromPath('file7', filename7));
    request.files.add(await http.MultipartFile.fromPath('file8', filename8));
    var response = await request.send();
    var result = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      var datata = jsonDecode(result);
      mobilenumber = widget.mobilenumber11;
      ownerpayname = widget.ownerpayname11;
      orderid = widget.orderid11;
      formId = widget.formId11;
      amount = datata["response"]["amount"];
      if (amount == "0") {
        Navigator.of(context, rootNavigator: true).pop();
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
        print(datata);
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
                    payUPaymentParams: createPayUPaymentParams(),
                    payUCheckoutProConfig: createPayUConfigParams(),
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
    } else {
      String Message = "Please try again?";
      AnimatedToast(Message);
    }

    return response.toString();
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

  void paymentinfo(String txnData) async {
    try {
      http.Response response = await paymentinfodata(widget.formId11, txnData);
      print(response.body);
      var data = jsonDecode(response.body.toString());
      var msg = data["response"]["msg"];
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
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
        Navigator.of(context, rootNavigator: true).pop();
        AnimatedToast("Some error Please try again?");
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
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
      http.Response response = await paymentinfodata1(widget.formId11, txnData);
      print(response.body);
      var data = jsonDecode(response.body.toString());
      var msg = data["response"]["msg"];
      if (response.statusCode == 200) {
        Navigator.of(context, rootNavigator: true).pop();
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
        Navigator.of(context, rootNavigator: true).pop();
        AnimatedToast("Some error Please try again?");
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
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
    //showAlertDialog(context, "onPaymentCancel", response.toString());
    showToastWidget(IconToastWidget.success(msg: 'Payment Cancel '),
        context: context,
        position: StyledToastPosition(align: Alignment.topCenter, offset: 57),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        duration: Duration(seconds: 4),
        animDuration: Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear);
    AwesomeDialog(
        context: context,
        padding: const EdgeInsets.all(8.0),
        headerAnimationLoop: false,
        dismissOnTouchOutside: false,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        title: 'Payment Canceled',
        desc:
            'Now your pet information registered but payment not complete. Now check in new Registration Page',
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

  _permissionWithCustomPopup() async {
    EasyPermissionValidator permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
      customDialog: MyAmazingCustomPopup(),
    );
    var result = await permissionValidator.camera();
    if (result) {
      setState(() => _result = 'Permission accepted');
    }
  }
}
