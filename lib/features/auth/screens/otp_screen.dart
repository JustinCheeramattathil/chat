import 'dart:async';

import 'package:chatos_messenger/colors.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerStatefulWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  final String phoneNumber;
  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          widget.verificationId,
          userOTP,
        );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  Timer? _timer;
  int _start = 60;
  String getFormattedTime() {
    final minutes = (_start / 60).floor();
    final seconds = _start % 60;
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    } else {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('Verify your OTP'),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              child: OtpTextField(
                focusedBorderColor: Colors.amber,
                cursorColor: Colors.amber,
                numberOfFields: 6,
                borderColor: Colors.amber,
                showFieldAsBox: true,
                keyboardType: TextInputType.number,
                onSubmit: (val) {
                  if (val.length == 6) {
                    verifyOTP(ref, context, val.trim());
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            _start > 0
                ? Text(
                    'Time remaining  : ${getFormattedTime()}',
                    style: TextStyle(fontSize: 16),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Did'nt received a code?"),
                        InkWell(
                          onTap: () {
                            ref
                                .read(authControllerProvider)
                                .signInWithPhone(context, widget.phoneNumber);
                          },
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
