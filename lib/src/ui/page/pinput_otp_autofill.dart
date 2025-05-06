import 'dart:async';

import 'package:ds/ds.dart';
import 'package:flutter/gestures.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';

class PinputOtpAutofill extends StatefulWidget {
  const PinputOtpAutofill({
    super.key,
    required this.title,
    required this.userPhone,
    required this.onValidator,
    required this.countdownText,
    required this.confirmText,
    required this.notReceiveText,
    required this.supportText,
    required this.onSupport,
    required this.onCompleted,
    required this.errorText,
    this.otpLength = 6,
  });

  final String title;
  final String userPhone;
  final Function onValidator;
  final Function onSupport;
  final Function onCompleted;
  final String countdownText;
  final String confirmText;
  final String notReceiveText;
  final String supportText;
  final String errorText;
  final int otpLength;

  @override
  PinputOtpAutofillState createState() => PinputOtpAutofillState();
}

class PinputOtpAutofillState extends State<PinputOtpAutofill>
    with WidgetsBindingObserver {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  late Timer timer;
  int timeValid = 120;
  bool hasRecipe = true;
  bool loading = false;

  void startTimer() {
    const oneSec = Duration(seconds: 1);

    setState(() {
      timeValid = 120;
    });

    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          if (timeValid == 0) {
            setState(() {
              timer.cancel();
            });
          } else if (timeValid > 0) {
            setState(() {
              timeValid--;
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      timeValid = timeValid--;
    }
  }

  @override
  Widget build(BuildContext context) {
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    List<String> countdownText = widget.countdownText.split("{}");

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF7F8F9),
        border: Border.all(color: Color(0xFFF1F2F4),
      ),
    ));

    return SizedBox(
      width: double.infinity,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.title,
                    style: DSTextStyle.bodySmall.copyWith(
                      color: Color(0xff82878B),
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text: widget.userPhone,
                    style: DSTextStyle.headlineMedium.copyWith(
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Pinput(
              controller: pinController,
              focusNode: focusNode,
              length: widget.otpLength,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              validator: (value) {
                return (hasRecipe) ? null : widget.errorText;
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                if (pin.length == widget.otpLength && !loading) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.pop(context);
                    widget.onCompleted();
                  });
                }
              },
              onChanged: (value) async {
                setState(() {
                  hasRecipe = true;
                  loading = true;
                });
                if (value.length == widget.otpLength) {
                  bool check = await widget.onValidator(value);
                  setState(() {
                    hasRecipe = check;
                    loading = false;
                  });
                  formKey.currentState!.validate();
                }
              },
              cursor: Container(
                width: 1,
                height: 22,
                color: DSColors.backgroundBlack,
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: DSColors.backgroundWhite,
                  border: Border.all(
                    color: Color(0xFFE81D2B),
                  ),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  border: Border.all(
                    color: Color(0xFFE81D2B),
                  ),
                ),
              ),
              errorPinTheme: defaultPinTheme,
              errorTextStyle: DSTextStyle.bodySmall.copyWith(
                color: Color(0xFFE81D2B),
              ),
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 40),
            DSButton(
              borderRadius: BorderRadius.circular(10),
              isLoading: loading,
              onPressed: () async {
                focusNode.unfocus();
                if (formKey.currentState!.validate()) {
                  await widget.onValidator(pinController.text);
                }
              },
              label: widget.confirmText,
            ),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: DSTextStyle.bodySmall.copyWith(
                  color: Color(0xff82878B),
                  height: 1.3,
                ),
                children: [
                  TextSpan(
                    text: countdownText.first,
                  ),
                  TextSpan(
                    text: '${timeValid.toString()}s',
                  ),
                  TextSpan(
                    text: countdownText.last,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (timeValid <= 90) // after 30s show the not receive text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: widget.notReceiveText,
                  style: DSTextStyle.bodySmall.copyWith(
                    color: Color(0xFF404347),
                  ),
                  children: [
                    TextSpan(
                      text: ' ${widget.supportText}',
                      style: DSTextStyle.labelMediumPromient.copyWith(
                        color: Color(0xFFE81D2B),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          widget.onSupport();
                        },
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