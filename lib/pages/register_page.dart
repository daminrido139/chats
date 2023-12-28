import 'package:chats/components/my_button.dart';
import 'package:chats/components/my_text_field.dart';
import 'package:chats/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function() onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text  controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final nameController = TextEditingController();

  void signUp() {
    if (confirmpasswordController.text != passwordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match!"),
      ));
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      authService.signUpWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  //Information text
                  const Text(
                    "Let's create an account for you!",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 25),

                  //email textfield
                  MyTextField(
                    controller: emailController,
                    obsecureText: false,
                    hintText: "Email",
                  ),

                  const SizedBox(height: 10),

                  //name textfield
                  MyTextField(
                    controller: nameController,
                    obsecureText: false,
                    hintText: "Name",
                  ),

                  const SizedBox(height: 10),

                  //password textfield
                  MyTextField(
                    controller: passwordController,
                    obsecureText: true,
                    hintText: "Password",
                  ),

                  const SizedBox(height: 10),
                  //confirm password textfield
                  MyTextField(
                    controller: confirmpasswordController,
                    obsecureText: true,
                    hintText: "Confirm Password",
                  ),

                  const SizedBox(height: 25),
                  //sigup button
                  MyButton(onTap: signUp, text: "Sign Up"),

                  const SizedBox(height: 50),
                  //Redirect to loginPage!
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Login now",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
