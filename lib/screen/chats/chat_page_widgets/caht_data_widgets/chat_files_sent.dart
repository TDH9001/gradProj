import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_caht_data_caching_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:universal_file_viewer/universal_file_viewer.dart';

import '../../../../providers/theme_provider.dart';

class ChatFilesSent extends StatefulWidget {
  const ChatFilesSent({super.key, required this.cahtId});
  final String cahtId;

  @override
  State<ChatFilesSent> createState() => _ChatFilesSentState();
}

class _ChatFilesSentState extends State<ChatFilesSent> {
  late Future<List<File>> _validImagesFuture;
  Future<List<File>> getValidMessages() async {
    List<Message> allMessages =
        HiveCahtMessaegsCachingService.getChatData(widget.cahtId);

    List<Message> ImageMessages = allMessages
        .where((element) => element.type == MessageType.file.name)
        .toList();

    List<File> validMessages = [];
    for (int i = 0; i < ImageMessages.length; i++) {
      final result = await ChatFileCachingService.loadCachedFile(
              fileAdress: ImageMessages[i].messageContent, fileType: "files")
          .first;
      //only takes imaegs that are loaded succesfully > not loading
      if (result.isFailed == false &&
          result.file != null &&
          result.isLoading == false) {
        validMessages.add(result.file!);
      }
    }
    return validMessages;
  }

  @override
  void initState() {
    super.initState();
    _validImagesFuture = getValidMessages();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    return SliverToBoxAdapter(
      child: FutureBuilder<List<File>>(
        future: _validImagesFuture,
        builder: (context, snapshot) {
          late List<File> data;
          if (!snapshot.hasData) {
            data = [];
            return const Center(child: CircularProgressIndicator());
          }
          data = snapshot.data!;
          for (int i = 0; i < data.length; i++) {
            print(p.basename(data[0].path));
          }
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
                leading:  Icon(Icons.file_copy, color: isDarkMode? Color(0xFF4A739F): Color(0xff2E5077)),
                // elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Row(
                  children: [
                    Text(
                      'ChatFilesSent.files_Sent'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  ],
                ),
                children: !snapshot.hasData
                    ? [CircularProgressIndicator()]
                    : [
                        SizedBox(
                          height: MediaService.instance.getHeight() * 2 / 3,
                          child: ListView.builder(
                            //  shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  OpenFile.open(data[index].path);
                                },
                                child: Hero(
                                    tag: data[index].toString(),
                                    child: Row(
                                      children: [
                                        Spacer(flex: 1),
                                        Center(
                                          child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              width:
                                                  MediaService.instance.getWidth() *
                                                      0.8,
                                              height: MediaService.instance
                                                      .getHeight() *
                                                  0.3,
                                              child: p.extension(
                                                          data[index].path) ==
                                                      ".xlsx"
                                                  ? Image(
                                                      image: AssetImage(
                                                          'assets/images/xlsx.png'))
                                                  : p.extension(data[index].path) ==
                                                              ".ppt" ||
                                                          p.extension(data[index].path) ==
                                                              ".pptx"
                                                      ? Image(
                                                          image: AssetImage(
                                                              "assets/images/ppt.png"),
                                                        )
                                                      : UniversalFileViewer(
                                                          file: data[index])),
                                        ),
                                        Spacer(
                                          flex: 1,
                                        )
                                      ],
                                    )),
                              );
                            },
                          ),
                        )
                      ],
              ),
            ),
          );
        },
      ),
    );
  }
}
