import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String name;
//  final TextEditingController textEditingController;
  final bool passText;
  final Function onSaved;
  final Function onChange;
  final Function onValidate;

  TextWidget(
      {this.name, this.passText, this.onValidate, this.onChange, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: passText,
      decoration: InputDecoration(
        hintText: name,
      ),
      onSaved: onSaved,
      onChanged: onChange,
      validator: onValidate,
      //expands: true,
    );
  }
}
