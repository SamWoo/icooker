import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icooker/config/Config.dart';
import 'package:icooker/provider/login_provider.dart';
import 'package:icooker/router/routes.dart';
import 'package:icooker/services/http_service.dart';
import 'package:icooker/utils/spHelper.dart';
import 'package:icooker/widgets/third_login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final _textEditingController = TextEditingController();
  final _loginKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _textEditingController = TextEditingController();
  final TapGestureRecognizer recognizer = TapGestureRecognizer();

  String username, password;
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomPadding: false, //解决软键盘弹出导致页面布局报错
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_login.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.grey[100].withOpacity(0.6), BlendMode.srcOver),
          ),
        ),
        child: _form(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.text = 'username';
    recognizer.onTap = () {
      Routes.navigateTo(context, '/register');
      Fluttertoast.showToast(
          msg: '您好，欢迎注册成为会员!', toastLength: Toast.LENGTH_SHORT);
    };
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _login() {
    if (_loginKey.currentState.validate()) {
      _loginKey.currentState.save();
      _loginKey.currentState.validate();
      debugPrint('username=$username');
      debugPrint('password=$password');

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Logining.....'),
      ));

      //执行登录操作
      var parameters = {
        'username': username,
        'password': password,
      };
      try {
        HttpService().getHttpData(Config.LOGIN_URL, parameters: parameters,
            onSuccess: (response) {
          SpHelper.putBool(Config.KEY_IS_LOGIN, true);
          SpHelper.putString(Config.KEY_TOKEN,
              response.headers['set-cookie'][0].split(';')[0]);

          //登录成功跳转到home页并清除loginPage
          Routes.navigateTo(context, '/home', clearStack: true);
        }, onFail: (msg) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('$msg.....'),
          ));
        });
      } catch (e) {
        print(e);
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  String _validateUsername(value) {
    if (value.isEmpty) {
      return 'Username is required.';
    }
    return null;
  }

  String _validatePassword(value) {
    if (value.isEmpty) {
      return 'Password is required.';
    }
    return null;
  }

  File _image;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  //图像avatar
  Widget _buildAvatar() {
    return GestureDetector(
      onTap: _getImage,
      child: CircleAvatar(
        radius: 48.0,
        backgroundColor: Colors.grey[100],
        backgroundImage: _image == null
            ? NetworkImage(
                'http://9.onn9.com/2016/10/85c76e5623b1b443bcdb7afe2a951cd5.jpg')
            : FileImage(_image),
      ),
    );
  }

  Widget _buildUserNameField() {
    return TextFormField(
      maxLines: 1,
      maxLength: 20,
      decoration: InputDecoration(
          labelText: 'Username',
          prefixIcon: Icon(Icons.account_box),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          helperText: '',
          contentPadding: EdgeInsets.all(4.0)),
      onSaved: (value) {
        username = value;
      },
      validator: _validateUsername,
      autovalidate: _autovalidate,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      maxLines: 1,
      maxLength: 8,
      obscureText: true,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(),
          helperText: '',
          contentPadding: EdgeInsets.all(4.0)),
      onSaved: (value) {
        password = value;
      },
      validator: _validatePassword,
      autovalidate: _autovalidate,
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      width: double.infinity,
      height: 48.0,
      child: RaisedButton(
        color: Colors.green,
        child: Text('Login',
            style: TextStyle(color: Colors.white, fontSize: 20.0)),
        elevation: 0.0,
        onPressed: _login,
        shape: StadiumBorder(),
      ),
    );
  }

  Widget _buildRegister() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: '还没账号？',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(42), color: Colors.black)),
          TextSpan(
              recognizer: recognizer,
              text: '快注册一个吧！',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(42), color: Colors.red)),
        ]),
      ),
    );
  }

  Widget _form() {
    return Container(
      margin: EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          _buildAvatar(),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Form(
              key: _loginKey,
              child: Column(
                children: <Widget>[
                  _buildUserNameField(),
                  _buildPasswordField(),
                  SizedBox(height: 16.0),
                  _buildLoginBtn(),
                  SizedBox(height: 16.0),
                  _buildRegister()
                ],
              ),
            ),
          ),
          SizedBox(height: 24.0),
          ThirdLoginWidget(),
        ],
      ),
    );
  }
}
