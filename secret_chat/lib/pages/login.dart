import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:secret_chat/api/auth_api.dart';
import 'package:secret_chat/utils/responsive.dart';
import 'package:secret_chat/widgets/circle.dart';
import 'package:secret_chat/widgets/input_text.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _authApi = AuthApi();
  var _email = '', _password = '';
  var _isFetching = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  _submit() async {
    if (_isFetching) return;

    final isValid = _formKey.currentState.validate();

    if (isValid) {
      setState(() {
        _isFetching = true;
      });
      final isOk =
          await _authApi.login(context, email: _email, password: _password);
      setState(() {
        _isFetching = false;
      });
      if (isOk) {
        print('LOGIN OK');
        Navigator.pushNamed(context, "home");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -size.width * 0.22,
              top: -size.width * 0.36,
              child: Circle(
                radius: size.width * 0.45,
                colors: [Colors.pink, Colors.pinkAccent],
              ),
            ),
            Positioned(
              left: -size.width * 0.15,
              top: -size.width * 0.34,
              child: Circle(
                radius: size.width * 0.35,
                colors: [Colors.orange, Colors.deepOrange],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: size.width,
                height: size.height,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: responsive.wp(25),
                            height: responsive.wp(25),
                            margin: EdgeInsets.only(top: size.width * 0.3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26, blurRadius: 25),
                                ]),
                          ),
                          SizedBox(height: responsive.hp(4)),
                          Text(
                            'Hello again \nwelcome back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: responsive.ip(2.5),
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 310,
                                minWidth: 310,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    InputText(
                                        label: "EMAIL ADDRESS",
                                        validator: (String text) {
                                          if (text.contains("@")) {
                                            _email = text;
                                            return null;
                                          }
                                          return "Invalid Email";
                                        },
                                        inputType: TextInputType.emailAddress,
                                        fontSize: responsive.ip(1.8)),
                                    SizedBox(height: responsive.hp(3)),
                                    InputText(
                                        label: "PASSWORD",
                                        validator: (String text) {
                                          if (text.isNotEmpty &&
                                              text.length > 5) {
                                            _password = text;
                                            return null;
                                          }
                                          return "Invalid Password";
                                        },
                                        isSecure: true,
                                        fontSize: responsive.ip(1.8)),
                                  ],
                                ),
                              )),
                          SizedBox(height: responsive.hp(15)),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 310,
                              minWidth: 310,
                            ),
                            child: CupertinoButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: responsive.ip(2)),
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(4),
                              onPressed: () => _submit(),
                              child: Text('Sign in',
                                  style:
                                      TextStyle(fontSize: responsive.ip(2.5))),
                            ),
                          ),
                          SizedBox(height: responsive.hp(2)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('New to Frendly Desi?',
                                  style: TextStyle(
                                      fontSize: responsive.ip(2),
                                      color: Colors.black54)),
                              CupertinoButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, "signup"),
                                child: Text('Sign up',
                                    style: TextStyle(
                                        fontSize: responsive.ip(2),
                                        color: Colors.pinkAccent)),
                              )
                            ],
                          ),
                          SizedBox(height: responsive.hp(5))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            _isFetching
                ? Positioned.fill(
                    child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: CupertinoActivityIndicator(radius: 15),
                    ),
                  ))
                : Container()
          ],
        ),
      ),
    ));
  }
}
