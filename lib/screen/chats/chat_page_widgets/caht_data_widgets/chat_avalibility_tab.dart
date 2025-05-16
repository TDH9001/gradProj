import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';

class ChatAvalibilitySlider extends StatelessWidget {
  const ChatAvalibilitySlider(
      {super.key, required this.chatAccesability, required this.chatId});
  final String chatAccesability;
  final String chatId;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Card(
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
            leading:
                const Icon(Icons.open_in_browser, color: Color(0xff769BC6)),
            // elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              children: [
                Text(
                  "Chat Avalibility setting",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            children: [
              SizedBox(
                height: MediaService.instance.getHeight() / 3,
                child: ListView(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "current Mode : ${chatAccesability}",
                    ),
                  ),
                  Row(children: [
                    Text(
                        "set mode to :${ChatAccesabilityEnum.admin_only.name}"),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      width: 200,
                      child: PrimaryButton(
                          buttontext:
                              "set to : ${ChatAccesabilityEnum.admin_only.name} ",
                          func: () => DBService.instance
                              .changeChatAccesabilitySetting(
                                  chatId,
                                  ChatAccesabilityEnum.admin_only.index,
                                  context)),
                    )
                  ]),
                  Row(children: [
                    Text("set mode to "),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      width: MediaService.instance.getWidth() * 0.5,
                      child: PrimaryButton(
                          buttontext:
                              "set: ${ChatAccesabilityEnum.allow_Leaders.name} ",
                          func: () => DBService.instance
                              .changeChatAccesabilitySetting(
                                  chatId,
                                  ChatAccesabilityEnum.allow_Leaders.index,
                                  context)),
                    )
                  ]),
                  Row(children: [
                    Text("set mode to :${ChatAccesabilityEnum.allow_All.name}"),
                    Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      width: MediaService.instance.getWidth() * 0.5,
                      child: PrimaryButton(
                          buttontext:
                              "set to : ${ChatAccesabilityEnum.allow_All.name} ",
                          func: () {
                            DBService.instance.changeChatAccesabilitySetting(
                                chatId,
                                ChatAccesabilityEnum.allow_All.index,
                                context);
                            // DBService.instance.makeUserChatLeader(
                            //     chatId,
                            //     HiveUserContactCashingService
                            //             .getUserContactData()
                            //         .id
                            //         .trim());
                          }),
                    )
                  ])
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
