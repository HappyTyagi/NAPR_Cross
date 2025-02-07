import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'BookVaccinationAppointmentStatus.dart';
import 'CertificateRenewPage.dart';
import 'ComplaintHistoryPage.dart';
import 'NeuteringStatusPage.dart';
import 'RaiseComplaintPage.dart';
import 'RegisterPendingPetPage.dart';
import 'RegisterPetPage.dart';
import 'RegistrationStatusPage.dart';
import 'RenewalPetStatusPage.dart';
import 'VaccinationCenterPage.dart';
import 'VaccinationPetStatusPage.dart';

class GridDashboard extends StatefulWidget {
  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  Items item1 = Items(
      title: "New Registration",
      img: "assets/images/home_add.png"
  );

  Items item2 = Items(
    title: "Renewal Pets",
    img: "assets/images/admin_panel.png",
  );

  Items item3 = Items(
    title: "Registration Status",
    img: "assets/images/home_status.png",
  );

  Items item4 = Items(
    title: "Verify Pets",
    img: "assets/images/home_dog.png",
  );

  Items item5 = Items(
    title: "Vaccination Status",
    img: "assets/images/home_raise.png",
  );

  Items item6 = Items(
    title: "Book Vaccination",
    img: "assets/images/home_history.png",
  );
  Items item7 = Items(
    title: "Check Certificate",
    img: "assets/images/home_status.png",
  );
  Items item8 = Items(
    title: "Vaccination Center",
    img: "assets/images/home_renew.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [
      item1,
      item2,
      item3,
      item4,
      item5,
      item6,
      item7,
      item8,
    ];
    var color = 0xffffff;
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.3,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: myList.map((data) {
          return Container(
            decoration: BoxDecoration(
              color: Color(color),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (myList.indexOf(data).toString().contains("0")) {

                    Navigator.push(
                        context, MaterialPageRoute(
                            builder: (context) =>
                                const RegisterPendingPetStatusPage()));
                  } else if (myList.indexOf(data).toString().contains("1")) {
                    Navigator.push(
                        context, MaterialPageRoute(
                            builder: (context) => RenewalPetStatusPage()));
                  } else if (myList.indexOf(data).toString().contains("2")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationStatusPage()));
                  } else if (myList.indexOf(data).toString().contains("3")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPetPage()));
                  } else if (myList.indexOf(data).toString().contains("4")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VaccinationPetStatusPage()));
                  } else if (myList.indexOf(data).toString().contains("5")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookvaccinationAppointMentStatus()));
                  } else if (myList.indexOf(data).toString().contains("6")) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CertificateRenewPage()));
                  } else if (myList.indexOf(data).toString().contains("7")) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VaccinationCenterPage()));
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => ComplaintHistoryPage()));
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => NeuteringStatusPage()));
                  }
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(data.img, width: 52),
                    const SizedBox(height: 14),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
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

  Items({required this.title, required this.img});
}
