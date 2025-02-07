import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../easy_permission_validator.dart';
import '../../permission.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
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

class RaiseComplaintPage extends StatefulWidget {
  @override
  RaiseComplaintPageState createState() => new RaiseComplaintPageState();
}

class RaiseComplaintPageState extends State<RaiseComplaintPage> {
  final TextEditingController complainername = TextEditingController();
  final TextEditingController reason = TextEditingController();
  final TextEditingController deatilsofcomplainer = TextEditingController();
  final TextEditingController addressline = TextEditingController();
  final TextEditingController landmark = TextEditingController();
  final TextEditingController block = TextEditingController();
  final TextEditingController streetno = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController ownername = TextEditingController();
  final TextEditingController houseno = TextEditingController();
  final TextEditingController petname = TextEditingController();
  final TextEditingController towernumber = TextEditingController();
  final TextEditingController flatnumber = TextEditingController();

  String AddreetypeValue = "Village";
  var Token = "";
  late SharedPreferences prefs;
  String _result = '';
  List<dynamic> categorylist = [];
  List<dynamic> breedlist = [];
  List<dynamic> villagelist = [];
  List<dynamic> sectorlist = [];
  List<dynamic> scoietylist = [];

  List<DropDownValueModel> categorylistdata() {
    List<DropDownValueModel> categorylistiteam = [];
    for (var i = 0; i < categorylist.length; i++) {
      categorylistiteam.add(DropDownValueModel(
          name: categorylist[i]['descr'], value: categorylist[i]['catId']));
    }

    return categorylistiteam;
  }

  List<DropDownValueModel> breedlistdata() {
    List<DropDownValueModel> breedlistiteam = [];
    for (var i = 0; i < breedlist.length; i++) {
      breedlistiteam.add(DropDownValueModel(
          name: breedlist[i]['descr'], value: breedlist[i]['breedId']));
    }

    return breedlistiteam;
  }

  List<DropDownValueModel> villagelistdata() {
    List<DropDownValueModel> villagelistiteam = [];
    for (var i = 0; i < villagelist.length; i++) {
      villagelistiteam.add(DropDownValueModel(
          name: villagelist[i]['descr'], value: villagelist[i]['villageId']));
    }
    return villagelistiteam;
  }

  List<DropDownValueModel> sectorlistdata() {
    List<DropDownValueModel> sectorlistiteam = [];
    for (var i = 0; i < sectorlist.length; i++) {
      sectorlistiteam.add(DropDownValueModel(
          name: sectorlist[i]['descr'], value: sectorlist[i]['sectorId']));
    }
    return sectorlistiteam;
  }

  List<DropDownValueModel> scoietylistdata() {
    List<DropDownValueModel> scoietylistiteam = [];
    for (var i = 0; i < scoietylist.length; i++) {
      scoietylistiteam.add(DropDownValueModel(
          name: scoietylist[i]['name'],
          value: scoietylist[i]['manageSocietyId']));
    }
    return scoietylistiteam;
  }

  var _breedid = "";
  var _categoryid = "";
  var sectorid = "";
  var societyid = "";
  var villageid = "";
  var complaintId = "";

  bool photo1 = false;
  bool photo2 = false;
  bool photo3 = false;
  bool photo4 = false;
  bool houseno_flat = false;
  bool society_hide = false;
  bool tower_no_hide = false;
  bool streetno_hide = false;
  bool flatno_hide = false;
  bool village_name_hide = true;
  bool sizebox_hide = true;
  bool address_line_hide = true;
  bool block_hide = true;
  bool landmark_hide = true;

  File? photo1image;
  File? photo2image;
  File? photo3image;
  File? photo4image;
  String _filePermission = 'Not Enabled';

