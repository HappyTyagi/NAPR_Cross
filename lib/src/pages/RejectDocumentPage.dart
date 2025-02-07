import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../easy_permission_validator.dart';
import '../../permission.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../SuperEasyPermissionsMain.dart';
import '../../Webview.dart';
import '../../api.dart';
import '../../loading.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class RejectDocumentPage extends StatefulWidget {
  var petname = "";
  var dob = "";
  var breedName = "";
  var ownerName = "";
  var ownerNumber = "";
  var Expiredate = "";
  var formId = "";
  var docId = "";

  RejectDocumentPage(
    this.petname,
    this.dob,
    this.breedName,
    this.ownerName,
    this.ownerNumber,
    this.Expiredate,
    this.formId,
    this.docId,
  );

  @override
  RejectDocumentPageState createState() =>
      RejectDocumentPageState();
}

class RejectDocumentPageState extends State<RejectDocumentPage> {
  var Token = "";
  String _result = '';
  late SharedPreferences prefs;
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
    super.initState();
    retrieve();
    permisssion();
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
            icon:
                const Icon(Icons.arrow_back_ios, color: MyColors.whiteColor),
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          title: Text('Upload Document',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  color: MyColors.whiteColor,
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
                  Icon(Icons.privacy_tip_sharp,color: MyColors.whiteColor),
                  Text('Privacy Policy',
                      style: GoogleFonts.lato(
                          fontSize: 10,
                          color: MyColors.whiteColor,
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
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    const Icon(Icons.person, color: MyColors.whiteColor),
                    Text(
                      'Profile',
                      style: GoogleFonts.lato(
                          fontSize: 10,
                          color: MyColors.whiteColor,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal),
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
                            SizedBox(
                              height: 4.0,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Owner Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.ownerName,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Owner Number",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.ownerNumber,
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Pet Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.petname,
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Breed Name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.breedName,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pet Age",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.dob,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Registration Date ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.Expiredate,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
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
                            const SizedBox(
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _petwithownerimage != null
                                              ? FileImage(
                                                  File(_petwithownerimage!
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
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
                            const SizedBox(
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
                                }else {
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
                                          const TextStyle(color: Colors.white),
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _ownerphotoimage != null
                                              ? FileImage(
                                                  File(
                                                      _ownerphotoimage!.path),
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
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
                            SizedBox(
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _addressproofimage != null
                                              ? FileImage(File(
                                                  _addressproofimage!.path))
                                              : AssetImage(
                                                      'assets/images/bb.jpeg')
                                                  as ImageProvider,
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            SizedBox(
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _vaccinationimage != null
                                              ? FileImage(
                                                  File(_vaccinationimage!
                                                      .path),
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
                                }else {
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
                                    borderRadius:
                                        BorderRadius.circular(15.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.30,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: _vaccinationimageoptionl != null
                                              ? FileImage(File(_vaccinationimageoptionl!.path),
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
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      child: AnimatedButton(
                        width: MediaQuery.of(context).size.width * 0.60,
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        buttonTextStyle: TextStyle(color: MyColors.white),
                        pressEvent: () async {
                          AnimatedToast(widget.docId.toString());
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
                        text: 'Upload Document',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
          ),
        ));
  }

  void permisssion() async {
    camerapermission = await SuperEasyPermissionsMain.askPermission(Permissions.camera);
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
        http.MultipartRequest('POST', Uri.parse(ROOT + NewDocumentUpload));
    request.fields['formId'] = widget.formId;
    request.fields['docId'] = widget.docId;
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
      AwesomeDialog(
          context: context,
          padding: const EdgeInsets.all(8.0),
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'NAPR',
          desc: 'Your Document Uploaded Successfully. Now It s under Verification. It will be take time 1 or 2 days.',
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
      AwesomeDialog(
          context: context,
          padding: const EdgeInsets.all(8.0),
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'NAPR',
          desc: 'Some issues please try again',
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

    return response.toString();
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
