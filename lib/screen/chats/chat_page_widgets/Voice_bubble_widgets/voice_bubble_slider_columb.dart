import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../theme/light_theme.dart';

class VoiceButtonSlicerColumb extends StatelessWidget {
  const VoiceButtonSlicerColumb(
      {super.key,
      required Duration position,
      required AudioPlayer audioPlayer,
      required Duration duration,
      required bool isLoadingFile,
      required bool isFailed})
      : _position = position,
        _audioPlayer = audioPlayer,
        _duration = duration,
        _isFailed = isFailed,
        _isLoadingFile = isLoadingFile;

  final Duration _position;
  final AudioPlayer _audioPlayer;
  final Duration _duration;
  final bool _isLoadingFile;
  final bool _isFailed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
            value: _position.inSeconds.toDouble(),
            onChanged: (value) async {
              try {
                await _audioPlayer
                    .seek(Duration(seconds: value.toInt()))
                    .timeout(
                      Duration(seconds: 5),
                      onTimeout: () => print("timed out but no errors"),
                    );

                // setState(() {});
              } on Exception catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            },
            min: 0,
            max: _duration.inSeconds.toDouble() > 0.0
                ? _duration.inSeconds.toDouble()
                : 1.0,
            thumbColor: _isFailed == true
                ? Colors
                    .red[300] // when it fails to load the audio file as it is missing from DB
                : _isLoadingFile
                    ? Colors
                        .green[200] // when downloading file > عشانيك اما تشتغلي يا ساره
                    : LightTheme.secondary,
            activeColor: _isLoadingFile ? Colors.green[300] : LightTheme.primary,
            inactiveColor: _isFailed == true
                ? Colors
                    .red[300] // when it fails to load the audio file as it is missing from DB
                : _isLoadingFile
                    ? Colors
                        .greenAccent // when downloading file > عشانيك اما تشتغلي يا ساره
                    : LightTheme.secondary),
        _isFailed ? Text('VoiceButtonSlicerColumn.error'.tr()) : SizedBox(),
        !_isFailed
            ? Text(
                "${(_position).inMinutes.toStringAsFixed(0)} : ${(_position).inSeconds.toString()} / ${_duration.inMinutes.toStringAsFixed(0)} : ${(_duration).inSeconds.toString()}")
            : SizedBox(),
      ],
    );
  }
}
