import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/months_and_week_map.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/theme/light_theme.dart';

class VoiceBubble extends StatefulWidget {
  final String AudioAdress;
  final bool isOurs;
  final Timestamp ts;
  final String senderName;

  VoiceBubble({
    required this.AudioAdress,
    required this.isOurs,
    required this.ts,
    required this.senderName,
  });

  @override
  _VoiceMessageBubbleState createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceBubble> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool playing = false;
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isAudioLoaded = false;

  Future<void> _loadAudio() async {
    if (!_isAudioLoaded) {
      try {
        await _audioPlayer.setSourceUrl(widget.AudioAdress);
        Duration? d = await _audioPlayer.getDuration();
        if (d != null) {
          setState(() {
            _duration = d;
            _isAudioLoaded = true;
          });
        }
      } catch (e) {
        print("Error loading audio: $e");
      }
    }
  }

  void _togglePlayPause() async {
    if (!_isAudioLoaded) await _loadAudio();

    if (playing) {
      MediaService.instance.pauseAudio(_audioPlayer);
    } else {
      if (_position > Duration.zero) {
        MediaService.instance.resumeAudio(_audioPlayer);
      } else {
        MediaService.instance.playAudio(_audioPlayer, widget.AudioAdress);
      }
    }
    setState(() {
      playing = !playing;
    });
  }

  @override
  dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  initState() {
    _audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _audioPlayer.onPlayerComplete.listen((D) {
      setState(() {
        _position = Duration.zero;
        playing = !playing;
      });
      MediaService.instance.pauseAudio(_audioPlayer);
    });
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    List<Color> colorScheme = widget.isOurs
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [
            Color(0xFFA3BFE0),
            Color(0xFF769BC6),
          ];

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: colorScheme,
              stops: [0.40, 0.70],
              begin:
                  widget.isOurs ? Alignment.bottomLeft : Alignment.bottomRight,
              end: widget.isOurs ? Alignment.topRight : Alignment.topLeft)),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:
            widget.isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(widget.senderName),
          Row(
            children: [
              IconButton(
                splashColor: playing ? LightTheme.primary : Colors.red,
                onPressed: () {
                  _togglePlayPause();
                },
                icon: Icon(
                  playing ? Icons.pause : Icons.play_arrow,
                ),
              ),
              Column(
                children: [
                  Slider(
                    value: _position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      try {
                        await _audioPlayer
                            .seek(Duration(seconds: value.toInt()));

                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    min: 0,
                    max: _duration.inSeconds.toDouble() > 0.0
                        ? _duration.inSeconds.toDouble()
                        : 1.0,
                    activeColor: LightTheme.primary,
                    inactiveColor: LightTheme.secondary,
                  ),
                  Text("${(_position).toString()} / ${_duration.toString()}"),
                ],
              )
            ],
          ),
          // SizedBox(
          //   height: 6,
          // ),
          Text(
            "${MonthAndWeekMap.weekmap[widget.ts.toDate().weekday]} ${MonthAndWeekMap.numMap[widget.ts.toDate().month]} ${widget.ts.toDate().day} , ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
