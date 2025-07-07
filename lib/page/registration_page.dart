import 'package:e_commerce/home/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/google_sign_in.dart';
import '../home/home_screen.dart' as userCredential;
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool isSigningUp = false;
  bool isGoogleLoading = false;



  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }


  //

  String? _validateNonEmpty(String? v, String label) {
    if (v == null || v.isEmpty) return 'Enter your $label';
    return null;
  }

  String? _validateEmail(String? v) {
    final err = _validateNonEmpty(v, 'email');
    if (err != null) return err;
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)) {
      return 'Enter a valid email';
    }
    return null;
  }

  //

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSigningUp = true);

      try {
        UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text.trim(),
        );

        final user = credential.user;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(user: user!), // ✅ Passing the created user
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'Something went wrong!';
        if (e.code == 'email-already-in-use') {
          message = 'Email already in use.';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() => isSigningUp = false);
      }
    }
  }

  //


  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: inputDecoration.copyWith(hintText: 'Username'),
                    validator: (v) => _validateNonEmpty(v, 'username'),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _emailCtrl,
                    decoration: inputDecoration.copyWith(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() =>
                        _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) {
                      final err = _validateNonEmpty(v, 'password');
                      if (err != null) return err;
                      if (v!.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() =>
                        _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: (v) {
                      final err =
                      _validateNonEmpty(v, 'password confirmation');
                      if (err != null) return err;
                      if (v != _passwordCtrl.text) {
                        return 'Passwords don’t match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: isSigningUp ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: isSigningUp
                        ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                        : const Text('SIGN UP',
                        style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                            },

                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      UserCredential? userCredential = await signInWithGoogle();
                      if (userCredential != null) {
                        print("Signed in as: ${userCredential.user?.displayName}");

                        // ✅ Navigate to HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(user: userCredential.user!),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 2,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png', // ✅ make sure this asset exists and is declared in pubspec.yaml
                          height: 24.0,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
