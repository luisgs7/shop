import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { Login, Signup }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if(_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          )
        ],
      )
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
    if(_isLogin()){
      // login
      await auth.login(_authData['email']!, _authData['password']!);
    } else {
      // signup
      await auth.signup(_authData['email']!, _authData['password']!);
    }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    }catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
    setState(() => _isLoading = false);
    
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _authData['email'] = value ?? '',
              validator: (_email) {
                final email = _email ?? '';
                if (email.trim().isEmpty || !email.contains('@')) {
                  return 'Informe um e-mail válido';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
              controller: _passwordController,
              onSaved: (value) => _authData['password'] = value ?? '',
              validator: (_password) {
                final password = _password ?? '';
                if (password.trim().isEmpty || password.length < 5) {
                  return 'Informe uma senha válida';
                }
                return null;
              },
            ),
            if (_isSignup())
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: _isLogin()
                    ? null
                    : (_password) {
                        final password = _password ?? '';
                        if (password != _passwordController.text) {
                          return 'Senhas não coincidem';
                        }
                        return null;
                      },
              ),
            SizedBox(height: 20),
            if(_isLoading)
              CircularProgressIndicator()
            else
            ElevatedButton(
              onPressed: _submit,
              child: Text(
                _isLogin() ? 'Entrar' : 'Registrar',
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: _switchAuthMode,
              child: Text(
                _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'
              ),
            )
          ],
        )),
      ),
    );
  }
}
