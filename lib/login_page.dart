import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inventory_management/Api/auth_provider.dart';
import 'package:inventory_management/Custom-Files/colors.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  child: Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: Container(
                        width: 400,
                        child: const LoginForm(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.primaryBlue,
                    child: const Center(
                      child: Text(
                        "Katyayani",
                        style: TextStyle(
                          fontSize: 60,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: LoginForm(),
                    ),
                    Container(
                      width: double.infinity,
                      height: 300,
                      color: AppColors.primaryBlue,
                      child: const Center(
                        child: Text(
                          "Katyayani",
                          style: TextStyle(
                            fontSize: 40,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _rememberMe = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width <= 800;
    double textSize = isSmallScreen ? 30.0 : 32.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(31.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            Text(
              "Katyayani Organics",
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Log in to your Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Welcome back! Select method to log in:"),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.google,
                      color: AppColors.googleColor,
                      size: 18,
                    ),
                    label: const Text("Google"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      backgroundColor: AppColors.white,
                      shadowColor: AppColors.grey,
                      elevation: 5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.facebook,
                      color: AppColors.facebookColor,
                      size: 18,
                    ),
                    label: const Text("Facebook"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      backgroundColor: AppColors.white,
                      shadowColor: AppColors.grey,
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: AppColors.grey)),
                SizedBox(width: 10),
                Text("or continue with email"),
                SizedBox(width: 10),
                Expanded(child: Divider(thickness: 1, color: AppColors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: "Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (isSmallScreen) ...[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        activeColor: AppColors.primaryBlue,
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgotPassword');
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Obtain the AuthProvider instance
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);

                  // Perform login
                  await authProvider.login(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (authProvider.token != null) {
                    // Navigate to dashboard on successful login
                    Navigator.pushNamed(context, '/dashboard');
                  } else {
                    // Show error message if login fails
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Login Error"),
                        content: Text(authProvider.errorMessage ?? "An unknown error occurred."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text("Log in"),
              ),
            ),
            const SizedBox(height: 10),
            if (isSmallScreen) ...[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/createAccount');
                      },
                      child: const Text(
                        "Create an account",
                        style: TextStyle(color: AppColors.primaryBlue),
                      ),
                    ),
                  ],
                ),
              )
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/createAccount');
                    },
                    child: const Text(
                      "Create an account",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
