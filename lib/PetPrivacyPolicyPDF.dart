import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';
import 'package:pets/src/pages/SettingPage.dart';
import '../../thems.dart';


class PetPrivacyPolicyPDF extends StatefulWidget {
  String pdfurl;

  PetPrivacyPolicyPDF(this.pdfurl);

  @override
  State<PetPrivacyPolicyPDF> createState() => _PetPrivacyPolicyPDFState();
}

class _PetPrivacyPolicyPDFState extends State<PetPrivacyPolicyPDF> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
    // print("avn"+widget.pdfurl);
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.pdfurl);
    setState(() => _isLoading = false);
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
                MaterialPageRoute(builder: (context) => SettingPage()));
          },
        ),
        title: const Text('Dog Policy',
            style: TextStyle(
                fontFamily: 'Varela',
                fontSize: 16.0,
                color: MyColors.whiteColor)),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right:15.0),
          //   child: DownloandPdf(
          //     isUseIcon: true,
          //     pdfUrl: widget.pdfurl,
          //     fileNames: 'Dog Policy.pdf',
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: document,
                zoomSteps: 1,
              ),
      ),
    );
  }
}
