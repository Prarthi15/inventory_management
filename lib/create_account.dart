import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_management/Api/loginApi.dart';
import 'Custom-Files/colors.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Container(
                        color: AppColors.primaryBlue,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Welcome Back!",
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "To keep connected with us please login with your personal info",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.primaryBlue,
                                    backgroundColor: AppColors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text("SIGN IN"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppColors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.all(40.0),
                    child: const Center(
                      child: CreateAccountForm(),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        color: AppColors.primaryBlue,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Welcome Back!",
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "To keep connected with us please login with your personal info",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColors.primaryBlue,
                                    backgroundColor: AppColors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 20.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text("SIGN IN"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CreateAccountForm(),
                      ),
                    ],
                  ),
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
            );
          }
        },
      ),
    );
  }
}

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({super.key});

  @override
  CreateAccountFormState createState() => CreateAccountFormState();
}

class CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.facebook,
                        color: AppColors.facebookColor),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.google,
                        color: AppColors.googleColor),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.linkedin,
                        color: AppColors.linkedinColor),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("or use your email for registration:"),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {}
                    AuthProvider().register('','', '');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("SIGN UP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
