import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strings/constatnts.dart';
import '../bloc/auth_bloc.dart';

// ignore: must_be_immutable
class FromWidget extends StatefulWidget {
  AuthMode authMode;
  final bool isLoading;

  FromWidget({
    Key? key,
    required this.authMode,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<FromWidget> createState() => _FromWidgetState();
}

class _FromWidgetState extends State<FromWidget> {
  void _switchAuthMode() {
    if (widget.authMode == AuthMode.Login) {
      setState(() {
        widget.authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        widget.authMode = AuthMode.Login;
      });
    }
  }

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
              onSaved: (value) {
                print(value);
                _authData['email'] = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty || value.length < 5) {
                  return 'Password is too short!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value!;
              },
            ),
            if (widget.authMode == AuthMode.Signup)
              TextFormField(
                enabled: widget.authMode == AuthMode.Signup,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: widget.authMode == AuthMode.Signup
                    ? (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match!';
                        }
                        return null;
                      }
                    : null,
              ),
            const SizedBox(
              height: 20,
            ),
            if (widget.isLoading)
              const CircularProgressIndicator()
            else
              TextButton(
                onPressed: validateThenAuhtenticate,
                child: Text(
                    widget.authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
              ),
            TextButton(
              onPressed: _switchAuthMode,
              child: Text(
                  '${widget.authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
            ),
          ],
        ),
      ),
    );
  }

  void validateThenAuhtenticate() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      if (widget.authMode == AuthMode.Login) {
        BlocProvider.of<AuthBloc>(context).add(
          LoginEvent(
              email: _authData['email']!, password: _authData['password']!),
        );
      } else if (widget.authMode == AuthMode.Signup) {
        BlocProvider.of<AuthBloc>(context).add(
          SignUpEvent(
              email: _authData['email']!, password: _authData['password']!),
        );
      }
    }
  }
}
