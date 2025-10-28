import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
      ),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final List<String> _avatars = const ['🤑', '🚀', '👽', '👹', '🤖'];
  String _selectedAvatar = '🤑';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(
            name: _nameController.text.trim(),
            avatarEmoji: _selectedAvatar,
          ),
        ),
      );
    }
  }

  String? _required(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join Us Today for the Cash Money!')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => _required(v, 'Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final req = _required(v, 'Email');
                  if (req != null) return req;
                  final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v!.trim());
                  return ok ? null : 'Enter a valid email';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) {
                  final req = _required(v, 'Password');
                  if (req != null) return req;
                  return v!.length >= 6 ? null : 'Minimum 6 characters';
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (v) {
                  final req = _required(v, 'Confirm Password');
                  if (req != null) return req;
                  return v == _passwordController.text
                      ? null
                      : 'Passwords do not match';
                },
              ),
              const SizedBox(height: 20),
              Text('Pick an avatar', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _avatars.map((e) {
                  final selected = _selectedAvatar == e;
                  return ChoiceChip(
                    label: Text(e, style: const TextStyle(fontSize: 18)),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedAvatar = e),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submit,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final String name;
  final String avatarEmoji;
  const WelcomeScreen({super.key, required this.name, required this.avatarEmoji});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  bool _celebrating = true;
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // After 2 seconds, end celebration and start fade+scale for content
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _celebrating = false);
      _controller.forward(from: 0);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _celebration() {
    // Confetti using big emojis that fade out
    return Stack(
      fit: StackFit.expand,
      children: [
      Center(child: Text('🎉', style: TextStyle(fontSize: MediaQuery.of(context).size.shortestSide * 0.3))),
      Align(alignment: const Alignment(-0.8, -0.6), child: const Text('✨', style: TextStyle(fontSize: 48))),
      Align(alignment: const Alignment(0.9, -0.2), child: const Text('🎊', style: TextStyle(fontSize: 44))),
      Align(alignment: const Alignment(-0.3, 0.7), child: const Text('🥳', style: TextStyle(fontSize: 52))),
      Align(alignment: const Alignment(0.6, 0.8), child: const Text('🎈', style: TextStyle(fontSize: 46))),
      Align(alignment: const Alignment(-0.9, 0.2), child: const Text('💥', style: TextStyle(fontSize: 50))),
      Align(alignment: const Alignment(0.3, -0.8), child: const Text('💫', style: TextStyle(fontSize: 42))),
      Align(alignment: const Alignment(-0.6, -0.2), child: const Text('🎇', style: TextStyle(fontSize: 40))),
      Align(alignment: const Alignment(0.7, 0.4), child: const Text('🎆', style: TextStyle(fontSize: 48))),
      ],
    );
  }

  Widget _content() {
    final title = 'Welcome, ${widget.name}!';
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.avatarEmoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _celebrating ? _celebration() : _content(),
        ),
      ),
    );
  }
}