import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesHelper {
  void setStringInPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("string", "This is String").then(
          (value) => print(value),
    );
  }

  void setIntInPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setInt("int", 1).then(
          (value) => print(value),
    );
  }

  void setDoubleInPrefrennces() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setDouble("double", 1.01).then(
          (value) => print(value),
    );
  }

  void setBoolInPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setBool("bool", true).then(
          (value) => print(value),
    );
  }

  void setListInPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.setStringList(
      "list",
      <String>["StringList1", "StringList2", "StringList3"],
    ).then(
          (value) => print(value),
    );
  }

  void getStringFromPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    String? value = _prefs.getString("string");

    print(value);
  }

  void getIntFromPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    int? intValue = _prefs.getInt('int');

    print(intValue);
  }

  void getDoubleFromPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    double? doubleValue = _prefs.getDouble('double');

    print(doubleValue);
  }

  void getBoolFromPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    bool? boolValue = _prefs.getBool('bool');

    print(boolValue);
  }

  void getListFromPrefrences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<String>? list = _prefs.getStringList('list');

    print(list);
  }

  void removeData(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    await _prefs.remove(key).then((value) => print(value));
  }
}