import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) submitFuc;
  // ignore: unused_field
  final bool _isLoading;
  AuthForm(this.submitFuc, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';
  // ignore: unused_field
  File _userImageFile;

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _userImageFile == null) {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("please pick an image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFuc(
        _email.trim(),
        _password.trim(),
        _username.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(_pickedImage),
                    TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      key: ValueKey('email'),
                      validator: (val) {
                        if (val.isEmpty || !val.contains('@')) {
                          return "please enter a valid email address";
                        }
                        return null;
                      },
                      onSaved: (val) => _email = val,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: "Email Address"),
                    ),
                    if (!_isLogin)
                      TextFormField(
                        autocorrect: true,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.words,
                        key: ValueKey('username'),
                        validator: (val) {
                          if (val.isEmpty || val.length < 4) {
                            return "please enter at least 4 characters";
                          }
                          return null;
                        },
                        onSaved: (val) => _username = val,
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (val) {
                        if (val.isEmpty || val.length < 7) {
                          return "please enter at least 7 characters";
                        }
                        return null;
                      },
                      onSaved: (val) => _password = val,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget._isLoading) CircularProgressIndicator(),
                    if (!widget._isLoading)
                      // ignore: deprecated_member_use
                      RaisedButton(
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        onPressed: _submit,
                      ),
                    if (!widget._isLoading)
                      // ignore: deprecated_member_use
                      FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          child: Text(_isLogin
                              ? 'Create New Account'
                              : 'I already have an Account'),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          }),
                  ],
                )),
          )),
    );
  }
}
