import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
// import '../../thems.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import '../../Webview.dart';
import '../../loginscreen.dart';
import '../../thems.dart';
import 'main_screen.dart';

class AdminPanelPage extends StatefulWidget {
  @override
  AdminPanelPageState createState() => new AdminPanelPageState();
}

class AdminPanelPageState extends State<AdminPanelPage> {
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
              Navigator.pop(context, MaterialPageRoute(builder: (context)=>HomePage()));
            },
          ),
          title: const Text('Pending Pets',
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
                  Text('Privacy Policy',style: TextStyle(fontSize: 10),),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.person),
                    Text('Logout',style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            )
          ],
        ),
        backgroundColor: MyColors.whiteColor,
        body: Container(
          margin: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.45,
                      //margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter Mobile Number",
                          labelText: "Mobile Number",
                          labelStyle: const TextStyle(color: MyColors.primaryColor),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.45,
                      //margin: const EdgeInsets.all(8.0),
                      child:AnimatedButton(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person_search,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Search',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {

                        },
                        shadowDegree: ShadowDegree.light,
                        color: MyColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                // Visibility(
                //   visible: true,
                //   child: CardListSkeleton(
                //     isCircularImage: true,
                //     isBottomLinesActive: true,
                //     length: 1,
                //   ),
                // )
              ],
            ),
          ),
        ),
    );
  }
}
