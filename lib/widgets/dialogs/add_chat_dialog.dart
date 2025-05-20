import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/qr_scan_screen/qr_scan_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

import '../../providers/theme_provider.dart';

class AddChatDialog extends StatefulWidget {
  const AddChatDialog({Key? key}) : super(key: key);

  @override
  State<AddChatDialog> createState() => _AddChatDialogState();
}

class _AddChatDialogState extends State<AddChatDialog> {
  final TextEditingController _courseLinkController = TextEditingController();
  final TextEditingController _courseIDController = TextEditingController();
  bool _isAddingChat = false;

  @override
  void dispose() {
    _courseLinkController.dispose();
    super.dispose();
  }

  Future<void> _scanQRCode() async {
    final String? scannedLink = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QRScanScreen()),
    );

    if (!mounted) return;

    if (scannedLink != null && scannedLink.isNotEmpty) {
      _courseLinkController.text = scannedLink;
    } else {
      // Optional: Show a message if scan was cancelled or no result
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('QR scan cancelled or no data found')),
      // );
    }
  }

  Future<void> _addChat() async {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String courseLink = _courseLinkController.text.trim();

    if (courseLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AddChatDialog.error1'.tr()),
      ));
      return;
    }
    if (HiveUserContactCashingService.getUserContactData().id == null ||
        HiveUserContactCashingService.getUserContactData().id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
            content: Text('AddChatDialog.error2'.tr())),
      );
      return;
    }

    setState(() {
      _isAddingChat = true;
    });

    try {
      if ((await FirebaseFirestore.instance
              .collection('Chats')
              .doc(courseLink)
              .get())
          .exists) {
        DBService.instance.addChatToUser(
            HiveUserContactCashingService.getUserContactData().id, courseLink);
        DBService.instance.addMembersToChat(
          HiveUserContactCashingService.getUserContactData().id.trim(),
          courseLink.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'AddChatDialog.successfully'.tr(args: [courseLink])
            ),
          ),
        );
        Navigator.of(context).pop();
      } else {
        DBService.instance.makeChat(
            courseLink, HiveUserContactCashingService.getUserContactData().id);
        DBService.instance.addChatToUser(
            HiveUserContactCashingService.getUserContactData().id, courseLink);
        DBService.instance.addMembersToChat(
          HiveUserContactCashingService.getUserContactData().id.trim(),
          courseLink.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('AddChatDialog.successfully_created'.tr(args: [courseLink])),
          ),
        );
      }
      // DBService.instance.addChatToUser(
      //     HiveUserContactCashingService.getUserContactData().id, courseLink);
      // DBService.instance.addMembersToChat(
      //   HiveUserContactCashingService.getUserContactData().id.trim(),
      //   courseLink.trim(),
      // );
      dev.log(
          'Attempting to join chat with link: $courseLink for user: ${HiveUserContactCashingService.getUserContactData().id}');

      // --- This is where you call your actual DBService method ---
      // Example: String? chatId = await DBService.instance.joinChatByLink(courseLink, authProvider.user!.uid);

      await Future.delayed(const Duration(seconds: 2)); // Simulate network call
      String? chatId = "simulated_chat_id_for_$courseLink";
      // String? chatId = null; // Simulate failure

      if (!mounted) return;

      if (chatId != null) {
        // Close the dialog on success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
              content: Text('AddChatDialog.failed_to_join').tr() ),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      print('Error joining chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr('AddChatDialog.error', args: ['$e']),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingChat = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    return AlertDialog(
      title:  Text('AddChatDialog.title'.tr(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _courseLinkController,
            decoration:  InputDecoration(hintText: 'AddChatDialog.name_code'.tr()),
            enabled: !_isAddingChat,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white,),
            label:  Text('AddChatDialog.scan_qr'.tr() , style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff2E5077),
              minimumSize: const Size(double.infinity, 36),
            ),
            onPressed: _isAddingChat ? null : _scanQRCode,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child:  Text('AddChatDialog.cancel'.tr() , style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),),
          onPressed: _isAddingChat
              ? null
              : () {
                  Navigator.of(context).pop();
                },
        ),
        TextButton(
          child: _isAddingChat
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              :  Text('AddChatDialog.add'.tr(), style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
          onPressed: _isAddingChat ? null : _addChat,
        ),
      ],
    );
  }
}
