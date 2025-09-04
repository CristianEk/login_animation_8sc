import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // lógica de animaciones
  StateMachineController? controller;
  // state machine inputs
  SMIBool? isChecking; // el oso chismoso
  SMIBool? isHandsUp;  // se tapa los ojos
  SMITrigger? triggerSuccess; // se emociona
  SMITrigger? triggerFail;    // se pone triste
  SMINumber? numLook; // ya existe en la animación

  

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            // eje vertical
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'animated_login_character.riv',
                  stateMachines: ["Login Machine"], // 👈 corregido
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine", // 👈 corregido
                    );
                    if (controller == null) return;
          
                    artboard.addController(controller!);
          
                    // enlaza la animación con la app
                    isChecking = controller!.findSMI<SMIBool>('isChecking'); // 👈 corregido
                    isHandsUp = controller!.findSMI<SMIBool>('isHandsUp');   // 👈 corregido
                    triggerSuccess = controller!.findSMI<SMITrigger>('trigSuccess'); // 👈 corregido
                    triggerFail = controller!.findSMI<SMITrigger>('trigFail');       // 👈 corregido
                    numLook = controller!.findSMI<SMINumber>('numLook'); // aquí lo conectas
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  // no se tapa las manos cuando escribes email
                  if (isHandsUp != null) {
                    isHandsUp!.change(false);
                  }
                  if (isChecking != null) {
                    isChecking!.change(true);
                  }
                    if (numLook != null) {
                    int lookValue = value.length; 
                    if (lookValue > 1000) lookValue = 1000; // no exceder el máximo
                    numLook!.change(lookValue.toDouble());
                  }
                },  
                keyboardType: TextInputType.emailAddress,
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
                onChanged: (value) {
                  // no mueve sus ojos
                  if (isChecking != null) {
                    isChecking!.change(false);
                  }
                  if (isHandsUp != null) {
                    isHandsUp!.change(true);
                  }
                },
                obscureText: !_isPasswordVisible,
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
                child: const Text(
                  "Forgot your password?",
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              // botón de login
              const SizedBox(height: 10),
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {},
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
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
                        "Create now!",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