  late bool camerapermission;
  late bool medialibpermission;
  late bool photopermission;
  late bool storagepermission;

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
      if (photo1) {
        photo1image = imageTemporery;
      } else if (photo2) {
        photo2image = imageTemporery;
      } else if (photo3) {
        photo3image = imageTemporery;
      } else if (photo4) {
        photo4image = imageTemporery;
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
      if (photo1) {
        photo1image = imageTemporery;
      } else if (photo2) {
        photo2image = imageTemporery;
      } else if (photo3) {
        photo3image = imageTemporery;
      } else if (photo4) {
        photo4image = imageTemporery;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    permisssion();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showdialog(context);
    });

    retrieve();
  }

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Token = prefs.getString('TokenNo')!;
      CategoryData();
      GetVillageData();
      GetSectorData();
      GetScoietyData();
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

  final _status = ["Village", "Residence", "High-Rise Society"];

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
          title: Text('Raise Complaint',
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
                  children: [
                    Icon(Icons.person),
                    Text('Profile',
                        style: GoogleFonts.lato(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal)),
                  ],
                ),
              ),
            )
          ],
        ),
        backgroundColor: MyColors.whiteColor,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 45,
                    width: double.maxFinite,
                    margin:
                        const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                    child: TextField(
                      controller: complainername,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter Name of Complainer",
                        hintStyle: TextStyle(fontSize: 14),
                        labelText: "Name of Complainer",
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 10, right: 0, bottom: 0),
                        labelStyle: TextStyle(color: MyColors.primaryColor),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.only(left: 8.0, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0,
                          color: Colors.black87,
                        ),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 10),
                          child: Text("Address Type",
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal)),
                        ),
                        RadioGroup<String>.builder(
                          direction: Axis.vertical,
                          groupValue: AddreetypeValue,
                          horizontalAlignment: MainAxisAlignment.spaceAround,
                          onChanged: (value) => setState(() {
                            AddreetypeValue = value ?? '';
                            if (AddreetypeValue == "Village") {
                              houseno_flat = false;
                              society_hide = false;
                              tower_no_hide = false;
                              streetno_hide = false;
                              flatno_hide = false;
                              village_name_hide = true;
                              sizebox_hide = true;
                              address_line_hide = true;
                              block_hide = true;
                              landmark_hide = true;
                            } else if (AddreetypeValue == "Residence") {
                              streetno_hide = true;
                              houseno_flat = true;
                              block_hide = true;
                              landmark_hide = true;
                              address_line_hide = true;
                              village_name_hide = false;
                              sizebox_hide = false;
                              society_hide = false;
                              tower_no_hide = false;
                              flatno_hide = false;
                            } else if (AddreetypeValue == "High-Rise Society") {
                              village_name_hide = false;
                              houseno_flat = false;
                              streetno_hide = false;
                              landmark_hide = false;
                              address_line_hide = true;
                              block_hide = false;
                              society_hide = true;
                              tower_no_hide = true;
                              flatno_hide = true;
                              sizebox_hide = true;
                            }
                          }),
                          items: _status,
                          fillColor: MyColors.primaryColor,
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          itemBuilder: (item) => RadioButtonBuilder(
                            item,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 50,
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.black87, width: 0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12.0, right: 8),
                                child: DropDownTextField(
                                  enableSearch: true,
                                  searchShowCursor: true,
                                  clearOption: true,
                                  keyboardType: TextInputType.text,
                                  autovalidateMode: AutovalidateMode.always,
                                  clearIconProperty:
                                      IconProperty(color: Colors.black),
                                  searchDecoration: const InputDecoration(
                                      hintText: "search  here"),
                                  dropDownList: sectorlistdata(),
                                  onChanged: (val) {
                                    sectorid = val.value;
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
                                child: const Text('Sector Name',
                                    style: TextStyle(
                                        color: MyColors.primaryColor))),
                          )
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: houseno_flat,
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      margin:
                          const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                      child: TextField(
                        controller: houseno,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter House/Flat/Plot Number",
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: "House/Flat/Plot Number",
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Visibility(
                      visible: sizebox_hide,
                      child: SizedBox(
                        height: 20,
                      )),
                  Visibility(
                    visible: society_hide,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 50,
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.black87, width: 0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 8),
                                  child: DropDownTextField(
                                    enableSearch: true,
                                    searchShowCursor: true,
                                    clearOption: true,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode: AutovalidateMode.always,
                                    clearIconProperty:
                                        IconProperty(color: Colors.black),
                                    searchDecoration: const InputDecoration(
                                        hintText: "search  here"),
                                    dropDownList: scoietylistdata(),
                                    onChanged: (val) {
                                      societyid = val.value;
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
                                  child: const Text('Society Name',
                                      style: TextStyle(
                                          color: MyColors.primaryColor))),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: streetno_hide,
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      margin:
                          const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                      child: TextField(
                        controller: streetno,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Street Number",
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: "Street Number",
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: village_name_hide,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 50,
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                      color: Colors.black87, width: 0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 8),
                                  child: DropDownTextField(
                                    enableSearch: true,
                                    searchShowCursor: true,
                                    clearOption: true,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode: AutovalidateMode.always,
                                    clearIconProperty:
                                        IconProperty(color: Colors.black),
                                    searchDecoration: const InputDecoration(
                                        hintText: "search  here"),
                                    dropDownList: villagelistdata(),
                                    onChanged: (val) {
                                      villageid = val.value;
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
                                  child: const Text('Village Name',
                                      style: TextStyle(
                                          color: MyColors.primaryColor))),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: tower_no_hide,
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      margin:
                          const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                      child: TextField(
                        controller: towernumber,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Tower Number",
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: "Tower Number",
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: block_hide,
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      margin:
                          const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                      child: TextField(
                        controller: block,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Block",
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: "Block",
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: landmark_hide,
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      margin:
                          const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                      child: TextField(
                        controller: landmark,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Landmark",
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: "Landmark",
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: address_line_hide,
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      margin:
                          const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                      child: TextField(
                        controller: addressline,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Address Line 1",
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: "Address Line 1",
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: flatno_hide,
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      margin:
                          const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                      child: TextField(
                        controller: flatnumber,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Flat Number",
                          hintStyle: TextStyle(fontSize: 14),
                          labelText: "Flat Number",
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  Container(
                    height: 65,
                    width: double.maxFinite,
                    margin:
                        const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                    child: TextField(
                      maxLength: 6,
                      controller: pincode,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter Pin Code",
                        hintStyle: TextStyle(fontSize: 14),
                        labelText: "Pin Code",
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 10, right: 0, bottom: 0),
                        labelStyle: TextStyle(color: MyColors.primaryColor),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    height: 95,
                    width: double.maxFinite,
                    margin:
                        const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                    child: TextField(
                      maxLines: 10,
                      controller: reason,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter Reason",
                        hintStyle: TextStyle(fontSize: 14),
                        labelText: "Reason",
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 30, right: 0, bottom: 0),
                        labelStyle: TextStyle(color: MyColors.primaryColor),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    height: 95,
                    width: double.maxFinite,
                    margin:
                        const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                    child: TextField(
                      maxLines: 10,
                      controller: deatilsofcomplainer,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter Details of Complainer",
                        hintStyle: TextStyle(fontSize: 14),
                        labelText: "Details of Complainer",
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 30, right: 0, bottom: 0),
                        labelStyle: TextStyle(color: MyColors.primaryColor),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    height: 45,
                    width: double.maxFinite,
                    margin:
                        const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                    child: TextField(
                      controller: ownername,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter Owner Name",
                        hintStyle: TextStyle(fontSize: 14),
                        labelText: "Owner Name",
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 10, right: 0, bottom: 0),
                        labelStyle: TextStyle(color: MyColors.primaryColor),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    height: 45,
                    width: double.maxFinite,
                    margin:
                        const EdgeInsets.only(left: 10.0, top: 15, right: 10),
                    child: TextField(
                      controller: petname,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.black87),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: MyColors.primaryColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter Pet Name",
                        hintStyle: TextStyle(fontSize: 14),
                        labelText: "Pet Name",
                        contentPadding: const EdgeInsets.only(
                            left: 10, top: 10, right: 0, bottom: 0),
                        labelStyle: TextStyle(color: MyColors.primaryColor),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 50,
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.black87, width: 0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12.0, right: 8),
                                child: DropDownTextField(
                                  enableSearch: false,
                                  searchShowCursor: true,
                                  clearOption: true,
                                  keyboardType: TextInputType.text,
                                  autovalidateMode: AutovalidateMode.always,
                                  clearIconProperty:
                                      IconProperty(color: Colors.black),
                                  searchDecoration: const InputDecoration(
                                      hintText: "search  here"),
                                  dropDownList: categorylistdata(),
                                  onChanged: (val) {
                                    setState(() {
                                      _categoryid = val.value;
                                      BreedtypeData();
                                      showdialog(context);
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
                                child: const Text('Category',
                                    style: TextStyle(
                                        color: MyColors.primaryColor))),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 50,
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border:
                                    Border.all(color: Colors.black87, width: 0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12.0, right: 8),
                                child: DropDownTextField(
                                  enableSearch: true,
                                  searchShowCursor: true,
                                  clearOption: true,
                                  keyboardType: TextInputType.text,
                                  autovalidateMode: AutovalidateMode.always,
                                  clearIconProperty:
                                      IconProperty(color: Colors.black),
                                  searchDecoration: const InputDecoration(
                                      hintText: "search  here"),
                                  dropDownList: breedlistdata(),
                                  onChanged: (val) {
                                    _breedid = val.value;
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
                                child: const Text('Breed Name',
                                    style: TextStyle(
                                        color: MyColors.primaryColor))),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                                            photo1 = true;
                                            photo2 = false;
                                            photo3 = false;
                                            photo4 = false;
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
                                            photo1 = true;
                                            photo2 = false;
                                            photo3 = false;
                                            photo4 = false;
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
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: photo1image != null
                                              ? FileImage(
                                                  File(photo1image!.path),
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
                            Text("Photo1",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
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
                                            photo1 = false;
                                            photo2 = true;
                                            photo3 = false;
                                            photo4 = false;
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
                                            photo1 = false;
                                            photo2 = true;
                                            photo3 = false;
                                            photo4 = false;
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
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: photo2image != null
                                              ? FileImage(
                                                  File(photo2image!.path),
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
                            Text("Photo2",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
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
                                            photo1 = false;
                                            photo2 = false;
                                            photo3 = true;
                                            photo4 = false;
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
                                            photo1 = false;
                                            photo2 = false;
                                            photo3 = true;
                                            photo4 = false;
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
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: photo3image != null
                                              ? FileImage(
                                                  File(photo3image!.path),
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
                            Text("Photo3",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
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
                                            photo1 = false;
                                            photo2 = false;
                                            photo3 = false;
                                            photo4 = true;
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
                                            photo1 = false;
                                            photo2 = false;
                                            photo3 = false;
                                            photo4 = true;
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
                                      MediaQuery.of(context).size.width * 0.45,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: photo4image != null
                                              ? FileImage(
                                                  File(photo4image!.path),
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
                            Text("Photo4",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
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
                      height: 45,
                      child: AnimatedButton(
                        borderRadius: BorderRadius.circular(10.0),
                        width: MediaQuery.of(context).size.width * 0.60,
                        color: MyColors.primaryColor,
                        pressEvent: () async {
                          if (complainername.text.isEmpty) {
                            AnimatedToast("Please Enter Name of Complainer");
                          } else if (AddreetypeValue == "Village" &&
                              sectorid.isEmpty) {
                            AnimatedToast("Please Select Sector Name");
                          } else if (AddreetypeValue == "Village" &&
                              villageid.isEmpty) {
                            AnimatedToast("Please Select Village Name");
                          } else if (AddreetypeValue == "Village" &&
                              block.text.isEmpty) {
                            AnimatedToast("Please Enter Block Name");
                          } else if (AddreetypeValue == "Village" &&
                              landmark.text.isEmpty) {
                            AnimatedToast("Please Enter Landmark");
                          } else if (AddreetypeValue == "Residence" &&
                              sectorid.isEmpty) {
                            AnimatedToast("Please Select Sector Name");
                          } else if (AddreetypeValue == "Residence" &&
                              houseno.text.isEmpty) {
                            AnimatedToast(
                                "Please Enter House/Flat/Plot Number");
                          } else if (AddreetypeValue == "Residence" &&
                              streetno.text.isEmpty) {
                            AnimatedToast("Please Enter Street Number");
                          } else if (AddreetypeValue == "Residence" &&
                              block.text.isEmpty) {
                            AnimatedToast("Please Enter Block Name");
                          } else if (AddreetypeValue == "Residence" &&
                              landmark.text.isEmpty) {
                            AnimatedToast("Please Enter landmark");
                          } else if (AddreetypeValue == "High-Rise Society" &&
                              sectorid.isEmpty) {
                            AnimatedToast("Please Select Sector Name");
                          } else if (AddreetypeValue == "High-Rise Society" &&
                              societyid.isEmpty) {
                            AnimatedToast("Please Select Society Name");
                          } else if (AddreetypeValue == "High-Rise Society" &&
                              towernumber.text.isEmpty) {
                            AnimatedToast("Please Enter Tower Number");
                          } else if (AddreetypeValue == "High-Rise Society" &&
                              flatnumber.text.isEmpty) {
                            AnimatedToast("Please Enter Flat Number");
                          } else if (addressline.text.isEmpty) {
                            AnimatedToast("Please Enter Address Line 1");
                          } else if (pincode.text.isEmpty ||
                              pincode.text.length != 6) {
                            AnimatedToast("Please Enter valid Pin code");
                          } else if (reason.text.isEmpty) {
                            AnimatedToast("Please Enter Reason");
                          } else if (deatilsofcomplainer.text.isEmpty) {
                            AnimatedToast("Please Enter Details of Complainer");
                          } else if (ownername.text.isEmpty) {
                            AnimatedToast("Please Enter Owner Name");
                          } else if (petname.text.isEmpty) {
                            AnimatedToast("Please Enter Pet Name");
                          } else if (_categoryid.isEmpty) {
                            AnimatedToast("Please Select Category");
                          } else if (_breedid.isEmpty) {
                            AnimatedToast("Please Select Breed Name");
                          } else if (photo1image == null) {
                            AnimatedToast("Please Upload Photo1");
                          } else if (photo2image == null) {
                            AnimatedToast("Please Upload Photo2");
                          } else if (photo3image == null) {
                            AnimatedToast("Please Upload Photo3");
                          } else if (photo4image == null) {
                            AnimatedToast("Please Upload Photo4");
                          } else {
                            showdialog(context);
                            RegisterComplaintAPI();
                          }
                        },
                        text: 'Submit',
                      ),
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
        position: StyledToastPosition(align: Alignment.topCenter, offset: 57),
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.elasticIn);
  }

  Future<List?> CategoryData() async {
    categorylist?.clear();
    http.Response response = await GetAppCategory();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categorylist = jsonData['response'];
      });
    } else {
      AnimatedToast("Some error please try again");
    }
  }

  Future<http.Response> GetAppCategory() {
    return http.get(
      Uri.parse(ROOT + AllCategry),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void BreedtypeData() async {
    breedlist?.clear();
    http.Response response = await GetBreedType();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        breedlist = jsonData['response'];
      });
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      AnimatedToast("Some error please try again");
    }
  }

  Future<http.Response> GetBreedType() {
    return http.get(
      Uri.parse(ROOT + BreedType + _categoryid.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void GetVillageData() async {
    http.Response response = await GetVillage();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        villagelist = jsonData['response'];
      });
    } else {
      AnimatedToast("Some error please try again");
    }
  }

  Future<http.Response> GetVillage() {
    return http.get(
      Uri.parse(ROOT + getAllVillage),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void GetSectorData() async {
    http.Response response = await GetSector();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        sectorlist = jsonData['response'];
      });
    } else {
      AnimatedToast("Some error please try again");
    }
  }

  Future<http.Response> GetSector() {
    return http.get(
      Uri.parse(ROOT + AllSector),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void GetScoietyData() async {
    http.Response response = await GetScoiety();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        scoietylist = jsonData['response'];
      });
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      AnimatedToast("Some error please try again");
    }
  }

  Future<http.Response> GetScoiety() {
    return http.get(
      Uri.parse(ROOT + AllScoicty),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
    );
  }

  void RegisterComplaintAPI() async {
    http.Response response = await registrationform(
      pincode.text.toString(),
      landmark.text.toString(),
      addressline.text.toString(),
      flatnumber.text.toString(),
      towernumber.text.toString(),
      sectorid,
      societyid,
      _breedid,
      AddreetypeValue,
      _categoryid,
      villageid,
      deatilsofcomplainer.text.toString(),
      reason.text.toString(),
      block.text.toString(),
      petname.text.toString(),
      ownername.text.toString(),
      _categoryid,
      _breedid,
      complainername.text.toString(),
    );
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      complaintId = data["response"]["complaintId"];
      uploadImage(photo1image!.path, photo2image!.path, photo3image!.path,
          photo4image!.path);
    } else {
      AnimatedToast("Some error . Please try again?");
    }
  }

  Future<http.Response> registrationform(
    String pincode,
    String landmark,
    String addressLine1,
    String flatNumber,
    String townNumber,
    String sectorNumber,
    String societyNumber,
    String breedId,
    String addressType,
    String catId,
    String villageId,
    String detailsOfComplainer,
    String reason,
    String block,
    String petName,
    String ownerName,
    String petType,
    String breedType,
    String complainerName,
  ) {
    return http.post(
      Uri.parse(ROOT + ComplaintRegister),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(<String, String>{
        'pincode': pincode,
        'landmark': landmark,
        'addressLine1': addressLine1,
        'flatNumber': flatNumber,
        'townNumber': townNumber,
        'sectorNumber': sectorNumber,
        'societyNumber': societyNumber,
        'breedId': breedId,
        'addressType': addressType,
        'catId': catId,
        'villageId': villageId,
        'detailsOfComplainer': detailsOfComplainer,
        'reason': reason,
        'block': block,
        'petName': petName,
        'ownerName': ownerName,
        'petType': petType,
        'breedType': breedType,
        'complainerName': complainerName,
      }),
    );
  }

  Future<String> uploadImage(filename1, filename2, filename3, filename4) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(ROOT + ComplaintDocument));
    request.fields['complaintId'] = complaintId;
    request.files.add(await http.MultipartFile.fromPath('file1', filename1));
    request.files.add(await http.MultipartFile.fromPath('file2', filename2));
    request.files.add(await http.MultipartFile.fromPath('file3', filename3));
    request.files.add(await http.MultipartFile.fromPath('file4', filename4));
    var response = await request.send();
    var result = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      AwesomeDialog(
          context: context,
          padding: const EdgeInsets.all(8.0),
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          dismissOnTouchOutside: false,
          animType: AnimType.bottomSlide,
          title: 'NAPR',
          desc:
              'Dear Customer ,Your Complaint has been captured successfully. Complaint Number is $complaintId',
          btnOkOnPress: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }).show();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      AwesomeDialog(
              context: context,
              padding: const EdgeInsets.all(8.0),
              headerAnimationLoop: false,
              dismissOnTouchOutside: false,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'NAPR',
              desc: 'Sorry ! Some issues please try again',
              btnOkOnPress: () {})
          .show();
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
