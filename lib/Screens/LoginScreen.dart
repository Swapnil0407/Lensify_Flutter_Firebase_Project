import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

import '../app_keys.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _obscure = true;
  bool _loading = false;

  final _email = TextEditingController();
  final _password = TextEditingController();

  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _bgController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    return RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password) &&
        RegExp(r'[^A-Za-z0-9]').hasMatch(password);
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

  Future<void> _login() async {
    final email = _email.text.trim();
    final password = _password.text;

    if (email.isEmpty || !_isValidEmail(email)) {
      _toast('Enter valid email');
      return;
    }
    if (password.isEmpty || !_isStrongPassword(password)) {
      _toast('Password must contain letter, number & symbol');
      return;
    }

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      rootScaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('You are logged in'),
            backgroundColor: Colors.green,
          ),
        );

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? 'Login failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 🎬 ANIMATED PROFESSIONAL BACKGROUND
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
                        _bgAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF6366F1),
                        const Color(0xFF8B5CF6),
                        _bgAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF7C3AED),
                        const Color(0xFF9333EA),
                        _bgAnimation.value,
                      )!,
                    ],
                  ),
                ),
              );
            },
          ),

          /// 🔐 CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100),

                  const Text(
                    "WELCOME BACK!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Please login to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _input(
                    controller: _email,
                    hint: "Enter your email",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 30),

                  _input(
                    controller: _password,
                    hint: "Enter your password",
                    icon: Icons.lock_outline,
                    obscure: _obscure,
                    suffix: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A8A1F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _loading ? null : _login,
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Center(
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () => Navigator.pushNamed(context, "/signup"),
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "Sign Up",
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
            const ModalBarrier(dismissible: false, color: Colors.black45),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
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
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
