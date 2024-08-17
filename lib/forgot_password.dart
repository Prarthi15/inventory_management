import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/Api/auth_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  bool _isSendingOtp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 600;
              final isLargeScreen = constraints.maxWidth >= 600;

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 62.0, vertical: 16.0),
                child: isSmallScreen
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.asset('assets/forgotPass.png',
                                fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Please enter your email',
                            style: TextStyle(color: AppColors.white),
                          ),
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    controller: _emailController,
                                    style:
                                        const TextStyle(color: AppColors.white),
                                    cursorColor: AppColors.white,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      labelStyle:
                                          TextStyle(color: AppColors.white),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: AppColors.white),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'\S+@\S+\.\S+')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _otpController,
                                        enabled: _isOtpSent,
                                        style: const TextStyle(
                                            color: AppColors.white),
                                        cursorColor: AppColors.white,
                                        decoration: const InputDecoration(
                                          labelText: 'OTP',
                                          labelStyle:
                                              TextStyle(color: AppColors.white),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _emailController
                                                  .text.isNotEmpty &&
                                              !_isOtpSent
                                          ? () async {
                                              setState(() {
                                                _isSendingOtp = true;
                                              });

                                              await Provider.of<AuthProvider>(
                                                      context,
                                                      listen: false)
                                                  .forgotPassword(
                                                      _emailController.text);

                                              setState(() {
                                                _isOtpSent = true;
                                                _isSendingOtp = false;
                                              });
                                            }
                                          : _isOtpSent && !_isOtpVerified
                                              ? () async {
                                                  await Provider.of<
                                                              AuthProvider>(
                                                          context,
                                                          listen: false)
                                                      .verifyOtp(
                                                          _emailController.text,
                                                          _otpController.text);

                                                  setState(() {
                                                    _isOtpVerified = true;
                                                  });
                                                }
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: AppColors.primaryBlue,
                                        backgroundColor: AppColors.white,
                                      ),
                                      child: Text(_isSendingOtp
                                          ? 'Sending...'
                                          : _isOtpSent
                                              ? 'Verify'
                                              : 'Send OTP'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _isOtpVerified
                                      ? () {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            Navigator.pushNamed(
                                                context, '/reset_password');
                                          }
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.primaryBlue,
                                    backgroundColor: AppColors.white,
                                  ),
                                  child: const Text('Reset Password'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 60 : 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Please enter your email',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 20 : 16,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        child: TextFormField(
                                          controller: _emailController,
                                          style: const TextStyle(
                                              color: AppColors.white),
                                          cursorColor: AppColors.white,
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                                color: AppColors.white),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.white),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.white),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            if (!RegExp(r'\S+@\S+\.\S+')
                                                .hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: _otpController,
                                              enabled: _isOtpSent,
                                              style: const TextStyle(
                                                  color: AppColors.white),
                                              cursorColor: AppColors.white,
                                              decoration: const InputDecoration(
                                                labelText: 'OTP',
                                                labelStyle: TextStyle(
                                                    color: AppColors.white),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors.white),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: AppColors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: _emailController
                                                        .text.isNotEmpty &&
                                                    !_isOtpSent
                                                ? () async {
                                                    setState(() {
                                                      _isSendingOtp = true;
                                                    });

                                                    await Provider.of<
                                                                AuthProvider>(
                                                            context,
                                                            listen: false)
                                                        .forgotPassword(
                                                            _emailController
                                                                .text);

                                                    setState(() {
                                                      _isOtpSent = true;
                                                      _isSendingOtp = false;
                                                    });
                                                  }
                                                : _isOtpSent && !_isOtpVerified
                                                    ? () async {
                                                        await Provider.of<
                                                                    AuthProvider>(
                                                                context,
                                                                listen: false)
                                                            .verifyOtp(
                                                                _emailController
                                                                    .text,
                                                                _otpController
                                                                    .text);

                                                        setState(() {
                                                          _isOtpVerified = true;
                                                        });
                                                      }
                                                    : null,
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.primaryBlue,
                                              backgroundColor: AppColors.white,
                                            ),
                                            child: Text(_isSendingOtp
                                                ? 'Sending...'
                                                : _isOtpSent
                                                    ? 'Verify'
                                                    : 'Send OTP'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: _isOtpVerified
                                            ? () {
                                                if (_formKey.currentState
                                                        ?.validate() ??
                                                    false) {
                                                  Navigator.pushNamed(context,
                                                      '/reset_password');
                                                }
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primaryBlue,
                                          backgroundColor: AppColors.white,
                                        ),
                                        child: const Text('Reset Password'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: constraints.maxWidth * 0.5,
                                height: constraints.maxHeight * 0.6,
                                child: Image.asset('assets/forgotPass.png',
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
