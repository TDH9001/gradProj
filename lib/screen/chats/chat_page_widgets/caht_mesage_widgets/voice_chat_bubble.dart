import 'dart:io';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Voice_bubble_widgets/voice_bubble_slider_columb.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/Voice_bubble_widgets/voice_message_bubble_base_background.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/months_and_week_map.dart';
import 'package:grad_proj/services/file_caching_service/chat_file_caching_service.dart';
import 'package:grad_proj/services/media_service.dart';

class VoiceBubble extends StatefulWidget {
  final String AudioAdress;
  final bool isOurs;
  final Timestamp ts;
  final String senderName;
  final bool isImportant;

  VoiceBubble(
      {super.key,
      required this.AudioAdress,
      required this.isOurs,
      required this.ts,
      required this.senderName,
      required this.isImportant});

  @override
  _VoiceMessageBubbleState createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceBubble>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    _audioPlayer = AudioPlayer();
    super.initState();
    _loadAudioFileAndSet();

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
  }

  bool playing = false;
  late AudioPlayer _audioPlayer;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  // bool _isAudioLoaded = false;
//adding data used for file fetching
  File? _cachedAudioFile;
  bool _isLoadingFile = false;
  double _downloadProgress = 0.0;
  bool _isFailed = false;

  void _loadAudioFileAndSet() async {
    ChatFileCachingService.loadCachedFile(fileAdress: widget.AudioAdress)
        .listen((StreamResponse) async {
      //i can not use builders as there are many auto-playing functions here
      if (StreamResponse.isFailed == true) {
        // when file fails to load > deleted from DB
        setState(() {
          _isLoadingFile = false;
          _isFailed = true;
          _cachedAudioFile = null;
        });
      } else if (StreamResponse.isFailed == false &&
          StreamResponse.isLoading == false &&
          StreamResponse.file != null) {
        //when fetching is complete
        _cachedAudioFile = StreamResponse.file;
        await _audioPlayer.setSourceDeviceFile(StreamResponse.file!.path);
        Duration? d = await _audioPlayer.getDuration();
        if (d != null) {
          setState(() {
            _duration = d;
            _cachedAudioFile = StreamResponse.file;
            _isLoadingFile = false;
            _downloadProgress = 0.0;
          });
        }
      } else if (StreamResponse.isLoading == true) {
        print(_downloadProgress = StreamResponse.progress / 100);
        //when it is loading
        setState(() {
          _isLoadingFile = true;
          _isFailed = false;
          _cachedAudioFile = null;
          _downloadProgress = StreamResponse.progress;
          // _position = Duration(seconds: StreamResponse.progress.toInt() / 100);
        });
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void togglePlayPause() async {
    // if (!_isAudioLoaded) await _loadAudio();

    if (playing) {
      MediaService.instance.pauseAudio(_audioPlayer);
    } else {
      if (_position > Duration.zero) {
        MediaService.instance.resumeAudio(_audioPlayer);
      } else {
        if (_cachedAudioFile != null) {
          MediaService.instance.playAudio(_audioPlayer, _cachedAudioFile!.path);
        }
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
  Widget build(BuildContext context) {
    List<Color> colorScheme = widget.isOurs
        ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
        : [
            Color(0xFFA3BFE0),
            Color(0xFF769BC6),
          ];

    return CustomPopupMenu(
      pressType: PressType.longPress,
      menuBuilder: () {
        return Container(
          height: MediaService.instance.getHeight() * 0.05,
          color: Colors.blueGrey,
          child: Row(
            children: [],
          ),
        );
      },
      child: VoiceMessageBaseBAckground(widget: widget, child: [
        Text(widget.senderName),
        Row(
          children: [
            IconButton(
              //splashColor: playing ? LightTheme.primary : Colors.red,
              onPressed: _isFailed || _isLoadingFile ? null : togglePlayPause,
              icon: Icon(
                _isLoadingFile
                    ? Icons.downloading
                    : _isFailed
                        ? Icons.error
                        : playing
                            ? Icons.pause
                            : Icons.play_arrow,
              ),
            ),
            VoiceButtonSlicerColumb(
              position: _position,
              audioPlayer: _audioPlayer,
              duration: _duration,
              isLoadingFile: _isLoadingFile,
              isFailed: _isFailed,
            )
          ],
        ),
        Text(
          "  ${widget.ts.toDate().hour % 12}: ${widget.ts.toDate().minute % 60} ${widget.ts.toDate().hour < 12 ? "am" : "pm"}        ",
          style: TextStyle(fontSize: 16),
        )
      ]),
    );
  }
}
