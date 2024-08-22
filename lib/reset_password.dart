import 'package:flutter/material.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/Api/auth_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            child: Image.asset('resetPass.png',
                                fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Please enter your email and new password',
                            style: TextStyle(color: AppColors.primaryBlue),
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
                                    style: const TextStyle(
                                        color: AppColors.primaryBlue),
                                    cursorColor: AppColors.primaryBlue,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                          color: AppColors.primaryBlue),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryBlue),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryBlue),
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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    controller: _newPasswordController,
                                    obscureText: _obscureText,
                                    style: const TextStyle(
                                        color: AppColors.primaryBlue),
                                    cursorColor: AppColors.primaryBlue,
                                    decoration: InputDecoration(
                                      labelText: 'New Password',
                                      labelStyle: const TextStyle(
                                          color: AppColors.primaryBlue),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryBlue),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryBlue),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: AppColors.primaryBlue,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your new password';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      await Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .resetPassword(_emailController.text,
                                              _newPasswordController.text);

                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.white,
                                    backgroundColor: AppColors.primaryBlue,
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
                                  'Reset Password',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 60 : 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Please enter your email and new password',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 20 : 16,
                                    color: AppColors.primaryBlue,
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
                                              color: AppColors.primaryBlue),
                                          cursorColor: AppColors.primaryBlue,
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                                color: AppColors.primaryBlue),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.primaryBlue),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.primaryBlue),
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
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        child: TextFormField(
                                          controller: _newPasswordController,
                                          obscureText: _obscureText,
                                          style: const TextStyle(
                                              color: AppColors.primaryBlue),
                                          cursorColor: AppColors.primaryBlue,
                                          decoration: InputDecoration(
                                            labelText: 'New Password',
                                            labelStyle: const TextStyle(
                                                color: AppColors.primaryBlue),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.primaryBlue),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppColors.primaryBlue),
                                            ),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: AppColors.primaryBlue,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your new password';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            await Provider.of<AuthProvider>(
                                                    context,
                                                    listen: false)
                                                .resetPassword(
                                                    _emailController.text,
                                                    _newPasswordController
                                                        .text);

                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: AppColors.white,
                                          backgroundColor:
                                              AppColors.primaryBlue,
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
                                child: Image.asset('resetPass.png',
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
