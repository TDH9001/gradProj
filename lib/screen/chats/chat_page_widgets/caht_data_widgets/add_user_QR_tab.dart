import 'package:flutter/material.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/utils/qr_display_utils.dart';
import 'package:provider/provider.dart';

import '../../../../providers/theme_provider.dart';

class AddUserQrTab extends StatelessWidget {
  const AddUserQrTab({super.key, required this.chatID});
  final String chatID;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:isDarkMode? [Color(0xff2E5077), Color(0xFF2E3B55)] : [Color(0xff769BC6), Color(0xffa6c4dd)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ExpansionTile(
            initiallyExpanded: false,
            leading:  Icon(Icons.qr_code, color: isDarkMode? Color(0xFF4A739F): Color(0xff2E5077)),
            // elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Text(
                  "chat QR code : $chatID",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,color: Colors.white
                  ),
                ),
              ],
            ),
            children: [
              Center(
                child: QrCodeDisplayWidget(
                  data: chatID,
                  size: MediaService.instance.getWidth() * 0.5,
                ),
              )
            ]),
      ),
    );
  }
}
