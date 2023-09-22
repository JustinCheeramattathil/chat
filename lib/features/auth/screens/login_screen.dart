import 'package:chatos_messenger/colors.dart';
import 'package:chatos_messenger/common/utils/utils.dart';
import 'package:chatos_messenger/common/widgets/custom_button.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/screens/widget/waiting_snackbar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      showSnackBar(context:context,content: 'empty spaces are not allowed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter the phone number'),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('assets/images/chat1.json'),
              const SizedBox(
                height: 20,
              ),
              const Text('Verify your phone number'),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 60,
                              child: IconButton(
                                  onPressed: pickCountry,
                                  icon: const Icon(
                                    Icons.language,
                                    color: Colors.amber,
                                  )),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 13, left: 40),
                              child: Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                        if (country != null)
                          Text(
                            '+${country!.phoneCode}',
                            style: const TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        child: TextFormField(
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.2),
              SizedBox(
                child: CustomButton(
                    text: 'Tap to Next',
                    onPressed: () {
                      sendPhoneNumber();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: WaitingSnackBar(
                            errorText: 'Please wait OTP is Processing',
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                      );
                    }
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
