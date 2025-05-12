import 'package:flutter/material.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/utils/qr_display_utils.dart';

class AddUserQrTab extends StatelessWidget {
  const AddUserQrTab({super.key, required this.chatID});
  final String chatID;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff769BC6), Color(0xffa6c4dd)],
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
            initiallyExpanded: true,
            leading: const Icon(Icons.qr_code, color: Color(0xff2E5077)),
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
                    fontSize: 18,
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
