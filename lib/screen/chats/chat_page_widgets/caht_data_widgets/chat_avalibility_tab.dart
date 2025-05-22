import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/Chats.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../../providers/theme_provider.dart';

class ChatAvalibilitySlider extends StatelessWidget {
  const ChatAvalibilitySlider({
    super.key,
    required this.chatAccesability,
    required this.chatId,
  });

  final String chatAccesability;
  final String chatId;

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
            leading: Icon(
              Icons.open_in_browser,
              color: isDarkMode ? Color(0xFF4A739F) : Color(0xff2E5077),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text(
              'ChatAvailabilitySlider.available'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            children: [
              SizedBox(
                height: MediaService.instance.getHeight() / 3,
                child: ListView(
                  children: [
                    // Current Mode Display
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        //"Current Mode: $chatAccesability",
                        "${'ChatAvailabilitySlider.current_mode'.tr()} ${chatAccesability}",

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Mode Cards without green highlight
                    _buildModeCard(
                      context,
                      mode: ChatAccesabilityEnum.admin_only,
                      icon: Icons.shield,
                      chatId: chatId,
                    ),
                    _buildModeCard(
                      context,
                      mode: ChatAccesabilityEnum.allow_Leaders,
                      icon: Icons.groups,
                      chatId: chatId,
                    ),
                    _buildModeCard(
                      context,
                      mode: ChatAccesabilityEnum.allow_All,
                      icon: Icons.public,
                      chatId: chatId,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(
      BuildContext context, {
        required ChatAccesabilityEnum mode,
        required IconData icon,
        required String chatId,
      }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                 // "Set mode to: ${mode.name}",
                    "${'ChatAvailabilitySlider.set_mode_to'.tr()} ${mode.name}",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: PrimaryButton(
              buttontext:
              //"Set to: ${mode.name}",
           "${"ChatAvailabilitySlider.set_to".tr()} ${mode.name}",
              func: () => DBService.instance.changeChatAccesabilitySetting(
                chatId,
                mode.index,
                context,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
