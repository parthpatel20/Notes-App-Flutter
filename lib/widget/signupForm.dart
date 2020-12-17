import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/authController.dart';
import 'package:notes/data/model/Validators.dart';
import 'package:notes/data/model/authModel.dart';

import 'ToolsWiget/textWidget.dart';

class SignUpForm extends StatelessWidget {
  final AuthController _authController = Get.find();
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final AuthModel _authModel = AuthModel();
  final Validatiors _validatiors = Validatiors();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _signInFormKey,
        child: Column(children: [
          Padding(padding: EdgeInsets.all(10)),
          TextWidget(
            name: "Name",
            passText: false,
            onValidate: (String val) {
              if (_validatiors.validateName(val)) {
                return "Name is required";
              }
              return null;
            },
            onSaved: (String val) {
              _authModel.name = val;
            },
          ),
          Padding(padding: EdgeInsets.all(5)),
          TextWidget(
            name: "Email",
            passText: false,
            onValidate: (String val) {
              if (_validatiors.validateName(val)) {
                return "Email is Required";
              }
              if (!_validatiors.validateEmail(val)) {
                return "email is not in correct format.";
              }
              return null;
            },
            onSaved: (String val) {
              _authModel.email = val;
            },
          ),
          Padding(padding: EdgeInsets.all(5)),
          TextWidget(
            name: "Password",
            passText: true,
            onValidate: (String val) {
              if (_validatiors.validateName(val)) {
                return "Password is Required";
              }
              if (!_validatiors.validatePassword(val)) {
                _authModel.password = val;
                return "Password must be more then 6 character";
              }
              _authModel.password = val;
              return null;
            },
            onSaved: (String val) {
              _authModel.password = val;
            },
          ),
          TextWidget(
            name: "Confirm Password",
            passText: true,
            onValidate: (String val) {
              if (_validatiors.validateName(val)) {
                return "Password is Required";
              }
              if (!_validatiors.validatePassword(val)) {
                return "Password must be more then 6 character";
              }
              if (_authModel.password != val) {
                return "Password is not matched";
              }
              _authModel.password = val;
              return null;
            },
            onSaved: (String val) {
              _authModel.password = val;
            },
          ),
          Padding(padding: EdgeInsets.all(10)),
          SizedBox(
            width: 100,
            height: 40,
            child: RaisedButton(
              child: Text("Sign Up"),
              onPressed: () {
                if (_signInFormKey.currentState.validate()) {
                  _signInFormKey.currentState.save();
                  _authController.createUser(_authModel);
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
