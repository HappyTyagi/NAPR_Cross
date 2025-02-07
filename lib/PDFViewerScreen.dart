import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';
import '../../thems.dart';


class PDFViewerScreen extends StatefulWidget {
  String pdfurl;

  PDFViewerScreen(this.pdfurl);


  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(
        'http://petregistration.mynoida.co.in/${widget.pdfurl}');
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Card',style: TextStyle(fontSize: 16)),
        backgroundColor: MyColors.primaryColor,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right:15.0),
          //   child: DownloandPdf(
          //     isUseIcon: true,
          //     pdfUrl: 'http://petregistration.mynoida.co.in/${widget.pdfurl}',
          //     fileNames: 'NAPRCertificate.pdf',
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
