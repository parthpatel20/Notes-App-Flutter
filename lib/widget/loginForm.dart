import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/authController.dart';
import 'package:notes/data/model/Validators.dart';
import 'package:notes/data/model/authModel.dart';
import 'ToolsWiget/textWidget.dart';

class LoginForm extends StatelessWidget {
  final AuthController _authController = Get.find();
  final GlobalKey<FormState> loginForm = GlobalKey<FormState>();
  final Validatiors _validatiors = Validatiors();
  final AuthModel _authModel = AuthModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: loginForm,
        child: Column(children: [
          Padding(padding: EdgeInsets.all(10)),
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
          Padding(padding: EdgeInsets.all(10)),
          SizedBox(
            width: 100,
            height: 40,
            child: RaisedButton(
                child: Text("Sign In"),
                onPressed: () {
                  if (loginForm.currentState.validate()) {
                    loginForm.currentState.save();
                    _authController.login(_authModel);
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: FlatButton(
              onPressed: () {},
              child: Text("Forgot Password?"),
            ),
          ),
          // Divider(
          //   thickness: 1,
          // ),
          // Container(
          //   height: 70,
          //   width: 70,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     image: DecorationImage(
          //         fit: BoxFit.contain,
          //         image: NetworkImage(
          //             "https://freeiconshop.com/wp-content/uploads/edd/google-flat.png")),
          //   ),
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: Padding(
          //       padding: EdgeInsets.all(0),
          //     ),
          //   ),
          // )
        ]),
      ),
    );
  }
}
