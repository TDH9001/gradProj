import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/orgappbar.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class SpreadSheetResult extends StatelessWidget {
  SpreadSheetResult({super.key, required this.base, required this.result});
  final List<Data?> base;
  final List<Data?> result;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      appBar: Orgappbar(scaffoldKey: scaffoldKey , title: "Data",),
      body: Container(
        height: MediaService.instance.getHeight() * 0.8,
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: base.length,
          itemBuilder: (context, index) {
            return Card(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              elevation: 3,
              shadowColor: Color(0xff769BC6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        base[index]!.value.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xff769BC6)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: Text(
                        result[index]!.value.toString(),
                        style:  TextStyle(fontSize: 12, color: isDarkMode ? Colors.white : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
