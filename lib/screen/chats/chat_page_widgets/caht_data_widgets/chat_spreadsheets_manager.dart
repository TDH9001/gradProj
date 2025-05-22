import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_data_screen.dart';
import 'package:grad_proj/screen/chats/spread_sheet_functions.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../providers/theme_provider.dart';

class ChatSpreadSheetsSlider extends StatelessWidget {
  const ChatSpreadSheetsSlider({super.key, required this.widget});
  final ChatDataScreen widget;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

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
              colors: isDarkMode
                  ? [Color(0xff2E5077), Color(0xFF2E3B55)]
                  : [Color(0xff769BC6), Color(0xffa6c4dd)],
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
            leading: Icon(Icons.image,
                color: isDarkMode ? Color(0xFF4A739F) : Color(0xff2E5077)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'ChatSpreadSheetsSlider.spreadSheets'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            children: [
              SizedBox(
                height: MediaService.instance.getHeight() * 0.35,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.adminList.contains(
                          HiveUserContactCashingService.getUserContactData().id) ||
                          HiveUserContactCashingService.getUserContactData().id.length <
                              10) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Text(
                            'ChatSpreadSheetsSlider.get_base_spreadsheet'.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PrimaryButton(
                            buttontext: 'ChatSpreadSheetsSlider.base_sheet_button'.tr(),
                            func: () {
                              SpreadSheetFunctions()
                                  .downloadBaseSheet(context, widget.cahtId);
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                      ],

                      if (widget.adminList.contains(
                          HiveUserContactCashingService.getUserContactData().id) ||
                          HiveUserContactCashingService.getUserContactData().id.length <
                              10) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Text(
                            'ChatSpreadSheetsSlider.get_current_file'.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PrimaryButton(
                            buttontext: 'ChatSpreadSheetsSlider.current_sheet_button'.tr(),
                            func: () {
                              SpreadSheetFunctions()
                                  .downloadCurrentSpreadSheet(context, widget.cahtId);
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                      ],

                      if (widget.adminList.contains(
                          HiveUserContactCashingService.getUserContactData().id) ||
                          HiveUserContactCashingService.getUserContactData().id.length <
                              10) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Text(
                            'ChatSpreadSheetsSlider.submit_a_spreadsheet'.tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PrimaryButton(
                            buttontext: 'ChatSpreadSheetsSlider.submit_sheet_button'.tr(),
                            func: () {
                              SpreadSheetFunctions()
                                  .pickSpreadSheet(context, widget.cahtId);
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                      ],

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Text(
                          'ChatSpreadSheetsSlider.view_your_spreadsheet'.tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: PrimaryButton(
                          buttontext: 'ChatSpreadSheetsSlider.view_button'.tr(),
                          func: () {
                            SpreadSheetFunctions()
                                .getUserFromSpreadSheet(context, widget.cahtId);
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
