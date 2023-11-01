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
  }

  void initAgora() async {
    await client!.initialize();
    client!.engine.enableLocalVideo(false);
  }

  @override
  void dispose() {
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
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mic,
                          size: 100,
                          color: Colors.grey,
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
}
