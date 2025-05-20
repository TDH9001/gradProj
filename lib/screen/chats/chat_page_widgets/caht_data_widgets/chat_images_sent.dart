import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/animated_hero_service/animated_hero_dialog.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_caht_data_caching_service.dart';
import 'package:grad_proj/services/media_service.dart';

class ChatImagesSent extends StatefulWidget {
  const ChatImagesSent({super.key, required this.cahtId});
  final String cahtId;

  @override
  State<ChatImagesSent> createState() => _ChatImagesSentState();
}

class _ChatImagesSentState extends State<ChatImagesSent> {
  late Future<List<File>> _validImagesFuture;
  Future<List<File>> getValidMessages() async {
    List<Message> allMessages =
        HiveCahtMessaegsCachingService.getChatData(widget.cahtId);

    List<Message> ImageMessages = allMessages
        .where((element) => element.type == MessageType.image.name)
        .toList();

    List<File> validMessages = [];
    for (int i = 0; i < ImageMessages.length; i++) {
      final result = await ChatFileCachingService.loadCachedFile(
              fileAdress: ImageMessages[i].messageContent, fileType: "images")
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
                initiallyExpanded: false,
                leading: const Icon(Icons.image, color: Color(0xff2E5077)),
                // elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Row(
                  children: [
                    Text(
                      "images Sent",
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
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            //        shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  AnimatedHeroDialog
                                      .showAnimatedWidgetTransition(
                                          context: context,
                                          heroID: data[index].toString(),
                                          displayedWidget: ClipRRect(
                                            child: Center(
                                              child: Image(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(data[
                                                      index]) //does not display when loading though
                                                  ),
                                            ),
                                          ));
                                },
                                child: Hero(
                                    tag: data[index].toString(),
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      height:
                                          MediaService.instance.getHeight() *
                                              0.35,
                                      width: MediaService.instance.getWidth() *
                                          0.5,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black87, width: 2),
                                        // borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: FileImage(data[index]),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
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
