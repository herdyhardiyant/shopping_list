import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/form_button.dart';
import './register_page.dart';
import '../widgets/password_field.dart';
import '../authentication/user.dart';
import './shopping_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;
  late bool _isAuthorized;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    const gap = 18.0;
    return Scaffold(
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(gap),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Spacer(),
              const Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const Spacer(),
              TextFormField(
                onSaved: (text) {
                  _username = text!;
                },
                decoration: const InputDecoration(
                    label: Text("Username"), border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be empty';
                  } else if (!_isAuthorized) {
                    return "Password or Username is incorrect";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: gap,
              ),
              PasswordField(
                  onSaved: (text) {
                    _password = text;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    } else if (!_isAuthorized) {
                      return "Password or Username is incorrect";
                    } else {
                      return null;
                    }
                  },
                  name: "Password"),
              const SizedBox(
                height: gap,
              ),
              FormButton(
                  name: "Login",
                  onTap: () {
                    _saveForm();
                  }),
              const Spacer(),
              const SizedBox(
                height: gap,
              ),
              const Text("Don't have an account?"),
              const SizedBox(
                height: gap,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, RegisterPage.routeName);
                },
                child: const Text("Register Here"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    _formKey.currentState!.save();
    _isAuthorized = await Provider.of<User>(context, listen: false)
        .loginUser(_username, _password);
    validateAndThenRoute();
  }

  void validateAndThenRoute() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Navigator.pushReplacementNamed(context, ShoppingListPage.routeName);
      setState(() {
        _isLoading = false;
      });
    }
  }
}
