import 'package:flutter/material.dart';
import 'package:grad_proj/models/cached_file_rsponse/cahed_item_set_state_response.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Image_bubble_widgets/image_hero_container.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Network_checker_service.dart';
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
  @override
  Widget build(BuildContext context) {
    List<Message> allMessages =
        HiveCahtMessaegsCachingService.getChatData(widget.cahtId);
    int count = allMessages
        .where((element) => element.type == MessageType.image.name)
        .length;

    List<int> indecies = [];
    for (int i = 0; i < allMessages.length; i++) {
      if (allMessages[i].type == MessageType.image.name) {
        indecies.add(i);
      }
    }
    List<Color> colorScheme = true
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [
            Color(0xFFA3BFE0),
            Color(0xFF769BC6),
          ];

    return SliverToBoxAdapter(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            leading: const Icon(Icons.book, color: Color(0xff769BC6)),
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
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            children: [
              SizedBox(
                height: MediaService.instance.getHeight() / 2,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: count,
                  //issue is that [index] is from 1-n > but it is not like this in the count
                  itemBuilder: (context, index) {
                    return StreamBuilder<CachedFileResult>(
                        stream: ChatFileCachingService.loadCachedImage(
                            fileAdress:
                                allMessages[indecies[index]].messageContent),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // return Center(child: CircularProgressIndicator());
                            return ImageContainerHeroWidget(
                              fileAdress:
                                  allMessages[indecies[index]].messageContent,
                              imageToShow:
                                  AssetImage("assets/images/splash.png"),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                AnimatedHeroDialog.showAnimatedWidgetTransition(
                                  context: context,
                                  heroID: allMessages[indecies[index]]
                                      .messageContent,
                                  displayedWidget: ClipRRect(
                                    child: Image(
                                        image: snapshot.data!.file != null &&
                                                snapshot.data!.isFailed == false
                                            ? FileImage(snapshot.data!.file!)
                                            : snapshot.data!.isFailed == true
                                                ? AssetImage(
                                                    "assets/images/file_not_found.png")
                                                : AssetImage(
                                                    'assets/images/offline_image.png')), //does not display when loading though
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: LinearGradient(
                                          colors: colorScheme,
                                          stops: [0.40, 0.70],
                                          begin: true
                                              ? Alignment.bottomLeft
                                              : Alignment.bottomRight,
                                          end: true
                                              ? Alignment.topRight
                                              : Alignment.topLeft)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: true
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      //where image is displayed
                                      snapshot.data!.file != null &&
                                              !snapshot.data!
                                                  .isFailed //if not null and no error > then image
                                          ? ImageContainerHeroWidget(
                                              fileAdress:
                                                  allMessages[indecies[index]]
                                                      .messageContent,
                                              imageToShow: FileImage(
                                                  snapshot.data!.file!))
                                          : snapshot.data!
                                                  .isFailed //if it's failed > show placeholder image
                                              ? ImageContainerHeroWidget(
                                                  imageToShow: AssetImage(
                                                      "assets/images/file_not_found.png"),
                                                  fileAdress: allMessages[
                                                          indecies[index]]
                                                      .messageContent,
                                                )
                                              : snapshot.data!.isLoading ==
                                                      false //if it's not loading > show placeholder image
                                                  ? ImageContainerHeroWidget(
                                                      fileAdress: allMessages[
                                                              indecies[index]]
                                                          .messageContent,
                                                      imageToShow: AssetImage(
                                                          'assets/images/offline_image.png'),
                                                    )
                                                  : Container(
                                                      // if it's loading > show loading indicator
                                                      height: MediaService
                                                              .instance
                                                              .getHeight() *
                                                          0.35,
                                                      width: MediaService
                                                              .instance
                                                              .getWidth() *
                                                          0.5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Center(
                                                          child:
                                                              SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            CircularProgressIndicator(
                                                              color: Colors
                                                                  .greenAccent,
                                                            ),
                                                            SizedBox(
                                                                height: MediaService
                                                                        .instance
                                                                        .getHeight() *
                                                                    0.02),
                                                            Text(
                                                                "loading: ${(snapshot.data!.progress).toStringAsFixed(2)} %")
                                                          ],
                                                        ),
                                                      )),
                                                    ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
