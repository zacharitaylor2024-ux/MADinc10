import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// 🧓 Great-Grandparent
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
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
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();
  
  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( // 👨 Parent
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // 🚀 Sign Up Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Demo signup complete — your form passed validation!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SignupTip(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupTip extends StatefulWidget {
  const SignupTip({super.key});

  @override
  State<SignupTip> createState() => _SignupTipState();
}

class _SignupTipState extends State<SignupTip> {
  static const String _category = 'password_help';

  static const Map<String, List<String>> _tips = {
    'password_help': [
      'Do not be afraid to create a long complicated password, especially if you plan to save this password to a password manager.',
      'The most common password is "password", so do not use it.',
      'Including capital letters, numbers, and symbols can significantly increase the strength of your password.'
      'Once you make an account there will be a forgot password feature so make it as secure as possible.',
    ],
  };

  bool _loading = false;
  bool _failNextRequest = false;
  String? _tip;
  String? _error;
  int _nextTip = 0;

  Future<void> _getTip() async {
    if (_loading) return;

    final shouldFail = _failNextRequest;

    setState(() {
      _loading = true;
      _tip = null;
      _error = null;
      _failNextRequest = false;
    });

    await Future<void>.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    if (shouldFail) {
      setState(() {
        _loading = false;
        _error = 'Demo error: the tip could not be loaded. Try again.';
      });
      return;
    }

    final matchingTips = _tips[_category]!;
    final selectedTip = matchingTips[_nextTip % matchingTips.length];
    _nextTip++;

    setState(() {
      _loading = false;
      _tip = selectedTip.length <= 240
          ? selectedTip
          : selectedTip.substring(0, 240);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton(
          onPressed: _loading ? null : _getTip,
          child: Text(
            _loading ? 'Loading tip...' : 'Get a signup tip',
          ),
        ),
        if (_loading) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ],
        if (_tip != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Preset demo tip—not live AI.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(_tip!),
        ],
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!),
          TextButton(
            onPressed: _loading ? null : _getTip,
            child: const Text('Retry'),
          ),
        ],
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Demo: fail the next tip request'),
          value: _failNextRequest,
          onChanged: _loading
              ? null
              : (value) {
                  setState(() {
                    _failNextRequest = value;
                  });
                },
        ),
      ],
    );
  }
}

