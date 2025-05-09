import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_proj/screen/chats/caht_cubit/chat_cubit_states.dart';
import 'package:grad_proj/services/cloud_Storage_Service.dart';
import 'package:grad_proj/services/hive_caching_service/hive_user_contact_cashing_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class ChatCubit extends Cubit<ChatCubitStates> {
  ChatCubit() : super(ChatCubitInitial());

  static ChatCubit get(context) => BlocProvider.of(context);
  final TextEditingController txt = TextEditingController();
  AudioPlayer audioPlayer = AudioPlayer();
  final AudioRecorder record = AudioRecorder();

  void onTextChanged(String text) {
    if (text.trim().isNotEmpty) {
      emit(ChatCubitTyping());
    } else {
      emit(ChatCubitInitial());
    }
  }

  void chageStateForChat() {
    emit(ChatCubitInitial());
  }

  void startRecord(AudioRecorder rec) async {
    emit(ChatCubitRecording());
    var location = await getApplicationDocumentsDirectory();
    String fileName = Uuid().v4();
    if (await rec.hasPermission()) {
      await rec.start(RecordConfig(), path: location.path + fileName + '.m4a');
    }
  }

  Future<String?> stopRecord(
    AudioRecorder rec,
  ) async {
    emit(ChatCubitInitial());
    String? finalPath = await rec.stop();
    if (finalPath != null) {
      var _result = await CloudStorageService.instance.uploadVoice(
          uid: HiveUserContactCashingService.getUserContactData().id,
          fileData: File(finalPath));
      return await _result!.ref.getDownloadURL();
    } else {
      SnackBarService.instance
          .showsSnackBarError(text: "could not uplaod the file");
    }
  }
}
