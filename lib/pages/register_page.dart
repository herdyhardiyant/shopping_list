import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/authentication/user.dart';
import 'package:shopping_list/pages/shopping_list_page.dart';

import '../widgets/form_button.dart';
import './login_page.dart';
import '../widgets/password_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;
  late String _repeatPassword;
  late bool _isUserAlreadyExist = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gap = 18.0;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(gap),
          child: Column(
            children: <Widget>[
              const Spacer(),
              const Text(
                "Register",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const Spacer(),
              TextFormField(
                decoration: const InputDecoration(
                    label: Text("Username"), border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be empty';
                  } else if (_isUserAlreadyExist) {
                    return 'Username is already exist';
                  } else {
                    return null;
                  }
                },
                onSaved: (text) {
                  _username = text!;
                },
              ),
              const SizedBox(
                height: gap,
              ),
              PasswordField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 6) {
                    return 'Password length cannot be less than 6 character';
                  } else if (_password != _repeatPassword) {
                    return "Password and Repeat Password aren't equal!";
                  } else {
                    return null;
                  }
                },
                name: "Password",
                onSaved: (text) {
                  _password = text;
                },
              ),
              const SizedBox(
                height: gap,
              ),
              PasswordField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 6) {
                    return 'Password length cannot be less than 6 character';
                  } else if (_password != _repeatPassword) {
                    return "Password and Repeat Password aren't equal!";
                  } else {
                    return null;
                  }
                },
                name: "Repeat password",
                onSaved: (text) {
                  _repeatPassword = text;
                },
              ),
              const SizedBox(
                height: gap,
              ),
              FormButton(
                  name: "Register",
                  onTap: () {
                    _saveForm();
                  }),
              const Spacer(),
              const SizedBox(
                height: gap,
              ),
              const Text("Already have an account?"),
              const SizedBox(
                height: gap,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
                child: const Text("Login Here"),
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
    _isUserAlreadyExist = await Provider.of<User>(context, listen: false)
        .checkIsUserExist(_username);
    if (_formKey.currentState!.validate()) {
      _registerThenNavigate();
    }
  }

  void _registerThenNavigate(){
    Provider.of<User>(context, listen: false)
        .registerUser(_username, _password)
        .then((_) {
      Navigator.pushReplacementNamed(context, ShoppingListPage.routeName);
    });
  }


}
