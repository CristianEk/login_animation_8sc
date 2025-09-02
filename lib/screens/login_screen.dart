import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(child:Column(
        //Axis o eje vertical
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            //Ancho de la pantalla calculado por MQ
            width: size.width,
            height: 200,
            child: RiveAnimation.asset('animated_login_character.riv'),
          ),
          SizedBox(height: 10),
          TextField(
            keyboardType:TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon: const Icon(Icons.mail),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
           SizedBox(height: 10),
          TextField(
            //para que se oculten las contraseñas
            obscureText:! _isPasswordVisible,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width,
            child: const Text("Forgot your password?",
            textAlign: TextAlign.right,
            style: TextStyle(decoration: TextDecoration.underline),
            ),
          )
        ],
      )),
    );
  }
}

 

