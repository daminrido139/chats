import 'package:chats/components/my_button.dart';
import 'package:chats/components/my_text_field.dart';
import 'package:chats/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function() onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text  controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  //logo
                  Icon(
                    Icons.message,
                    size: 100,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(height: 50),

                  //wecome back message
                  const Text(
                    "Welcome, Rido!",
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

                  //password textfield
                  MyTextField(
                    controller: passwordController,
                    obsecureText: true,
                    hintText: "Password",
                  ),

                  const SizedBox(height: 25),
                  //sigin button
                  MyButton(onTap: signIn, text: "Sign In"),

                  const SizedBox(height: 50),
                  //not a member? register now!
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member?"),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Register",
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
