import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_house/home.dart';
import 'package:notes_house/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
            options: const FirebaseOptions(
          apiKey: 'AIzaSyAp8K3PvwauLkSA29wWJc1h1KLSN9G-5dw',
          appId: '1:769880525135:ios:63ea6ca6651eabdbe45d3a',
          messagingSenderId: '769880525135',
          projectId: 'noteshouse-72',
          storageBucket: 'noteshouse-72.appspot.com',
        ));
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  runApp(user == null ? MyApp():  MaterialApp(
    title: 'Notes House',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(109, 216, 180, 1)),
      useMaterial3: true,
    ),
    home: HomePage()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes House',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(109, 216, 180, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Notes House'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = true;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(109, 216, 180, 1),
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(child:
            Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 30.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .4,
                          child: Center(
                            child: DotLottieLoader.fromAsset("assets/lottie/login.lottie",
                                frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                                  if (dotlottie != null) {
                                    return Lottie.memory(dotlottie.animations.values.single);
                                  } else {
                                    return Container();
                                  }
                                }
                            ),),
                      ),
                      // const SizedBox(height: 30.0),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400.0),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(fontSize: 16.0),
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            maxLength: 64,
                            onEditingComplete: () => FocusScope.of(context).nextFocus(),
                            onChanged: (value) {
                              setState(() {
                                _isButtonDisabled =
                                !_isFormValid(); // Update button disabled status based on form validity
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              labelText: 'Email',
                              hintText: 'noteshouse@email.com',
                              labelStyle:
                              TextStyle(color: Colors.black),
                              hintStyle:
                              TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.black,

                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400.0),
                          child: TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(fontSize: 16.0),
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: !_isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            maxLength: 20,
                            onChanged: (value) {
                              setState(() {
                                _isButtonDisabled =
                                !_isFormValid(); // Update button disabled status based on form validity
                              });
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              labelText: 'Password',
                              hintText: 'Password',
                              labelStyle: const TextStyle(
                                  color: Colors.black),
                              hintStyle: const TextStyle(
                                  color: Colors.grey),
                              prefixIcon: const Icon(
                                Icons.password,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.97,
                            constraints: const BoxConstraints(maxWidth: 400.0),
                            child: ElevatedButton(
                              onPressed: _isButtonDisabled ? null : _handleSignUp,
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.disabled)) {
                                      return const  Color.fromRGBO(109, 216, 180, .5);
                                    } else if (states.contains(MaterialState.pressed)) {
                                      return const Color.fromRGBO(109, 216, 180, .5);
                                    }
                                    return const  Color.fromRGBO(109, 216, 180, 1);
                                  },
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            ),

        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white, // Background color of the button area
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUp()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromRGBO(255, 255, 255, 1);
                    }
                    return const Color.fromRGBO(255, 255, 255, 1);
                  },
                ),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.white; // Color when hovered
                  },
                ),
              ),
              child: const Text(
                'SignUp',
                style: TextStyle(
                  color:  Color.fromRGBO(109, 216, 180, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to handle sign-up button press
  void _handleSignUp() async {
    // Perform sign-up if validation passes
    if (_isFormValid()) {
      // Add your sign-up logic here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: DotLottieLoader.fromAsset("assets/lottie/process.lottie",
                    frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                      if (dotlottie != null) {
                        return Lottie.memory(dotlottie.animations.values.single, fit: BoxFit.fill);
                      } else {
                        return Container();
                      }
                    }
                ),
              ),
            ),
          );
        },
      );
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.toString().trim(),
          password: _passwordController.text.toString().trim(),
        );
        Fluttertoast.showToast(
            msg: "LogIn successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      } on FirebaseAuthException catch (e) {
          Fluttertoast.showToast(
              msg: "Invalid Credentials!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
      } catch (e) {
        print(e);
        Navigator.pop(context);
      }
    }
  }

  // Method to check form validity
  bool _isFormValid() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final bool isEmailValid = email.isNotEmpty && isValidEmail(email);
    final bool isPasswordValid = password.isNotEmpty && password.length >= 6;

    return isEmailValid && isPasswordValid;
  }

  // Method to validate email format
  bool isValidEmail(String email) {
    String emailRegex =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Regular expression for email validation
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}
