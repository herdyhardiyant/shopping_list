import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String? Function(String?)? validator;
  final String name;
  final void Function(String) onSaved;

  const PasswordField(
      {Key? key, required this.validator, required this.name, required this.onSaved})
      : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  var _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !_isVisible,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: _isVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
          ),
          label: Text(widget.name),
          border: const OutlineInputBorder()),
      validator: (value) {
        return widget.validator!(value);
      },
      onSaved:(password){
        widget.onSaved(password!);
      },
    );
  }
}
