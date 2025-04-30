import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    if (this.mounted) {
      super.setState(fn);
    }
  }

  bool Playing = false;
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isAudioLoaded = false;

  final _numMap = {
    1: "jan",
    2: "feb",
    3: "mar",
    4: 'apr',
    5: "may",
    6: "jun",
    7: "jul",
    8: "aug",
    9: "sep",
    10: "oct",
    11: "nov",
    12: "dec"
  };
  final _weekmap = {
    6: "saturday",
    7: 'sunday',
    1: "monday",
    2: "tuesday",
    3: "wednesday",
    4: "thursday",
    5: "friday"
  };

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

    if (Playing) {
      MediaService.instance.pauseAudio(_audioPlayer);
    } else {
      if (_position > Duration.zero) {
        MediaService.instance.resumeAudio(_audioPlayer);
      } else {
        MediaService.instance.playAudio(_audioPlayer, widget.AudioAdress);
      }
    }
    setState(() {
      Playing = !Playing;
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
        Playing = !Playing;
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
                splashColor: Playing ? LightTheme.primary : Colors.red,
                onPressed: () {
                  _togglePlayPause();
                },
                icon: Icon(
                  Playing ? Icons.pause : Icons.play_arrow,
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
                  Text("${_position.toString()} / ${_duration.toString()}")
                ],
              )
            ],
          ),
          // SizedBox(
          //   height: 6,
          // ),
          Text(
            "${_weekmap[widget.ts.toDate().weekday]} ${_numMap[widget.ts.toDate().month]} ${widget.ts.toDate().day} , ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "pm" : "am"}        ",
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
