import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A widget that displays a QR code for the given data.
class QrCodeDisplayWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  const QrCodeDisplayWidget({
    Key? key,
    required this.data,
    this.size = 200.0,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      gapless: false, // Recommended to be false for better readability
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      // You can embed an image in the center if needed
      // embeddedImage: AssetImage('assets/images/my_logo.png'),
      // embeddedImageStyle: QrEmbeddedImageStyle(
      //   size: Size(40, 40),
      // ),
      errorStateBuilder: (cxt, err) {
        return Center(
          child: Text(
            'Uh oh! Something went wrong...',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

/// Shows a dialog displaying a QR code generated from the given [dataString].
Future<void> showQrCodeDialog(BuildContext context, String dataString, {String title = 'Scan QR Code'}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // User can dismiss by tapping outside
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView( // In case the content is too large
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              QrCodeDisplayWidget(data: dataString),
              SizedBox(height: 16),
              Text(
                'Point your QR scanner at this code.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}