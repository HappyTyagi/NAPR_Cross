import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';
import '../../thems.dart';


class PaymentreciptScreen extends StatefulWidget {
  String pdfurl;

  PaymentreciptScreen(this.pdfurl);

  @override
  State<PaymentreciptScreen> createState() => _PaymentreciptScreenState();
}

class _PaymentreciptScreenState extends State<PaymentreciptScreen> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.pdfurl);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Receipt',style: TextStyle(fontSize: 16)),
        backgroundColor: MyColors.primaryColor,
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right:15.0),
          //   child: DownloandPdf(
          //     isUseIcon: true,
          //     pdfUrl:widget.pdfurl,
          //     fileNames: 'Pay_Receipt.pdf',
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
