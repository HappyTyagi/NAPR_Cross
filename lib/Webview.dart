import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import '../../src/pages/main_screen.dart';
import '../../thems.dart';


class Privacy_Policy extends StatefulWidget {
  const Privacy_Policy({super.key});

  @override
  Privacy_PolicyState createState() => Privacy_PolicyState();
}

class Privacy_PolicyState extends State<Privacy_Policy> {
  @override
  void initState() {
    super.initState();
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
        title: const Text('Privacy Policy',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 16.0,
                color: MyColors.whiteColor)),
      ),
      body: const WebView(
        initialUrl: 'http://petregistration.mynoida.co.in/privacy-policy',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}