import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../../DetailScreen.dart';
import '../../easy_permission_validator.dart';
import '../../permission.dart';
import '../../thems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../HashService.dart';
import '../../SuperEasyPermissionsMain.dart';
import '../../Webview.dart';
import '../../api.dart';
import 'package:group_radio_button/group_radio_button.dart';
import '../../custom_toast_content_widget.dart';
import '../../loading.dart';
import 'ServerError.dart';
import 'SettingPage.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';

class RenewalPetPage extends StatefulWidget {
  String formId;

  RenewalPetPage(this.formId);

  @override
  RenewalPetPageState createState() => new RenewalPetPageState();
}

class RenewalPetPageState extends State<RenewalPetPage>
    implements PayUCheckoutProProtocol {
  TextEditingController vaccinationdate = TextEditingController();
  TextEditingController vaccinationnextdate = TextEditingController();
  TextEditingController petname = TextEditingController();
  TextEditingController houseno = TextEditingController();
  TextEditingController towernumber = TextEditingController();
  TextEditingController addressline = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController block = TextEditingController();
  TextEditingController streetno = TextEditingController();
  TextEditingController flatnumber = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController ownername = TextEditingController();
  TextEditingController ownermobileno = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController breedname = TextEditingController();
  String _filePermission = 'Not Enabled';
  late bool camerapermission;
  late bool medialibpermission;
  late bool photopermission;
  late bool storagepermission;

  var CreaterID = "";
  var isNeutering = "";
  var Token = "";
  var renewalpetdata;

  //var formId = "";
  var _breedid = "";
  var _categoryid = "";
  var sectorid = "";
  var societyid = "";
  var villageid = "";
  var merchantkey = "";
  var PhoneNumber = "";
  var UserName = "";
  String _date = 'Please Select Date';
  final List<String> items = [
    'O Year',
    '1 Year',
    '2 Year',
    '3 Year',
    '4 Year',
    '5 Year',
    '6 Year',
    '7 Year',
    '8 Year',
    '9 Year',
    '10 Year',
    '11 Year',
    '12 Year',
    '13 Year',
    '14 Year',
    '15 Year',
    '16 Year',
    '17 Year',
    '18 Year',
    '19 Year',
    '20 Year',
    '21 Year',
    '22 Year',
  ];
  final List<String> items1 = [
    'O Month',
    '1 Month',
    '2 Month',
    '3 Month',
    '4 Month',
    '5 Month',
    '6 Month',
    '7 Month',
    '8 Month',
    '9 Month',
    '10 Month',
    '11 Month',
  ];
  late DropDownValueModel dropp;
  late PayUCheckoutProFlutter _checkoutPro;
  static String mobilenumber = "";

  static String ownerpayname = "";
  static String amount = "";
  static String formId = "";

  //static String orderid = DateTime.now().millisecondsSinceEpoch.toString();
  static String docId = "";
  static String orderid = "";
  String? dogageyear;
  String? dogagemonth;
  static const merchantKey = "4gcXBD"; // Add you Merchant Key
  static const iosSurl = "https://payu.herokuapp.com/success";
  static const iosFurl = "https://payu.herokuapp.com/failure";
  static const androidSurl = "https://payu.herokuapp.com/success";
  static const androidFurl = "https://payu.herokuapp.com/failure";

  String? selectedValue2;
  String _GenderGroupValue = "";
  String IsNeuteringValue = "";
  String AddreetypeValue = "";
  final _statusHorizontal = ["Male", "Female"];
  final IsNeuteringHorizontal = ["Yes", "No"];
  final _status = ["Village", "Residence", "High-Rise Society"];
  late SharedPreferences prefs;
  int? myVar = 1;
  late Map renewaldata;
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  String _result = '';
  bool loading = false;

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

  bool petphoto1 = false;
  bool petphoto2 = false;
  bool petwithowner = false;
  bool addressproof = false;
  bool vaccinationbook = false;
  bool vaccinationbookoptional = false;

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
  bool isneutering = false;
  bool dogyear = false;
  bool dogmonth = false;

  File? _petphoto1image;
  File? _petphotoimage2;
  File? _petwithownerimage;
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

    // final image = await ImagePicker().pickImage(source: ImageSource.camera);
    // if (image == null) return;
    final imageTemporery = File(image.path);
    setState(() {
      if (petphoto1) {
        this._petphoto1image = imageTemporery;
      } else if (petwithowner) {
        this._petwithownerimage = imageTemporery;
      } else if (petphoto2) {
        this._petphotoimage2 = imageTemporery;
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
  void dispose() {
    super.dispose();
    //_cnt.dispose();
  }

  @override
  void initState() {
    super.initState();
    permisssion();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      showdialog(context);
    });
    _checkoutPro = PayUCheckoutProFlutter(this);
    //_cnt = SingleValueDropDownController();
    vaccinationdate = TextEditingController(text: _date);
    vaccinationnextdate = TextEditingController(text: _date);
    retrieve();
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

  retrieve() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Token = prefs.getString('TokenNo')!;
      CreaterID = prefs.getString('CreaterID')!;
      UserName = prefs.getString('UserName')!;
      PhoneNumber = prefs.getString('PhoneNumber')!;
      ownermobileno = TextEditingController(text: PhoneNumber);
      ownername = TextEditingController(text: UserName);
      GetUserData();
      // CategoryData();
      GetVillageData();
      GetSectorData();
      GetScoietyData();
    });
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
        title: const Text('Renewal Pet Certificate',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 16.0,
                color: MyColors.whiteColor)),
      ),
      backgroundColor: MyColors.whiteColor,
      body: !loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: SingleChildScrollView(
                //physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      width: double.maxFinite,
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        enabled: false,
                        controller: petname,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Pet Name",
                          labelText: "Pet Name",
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
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        enabled: false,
                        controller: category,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: "Pet Category",
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
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        enabled: false,
                        controller: breedname,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: "Breed Name",
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
                      width: double.maxFinite,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Age",
                              style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Select Year',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: items
                                      .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  value: dogageyear,
                                  onChanged: (value) {
                                    setState(() {
                                      dogageyear = value;
                                      if ((dogagemonth.toString() == "O Month" ||
                                          dogagemonth.toString() == "1 Month" ||
                                          dogagemonth.toString() == "2 Month" ||
                                          dogagemonth.toString() == "3 Month" ||
                                          dogagemonth.toString() == "4 Month" ||
                                          dogagemonth.toString() == "5 Month" ||
                                          dogagemonth.toString() == "6 Month") &&
                                          dogageyear.toString() == "O Year") {
                                        isneutering = false;
                                        IsNeuteringValue = "";
                                        dogmonth = false;
                                        isNeutering = "";
                                      } else {
                                        isNeutering = "";
                                        isneutering = true;
                                        dogyear = true;
                                      }
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 45,
                                    width: 160,
                                    padding: const EdgeInsets.only(left: 14, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                      color: Colors.white,
                                    ),
                                    elevation: 2,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                    iconSize: 14,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      width: 200,
                                      padding: null,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                      ),
                                      elevation: 8,
                                      offset: const Offset(-20, 0),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness: MaterialStateProperty.all(6),
                                        thumbVisibility: MaterialStateProperty.all(true),
                                      )),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,

                                    hint: Text(
                                      'Select Month',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: items1
                                        .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    value: dogagemonth,
                                    onChanged: (value) {
                                      setState(() {
                                        dogagemonth = value;
                                        if ((dogagemonth.toString() == "O Month" ||
                                            dogagemonth.toString() == "1 Month" ||
                                            dogagemonth.toString() == "2 Month" ||
                                            dogagemonth.toString() == "3 Month" ||
                                            dogagemonth.toString() == "4 Month" ||
                                            dogagemonth.toString() == "5 Month" ||
                                            dogagemonth.toString() == "6 Month") &&
                                            dogageyear.toString() == "O Year") {
                                          isneutering = false;
                                          IsNeuteringValue = "";
                                          dogmonth = false;
                                          isNeutering = "";
                                        } else {
                                          isNeutering = "";
                                          isneutering = true;
                                          dogmonth = true;
                                        }
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: 160,
                                      padding: const EdgeInsets.only(left: 14, right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.black26,
                                        ),
                                        color: Colors.white,
                                      ),
                                      elevation: 2,
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      iconSize: 14,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.grey,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        width: 200,
                                        padding: null,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(14),
                                          color: Colors.white,
                                        ),
                                        elevation: 8,
                                        offset: const Offset(-20, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness: MaterialStateProperty.all(6),
                                          thumbVisibility: MaterialStateProperty.all(true),
                                        )),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),





                    const SizedBox(
                      height: 6,
                    ),
                    Visibility(
                      visible: isneutering,
                      child: Container(
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 10),
                              child: Text("Neutering Status",
                                  style: GoogleFonts.lato(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal)),
                            ),
                            RadioGroup<String>.builder(
                              direction: Axis.horizontal,
                              groupValue: IsNeuteringValue,
                              horizontalAlignment:
                                  MainAxisAlignment.spaceAround,
                              onChanged: (value) => setState(() {
                                IsNeuteringValue = value ?? '';
                                IsNeuteringValue == "Yes"
                                    ? isNeutering = "1"
                                    : IsNeuteringValue == "No"
                                        ? isNeutering = "0"
                                        : isNeutering == "";
                              }),
                              items: IsNeuteringHorizontal,
                              fillColor: MyColors.primaryColor,
                              textStyle: const TextStyle(
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                            child: Text("Gender",
                                style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal)),
                          ),
                          RadioGroup<String>.builder(
                            direction: Axis.horizontal,
                            groupValue: _GenderGroupValue,
                            horizontalAlignment: MainAxisAlignment.spaceAround,
                            onChanged: (value) => setState(() {
                              // _GenderGroupValue = value ?? '';
                            }),
                            items: _statusHorizontal,
                            fillColor: MyColors.primaryColor,
                            textStyle: const TextStyle(
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
                              hintText: "Enter Vaccination Date",
                              labelText: "Vaccination Date",
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
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 1, 1),
                                lastDate: DateTime.now(),
                                //initialDatePickerMode: DatePickerMode.year,
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData(
                                      primaryColor: MyColors.primaryColor,
                                      // accentColor: MyColors.primaryColor,
                                      colorScheme: const ColorScheme.light(
                                          primary: MyColors.primaryColor),
                                      buttonBarTheme: const ButtonBarThemeData(
                                        buttonTextTheme: ButtonTextTheme.accent,
                                      ),
                                    ),
                                    child: child ?? Container(),
                                  );
                                },
                              );
                              if (date != null) {
                                var formatter = new DateFormat('MM/dd/yyyy');
                                vaccinationdate.text = formatter.format(date);
                                //_pickDateNextController.text = formatter.format(date);
                                //var datee = new DateTime(formatter);
                                var newDate = new DateTime(
                                    date.year + 1, date.month, date.day);
                                vaccinationnextdate.text =
                                    formatter.format(newDate);
                              }
                            },
                          ),
                        ],
                      ),
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
                              hintText: "Enter Vaccination Next Date",
                              labelText: "Vaccination Next Date",
                              labelStyle:
                                  TextStyle(color: MyColors.primaryColor),
                              contentPadding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 0, bottom: 0),
                              alignLabelWithHint: false,
                              filled: true,
                            ),
                            controller: vaccinationnextdate,
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
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
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // _permissionWithCustomPopup();
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
                      height: 45,
                      width: double.maxFinite,
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        enabled: false,
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
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Owner Name",
                          labelText: "Owner Name",
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
                      height: 65,
                      width: double.maxFinite,
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        enabled: false,
                        controller: ownermobileno,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Colors.black87),
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 10, top: 10, right: 0, bottom: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Owner Mobile Number",
                          labelText: "Owner Mobile Number",
                          labelStyle: TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
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
                              } else if (AddreetypeValue ==
                                  "High-Rise Society") {
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
                              bottom: 34,
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
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 15, right: 10),
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
                          keyboardType: TextInputType.text,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
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
                                bottom: 34,
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
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 15, right: 10),
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
                          keyboardType: TextInputType.text,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
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
                                bottom: 34,
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
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 15, right: 10),
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
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: block_hide,
                      child: Container(
                        height: 45,
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 15, right: 10),
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
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 15, right: 10),
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
                          keyboardType: TextInputType.text,
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
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 15, right: 10),
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
                          keyboardType: TextInputType.text,
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
                        margin: const EdgeInsets.only(
                            left: 10.0, top: 15, right: 10),
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
                          textCapitalization: TextCapitalization.words,
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
                    SizedBox(height: 15),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  var imageurl =
                                      renewalpetdata["mainDocFormResponse"]['upload_id_url'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailScreen(imageurl)));
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
                                            image: NetworkImage(
                                                "http://petregistration.mynoida.co.in/${renewalpetdata["mainDocFormResponse"]['upload_id_url']}"),
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
                                  var imageurl =
                                      renewalpetdata["mainDocFormResponse"]
                                          ['upload_photo_url'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailScreen(imageurl)));
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
                                            image: NetworkImage(
                                                "http://petregistration.mynoida.co.in/${renewalpetdata["mainDocFormResponse"]['upload_photo_url']}"),
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
                                  var imageurl =
                                      renewalpetdata["mainDocFormResponse"]
                                          ['upload_sign_url'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailScreen(imageurl)));
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
                                            image: NetworkImage(
                                                "http://petregistration.mynoida.co.in/${renewalpetdata["mainDocFormResponse"]['upload_sign_url']}"),
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
                                            image: _vaccinationimageoptionl !=
                                                    null
                                                ? FileImage(
                                                    File(
                                                        _vaccinationimageoptionl!
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
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 40,
                        child: AnimatedButton(
                          width: MediaQuery.of(context).size.width * 0.60,
                          text: 'Proceed to Payment',
                          borderRadius: BorderRadius.circular(10.0),
                          color: MyColors.primaryColor,
                          pressEvent: () async {
                            if (petname.text.isEmpty) {
                              AnimatedToast("Please Enter Pet Name");
                            } else if (dogageyear == null ||
                                dogagemonth == null) {
                              AnimatedToast("Please Select Pet Age");
                            } else if ((isneutering == true || dogmonth == true) &&
                                isNeutering == "") {
                              AnimatedToast("Please Select Neutering Status");
                            } else if (vaccinationdate.text.toString() ==
                                "Please Select Date") {
                              AnimatedToast("Please Select Vaccination Date");
                            } else if (_petphoto1image == null) {
                              AnimatedToast("Please Upload Pet Photo1");
                            } else if (_petwithownerimage == null) {
                              AnimatedToast(
                                  "Please Upload Pet With Owner Photo");
                            } else if (_petphotoimage2 == null) {
                              AnimatedToast("Please Upload Pet Photo2");
                            } else if (AddreetypeValue == "") {
                              AnimatedToast("Please Select Address Type");
                            } else if (AddreetypeValue == "Village" &&
                                sectorid.toString().isEmpty) {
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
                            } else if (pincode.text.isEmpty || pincode.text.length != 6) {
                              AnimatedToast("Please Enter valid Pin code");
                            } else if (_addressproofimage == null) {
                              AnimatedToast("Please Upload Owner Address Proof");
                            } else if (_vaccinationimage == null) {
                              AnimatedToast("Please Upload Pet Vaccination");
                            } else {
                              showdialog(context);
                              RenewalFormAPI();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
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

  void GetUserData() async {
    try {
      http.Response response = await getuserdata();
      print(response.body);
      if (response.statusCode == 200) {
        renewaldata = jsonDecode(response.body);
        setState(() {
          renewalpetdata = renewaldata["response"];
          petname = TextEditingController(text: renewalpetdata['nickName']);
          category = TextEditingController(text: renewalpetdata['petType']);
          breedname = TextEditingController(text: renewalpetdata['breedName']);
          pincode = TextEditingController(text: renewalpetdata['pincode']);
          block = TextEditingController(text: renewalpetdata['block']);
          landmark = TextEditingController(text: renewalpetdata['landmark']);
          addressline = TextEditingController(text: renewalpetdata['addLine1']);
          _GenderGroupValue = renewalpetdata['sex'];
          // AddreetypeValue = renewalpetdata['addressType'];
          sectorid = renewalpetdata['addressType'];
        });
        Navigator.of(context, rootNavigator: true).pop();
        loading = true;
      } else {
        loading = true;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ServerError(),
          ),
        );
      }
    } catch (exception) {
      AnimatedToast("exception.toString()");
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

  Future<List?> CategoryData() async {
    http.Response response = await GetAppCategory();
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categorylist = jsonData['response'];
        merchantkey = jsonData['key'];
      });
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      AnimatedToast("Category Not Found");
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
      AnimatedToast("Breed Not Found");
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
      AnimatedToast("Village Not Found");
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
      AnimatedToast("Sector Not Found");
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
    } else {
      AnimatedToast("Society Not Found");
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

  void paymentinfo(String txnData) async {
    try {
      http.Response response = await paymentinfodata(formId, txnData);
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
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
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
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
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

  void RenewalFormAPI() async {
    http.Response response = await renewalform(
        widget.formId,
        addressline.text.toString(),
        dogageyear.toString() + " " + dogagemonth.toString(),
        vaccinationdate.text.toString(),
        vaccinationnextdate.text.toString(),
        addressline.text.toString(),
        societyid,
        sectorid,
        villageid,
        towernumber.text.toString(),
        streetno.text.toString(),
        pincode.text.toString(),
        landmark.text.toString(),
        flatnumber.text.toString(),
        block.text.toString(),
        AddreetypeValue,
        isNeutering);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      formId = data["response"]["formId"];
      orderid = data["response"]["orderId"];
      docId = data["response"]["docId"];
      print("docId:-" + docId);
      uploadImage(
          _petphoto1image!.path,
          _petwithownerimage!.path,
          _petphotoimage2!.path,
          _addressproofimage!.path,
          _vaccinationimage!.path);
    } else if (response.statusCode == 208) {
      Navigator.of(context, rootNavigator: true).pop();
      AwesomeDialog(
          context: context,
          padding: const EdgeInsets.all(8.0),
          headerAnimationLoop: false,
          dismissOnTouchOutside: false,
          dialogType: DialogType.warning,
          animType: AnimType.bottomSlide,
          btnOkColor: MyColors.yellow,
          title: 'Already Exit',
          desc:
              'Your Pet is already exist . please check in Registration Status or Verified Pets',
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ServerError(),
        ),
      );
    }
  }

  Future<http.Response> renewalform(
    String formId,
    String address,
    String dob,
    String rabbiesDate,
    String nextRabbiesDate,
    String addLine1,
    String manageSocietyId,
    String sectorId,
    String villageId,
    String towerNo,
    String streetNo,
    String pincode,
    String landmark,
    String flatNo,
    String block,
    String addressType,
    String isNeutering,
  ) {
    return http.post(
      Uri.parse(ROOT + RenewalMainForm),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Token': Token,
      },
      body: jsonEncode(<String, String>{
        'formId': formId,
        'address': address,
        'dob': dob,
        'nextRabbiesDate': nextRabbiesDate,
        'rabbiesDate': rabbiesDate,
        'addLine1': addLine1,
        'manageSocietyId': manageSocietyId,
        'sectorId': sectorId,
        'villageId': villageId,
        'towerNo': towerNo,
        'streetNo': streetNo,
        'pincode': pincode,
        'landmark': landmark,
        'flatNo': flatNo,
        'block': block,
        'addressType': addressType,
        'isNeutering': isNeutering,
      }),
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

  Future<String> uploadImage(
      filename1, filename2, filename3, filename7, filename8) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(ROOT + UploadPhotoRenewal));
    request.fields['formId'] = formId;
    request.fields['docId'] = docId;
    request.files.add(await http.MultipartFile.fromPath('pet1', filename1));
    request.files.add(await http.MultipartFile.fromPath('pet2', filename2));
    request.files.add(await http.MultipartFile.fromPath('pet3', filename3));
    request.files.add(await http.MultipartFile.fromPath('file7', filename7));
    request.files.add(await http.MultipartFile.fromPath('file8', filename8));
    var response = await request.send();
    var result = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      var datata = jsonDecode(result);
      mobilenumber = ownermobileno.text.toString();
      ownerpayname = ownername.text.toString();
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
            desc: 'Your Pet is Register Successfully. Now It s under Verification. It will be take time 1 or 2 days.',
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

  @override
  onPaymentSuccess(dynamic response) {
    paymentinfo(response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    paymentinfo1(response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
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
      PayUCheckoutProConfigKeys.showCbToolbar: "#FF97144d",
      PayUCheckoutProConfigKeys.merchantName: "Noida Authority",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
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
