import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:lottie/lottie.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _isButtonDisabled = true;
  bool _isPasswordVisible = false;
  bool _isPasswordVisible1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(109, 216, 180, 1),
        title: const Text(
          "Notes House",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Add functionality to navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 30.0),
              SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: Center(
                  child: DotLottieLoader.fromAsset("assets/lottie/signUp.lottie",
                      frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                        if (dotlottie != null) {
                          return Lottie.memory(dotlottie.animations.values.single);
                        } else {
                          return Container();
                        }
                      }
                  ),),
              ),
              // const SizedBox(height: 10.0),
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
                    maxLength: 20,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    // onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    style: const TextStyle(fontSize: 16.0),
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 20,
                    obscureText: !_isPasswordVisible1,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _isFormValid() ? _handleSignUp : null,
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
                      labelText: 'Confirm Password',
                      hintText: 'Confirm Password',
                      labelStyle: const TextStyle(
                          color:  Colors.black),
                      hintStyle: const TextStyle(
                          color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible1 = !_isPasswordVisible1;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible1
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
                              return const  Color.fromRGBO(109, 216, 180, .5);
                            }
                            return const  Color.fromRGBO(109, 216, 180, 1);
                          },
                        ),
                      ),
                      child: const Text(
                        "SignUp",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white, // Background color of the button area
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Have an account"),
            TextButton(
              onPressed: () {
                // Add your button action here
                Navigator.of(context)
                    .pop(); // Add functionality to navigate back
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
                'Login',
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.toString().trim(),
          password: _passwordController.text.toString().trim(),
        );
        Fluttertoast.showToast(
            msg: "User registered successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false, // This determines which routes to remove
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: "Email is already in use!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }
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
    final String confirmPassword = _confirmPasswordController.text.trim();

    // Add validation logic
    final bool isEmailValid = email.isNotEmpty && isValidEmail(email);
    final bool isPasswordValid = password.isNotEmpty &&
        password == confirmPassword &&
        password.length >= 6;

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
