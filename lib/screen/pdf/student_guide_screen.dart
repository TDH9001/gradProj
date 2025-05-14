import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class StudentGuideScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  StudentGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Orgappbar(scaffoldKey: scaffoldKey, title: 'Pdf.title'.tr(),),
      body:SfPdfViewer.asset('assets/pdf/student_guide.pdf'),
    );
  }
}
