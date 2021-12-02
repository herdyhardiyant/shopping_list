import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String name;
  final Function onTap;

  const FormButton({Key? key, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: const Text("Register"),
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50)),
    );
  }
}
