import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(title: 'Login'), // 🔹 PASAMOS el title
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});
  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StateMachineController? controller;

  SMIBool? isCheking;
  SMIBool? isHandsUp;
  SMITrigger? triggerSuccess;
  SMITrigger? triggerFail;
  SMINumber? numlook;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  Timer? _emailIdleTimer;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        if (isCheking != null) isCheking!.change(true);
        if (isHandsUp != null) isHandsUp!.change(false);

        _emailIdleTimer?.cancel();
        _emailIdleTimer = Timer(const Duration(seconds: 2), () {
          if (numlook != null) numlook!.value = 0;
          if (isCheking != null) isCheking!.change(false);
        });
      } else {
        _emailIdleTimer?.cancel();
        if (numlook != null) numlook!.value = 0;
        if (isCheking != null) isCheking!.change(false);
      }
    });

    _passwordFocus.addListener(() {
      if (_passwordFocus.hasFocus) {
        if (isHandsUp != null) isHandsUp!.change(true);
        if (isCheking != null) isCheking!.change(false);
      } else {
        if (isHandsUp != null) isHandsUp!.change(false);
      }
    });
  }

  void _onEmailChanged(String value) {
    _emailIdleTimer?.cancel();
    if (isCheking != null) isCheking!.change(true);
    if (isHandsUp != null) isHandsUp!.change(false);

    if (numlook != null) numlook!.value = value.length.toDouble();

    _emailIdleTimer = Timer(const Duration(seconds: 3), () {
      if (numlook != null) numlook!.value = 0;
      if (isCheking != null) isCheking!.change(false);
    });
  }

  void _validateLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      if (email == 'cristian@gmail.com' && password == '123456') {
        triggerSuccess?.fire();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login exitoso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        triggerFail?.fire();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email o contraseña incorrecta'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailIdleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'animated_login_character.riv',
                  stateMachines: ['Login Machine'],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (controller == null) return;
                    artboard.addController(controller!);

                    isCheking = controller!.findSMI<SMIBool>("isChecking");
                    isHandsUp = controller!.findSMI<SMIBool>("isHandsUp");
                    triggerSuccess = controller!.findSMI<SMITrigger>("trigSuccess");
                    triggerFail = controller!.findSMI<SMITrigger>("trigFail");
                    numlook = controller!.findSMI<SMINumber>("numLook");
                  },
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                onChanged: _onEmailChanged,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  "Forgot your password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),

              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _validateLogin,
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
