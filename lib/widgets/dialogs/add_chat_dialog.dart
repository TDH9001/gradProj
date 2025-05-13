import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/screen/qr_scan_screen/qr_scan_screen.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

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
        const SnackBar(content: Text('Course link cannot be empty')),
      );
      return;
    }
    if (HiveUserContactCashingService.getUserContactData().id == null ||
        HiveUserContactCashingService.getUserContactData().id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User not logged in. Please log in and try again.')),
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
          SnackBar(content: Text('Successfully joined chat: $courseLink !')),
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
                  Text('Successfully joined the created chat: $courseLink !')),
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
          const SnackBar(
              content: Text(
                  'Failed to join chat. Link might be invalid or an error occurred.')),
        );
      }
    } on Exception catch (e) {
      if (!mounted) return;
      print('Error joining chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
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
    return AlertDialog(
      title: const Text('Add New Chat'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _courseLinkController,
            decoration: const InputDecoration(hintText: '([name][code])'),
            enabled: !_isAddingChat,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan QR Code'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
            ),
            onPressed: _isAddingChat ? null : _scanQRCode,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
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
              : const Text('Add'),
          onPressed: _isAddingChat ? null : _addChat,
        ),
      ],
    );
  }
}
