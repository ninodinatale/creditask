import 'package:creditask/graphql/api.dart';
import 'package:creditask/providers/auth.dart';
import 'package:creditask/providers/graphql.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_shared/loadnig_button_content.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  bool isLoading = false;
  String loginError;

  final _formKey = GlobalKey<FormState>();

  void onLoginPressed(AuthProvider auth) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      this.setState(() {
        this.isLoading = true;
      });

      await artemisClient
          .execute(TokenAuthMutation(
              variables:
                  TokenAuthArguments(email: username, password: password)))
          .catchError((error) {
        this.setState(() {
          this.loginError = 'Ein Verbindungsfehler ist aufgetreten';
          this.isLoading = false;
        });
      }).then((result) async {
        if (result != null) {
          if (result.hasErrors) {
            this.setState(() {
              this.loginError = 'Benutzername oder Passwort falsch';
              this.isLoading = false;
            });
          } else {
            auth.setAuth(
                result.data.tokenAuth.token, result.data.tokenAuth.user);
            this.setState(() {
              this.isLoading = false;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Scaffold(
        body: Center(
            child: SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text('Login',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold))),
                      TextFormField(
                        onSaved: (value) => username = value,
                        decoration: const InputDecoration(
                          hintText: 'Benutzername',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onSaved: (value) => password = value,
                        decoration: const InputDecoration(
                          hintText: 'Passwort',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Eingabe darf nicht leer sein';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      Container(
                        child: Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 15),
                            child: this.loginError != null
                                ? Text(
                                    this.loginError,
                                    style: TextStyle(
                                        color: Theme.of(context).errorColor),
                                  )
                                : null),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: this.isLoading
                              ? null
                              : () => onLoginPressed(auth),
                          child: LoadingButtonContent(isLoading, 'Login'),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
