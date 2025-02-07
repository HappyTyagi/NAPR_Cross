import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = Items(
      title: "New Registration",
      img: "assets/images/home_add.png");

  Items item2 =  Items(
    title: "Check Certificate",
    img: "assets/images/home_renew.png",
  );
  Items item3 =  Items(
    title: "Registration Status",
    img: "assets/images/home_status.png",
  );
  Items item4 =  Items(
    title: "Verify Pets",
    img: "assets/images/home_dog.png",


  );
  Items item5 =  Items(
    title: "Setting",
    img: "assets/images/home_status.png",
  );
  Items item6 =  Items(
    title: "Admin Panel",
    img: "assets/images/home_status.png",

  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return InkWell(
            // onTap: (){
            //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //     content: Text("card is tapped"),
            //   ));
            //
            // },
            child: Container(
              decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(data.img, width: 82),
                  SizedBox(height: 14),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class Items {
  String title;
  String img;
  Items({required this.title,  required this.img});
}