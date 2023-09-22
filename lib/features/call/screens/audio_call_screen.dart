import 'dart:async';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:chatos_messenger/common/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatos_messenger/common/widgets/loader.dart';
import 'package:chatos_messenger/features/call/controller/call_controller.dart';

import 'package:chatos_messenger/models/call.dart';

class AudioCallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const AudioCallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AudioCallScreenState();
}

class _AudioCallScreenState extends ConsumerState<AudioCallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://chatos-messanger.onrender.com';

  late Timer callTimer;
  int secondsElapsed = 0;
  bool isCallConnected = false;

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );

    initAgora();
    startCallTimer();
  }

  void initAgora() async {
    await client!.initialize();
    client!.engine.enableLocalVideo(false);

    // client!.engine.onJoinChannelSuccess = () {
    //   setState(() {
    //     isCallConnected = true;
    //   });
    // };
  }

  void startCallTimer() {
    if (isCallConnected) {
      callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          secondsElapsed++;
        });
      });
    }
  }

  @override
  void dispose() {
    callTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const LoaderWidget()
          : SafeArea(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AgoraVideoViewer(client: client!),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mic,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Text(
                            'Call Time: ${_formatDuration(secondsElapsed)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 30,
                      child: IconButton(
                          onPressed: () async {
                            await client!.engine.leaveChannel();
                            ref.read(callControllerProvider).endCall(
                                  widget.call.callerId,
                                  widget.call.receiverId,
                                  context,
                                );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.call_end)),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
