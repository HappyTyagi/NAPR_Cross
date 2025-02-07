import 'package:flutter/material.dart';
import '../../thems.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreen extends StatefulWidget {
  String imageurl;
  DetailScreen(this.imageurl);


  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final timegap = DateTime.now().difference(pre_backpress);
        final cantExit = timegap >= Duration(seconds: 2);
        pre_backpress = DateTime.now();
        if (cantExit) {
          //show snackbar
          final snack = SnackBar(
            content: Text('Press Back button again to Exit'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          elevation: 0.0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: MyColors.whiteColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Image Details',
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 16.0,
                  color: MyColors.whiteColor)),
        ),
        body: Container(
            child: PhotoView(
              imageProvider: NetworkImage("http://petregistration.mynoida.co.in/"+widget.imageurl),
            )
        ),
      ),
    );
  }
}

//imageProvider: NetworkImage("http://petregistration.mynoida.co.in/"+widget.imageurl),