import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/chats/spread_sheet_functions.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';

class ChatSpreadSheetsSlider extends StatelessWidget {
  const ChatSpreadSheetsSlider({super.key, required this.widget});
  final ChatDataScreen widget;

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
              leading: const Icon(Icons.image, color: Color(0xff2E5077)),
              // elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Row(
                children: [
                  Text(
                    "SpreadSheets",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,color: Colors.white
                    ),
                  ),
                ],
              ),
              children: [
                SizedBox(
                  height: MediaService.instance.getHeight() * 0.25,
                  child: Column(
                    children: [
                      if (widget.adminList.contains(
                              HiveUserContactCashingService.getUserContactData()
                                  .id) ||
                          HiveUserContactCashingService.getUserContactData()
                                  .id
                                  .length <
                              10)
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("get base spreadhseet"),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          SizedBox(
                              width: MediaService.instance.getWidth() * 0.5,
                              child: PrimaryButton(
                                  buttontext: "base sheet",
                                  func: () {
                                    SpreadSheetFunctions().downloadBaseSheet(
                                        context, widget.cahtId);
                                  }))
                        ]),
                      Spacer(
                        flex: 1,
                      ),
                      if (widget.adminList.contains(
                              HiveUserContactCashingService.getUserContactData()
                                  .id) ||
                          HiveUserContactCashingService.getUserContactData()
                                  .id
                                  .length <
                              10)
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("get current file"),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          SizedBox(
                              width: MediaService.instance.getWidth() * 0.5,
                              child: PrimaryButton(
                                  buttontext: "current sheet",
                                  func: () {
                                    SpreadSheetFunctions()
                                        .downloadCurrentSpreadSheet(
                                            context, widget.cahtId);
                                  }))
                        ]),
                      Spacer(
                        flex: 1,
                      ),
                      if (widget.adminList.contains(
                              HiveUserContactCashingService.getUserContactData()
                                  .id) ||
                          HiveUserContactCashingService.getUserContactData()
                                  .id
                                  .length <
                              10)
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Submit a spreadsheet"),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Container(
                              width: MediaService.instance.getWidth() * 0.5,
                              child: PrimaryButton(
                                  buttontext: "submit sheet",
                                  func: () {
                                    SpreadSheetFunctions().pickSpreadSheet(
                                        context, widget.cahtId);
                                  }))
                        ]),
                      Spacer(
                        flex: 1,
                      ),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("View your spreadsheet"),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                            width: MediaService.instance.getWidth() * 0.5,
                            child: PrimaryButton(
                                buttontext: "view sheet",
                                func: () {
                                  SpreadSheetFunctions().getUserFromSpreadSheet(
                                      context, widget.cahtId);
                                }))
                      ]),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
