import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

import '../app_keys.dart';
import 'shared/screen_entrance.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen>
    with SingleTickerProviderStateMixin {

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _loading = false;

  // 🎬 Background animation
  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);

    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _bgController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSymbol = RegExp(r'[^A-Za-z0-9]').hasMatch(password);
    return hasLetter && hasNumber && hasSymbol;
  }

  void _toast(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }

  Future<void> _signUp() async {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final password = _password.text;
    final confirm = _confirmPassword.text;

    if (name.isEmpty) {
      _toast('Enter your name');
      return;
    }
    if (!_isValidEmail(email)) {
      _toast('Enter valid email');
      return;
    }
    if (!_isStrongPassword(password)) {
      _toast('Password must contain letter, number & symbol');
      return;
    }
    if (password != confirm) {
      _toast('Passwords do not match');
      return;
    }

    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await cred.user?.updateDisplayName(name);

      if (!mounted) return;

      rootScaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          content: Text('User registered successfully'),
          backgroundColor: Colors.green,
        ));

      await FirebaseAuth.instance.signOut();
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? 'Sign up failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ScreenEntrance(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [

            /// 🎬 ANIMATED SIGNUP BACKGROUND
            AnimatedBuilder(
              animation: _bgAnimation,
              builder: (_, __) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(
                            const Color(0xFF1E3A8A),
                            const Color(0xFF3B82F6),
                            _bgAnimation.value)!,
                        Color.lerp(
                            const Color(0xFF6366F1),
                            const Color(0xFF8B5CF6),
                            _bgAnimation.value)!,
                        Color.lerp(
                            const Color(0xFF7C3AED),
                            const Color(0xFF9333EA),
                            _bgAnimation.value)!,
                      ],
                    ),
                  ),
                );
              },
            ),

            /// 🔐 SIGNUP CONTENT
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    const Text(
                      "WELCOME!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Create your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 40),

                    _input(_name, "Enter your Name", Icons.person),
                    const SizedBox(height: 16),

                    _input(_email, "Enter your email", Icons.email_outlined),
                    const SizedBox(height: 16),

                    _input(_password, "Enter your password",
                        Icons.lock_outline, obscure: true),
                    const SizedBox(height: 16),

                    _input(_confirmPassword, "Re-enter your password",
                        Icons.lock_outline, obscure: true),

                    const SizedBox(height: 28),

                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A8A1F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _loading ? null : _signUp,
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    InkWell(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_loading) ...[
              const ModalBarrier(
                  dismissible: false, color: Colors.black45),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: const Color(0xFF0A8A1F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
