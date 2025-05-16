import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/services/media_service.dart';

class SpreadSheetResult extends StatelessWidget {
  SpreadSheetResult({super.key, required this.base, required this.result});
  final List<Data?> base;
  final List<Data?> result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaService.instance.getHeight() * 0.8,
      child: ListView.builder(
        itemCount: base.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(4),
            child: Row(
              children: [
                Text(base[index]!.value.toString()),
                Text("  :   "),
                Text(result[index]!.value.toString()),
              ],
            ),
          );
        },
      ),
    ));
  }
}
