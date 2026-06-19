import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loikmon/i18n/strings.g.dart';
import 'package:loikmon/models/Userdata.dart';
import 'package:loikmon/providers/AppStateManager.dart';
import 'package:loikmon/utils/Alerts.dart';
import 'package:loikmon/utils/ApiUrl.dart';
import 'package:loikmon/utils/TextStyles.dart';
import 'package:loikmon/utils/Utility.dart';
import 'package:loikmon/utils/img.dart';
import 'package:loikmon/utils/my_colors.dart';
import 'package:http/http.dart' as http;
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  AuthPage(this.showExitIcon, {Key? key}) : super(key: key);
  static const routeName = "/AuthPage";
  final bool showExitIcon;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

class _AuthPageState extends State<AuthPage> {
  late AppStateManager appManager;
  Userdata? userdata;
  int isadminuser = 5;
  String email = "";
  GoogleSignInAccount? _currentUser;

  final inputBorder = BorderRadius.vertical(
    bottom: Radius.circular(0.0),
    top: Radius.circular(0.0),
  );

  _socialauthUser(String email, String name, String type, String username,
      String phone) async {
    Alerts.showProgressDialog(context, t.processing_please_wait);
    try {
      var data = {
        "email": email,
        "name": name,
        "type": type,
        "username": username,
        "phone": phone,
      };
      final response = await http.post(Uri.parse(ApiUrl.LOGIN_APP),
          body: jsonEncode({"data": data}));
      print(response);
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          Alerts.showToast(context, res["message"]);
        } else {
          if (res["user"]["username"].toString() != "") {
            userdata = Userdata.fromJson(res["user"]);
            isadminuser = int.parse(res["isadminuser"].toString());
            await appManager.setUserData(
                userdata!, int.parse(res["isadminuser"].toString()));
            Navigator.of(context).pop();
          } else {
            addmoreinfo(email, name, "Google");
          }
        }
      } else {
        Alerts.showToast(context, "A network error occured.");
      }
    } catch (exception) {
      Navigator.of(context).pop();

      Alerts.showToast(context, exception.toString());
    }
  }

  Future<void> resendVerificationLink() async {
    Alerts.showProgressDialog(context, t.processingpleasewait);
    try {
      var data = {
        "email": email,
      };
      final response = await http.post(Uri.parse(ApiUrl.RESEND_VERIFY_LINK),
          body: jsonEncode({"data": data}));
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Alerts.show(context, "", t.successresendverifymessage);
      } else {
        Alerts.show(context, "", t.cannotprocess);
      }
    } catch (exception) {
      Navigator.of(context).pop();
      Alerts.show(context, "", exception.toString());
    }
  }

  Future<void> registerSuccessMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext _context) {
        return AlertDialog(
          title: Text(""),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(t.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                t.resendverifycode,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                resendVerificationLink();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> _authUser(LoginData _data) async {
    email = _data.name;
    try {
      var data = {
        "email": _data.name,
        "password": _data.password,
      };
      final response = await http.post(Uri.parse(ApiUrl.LOGIN_APP),
          body: jsonEncode({"data": data}));
      print(response);
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          return res["message"];
        } else {
          print(res["user"]);
          //Alerts.show(context, Strings.success, res["message"]);
          userdata = Userdata.fromJson(res["user"]);
          isadminuser = int.parse(res["isadminuser"].toString());
          return null;
        }
      } else {
        return "A network error occured.";
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<String?> _signupUser(SignupData _data) async {
    email = _data.name!;
    try {
      var data = {
        "email": _data.name,
        "password": _data.password,
        "username": _data.additionalSignupData!['username'],
        "phone": _data.additionalSignupData!['phone'],
      };
      final response = await http.post(Uri.parse(ApiUrl.CREATE_ACCOUNT),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          return res["message"];
        } else {
          /*print(res["user"]);
            //Alerts.show(context, Strings.success, res["message"]);
            Provider.of<AppStateManager>(context, listen: false)
                .setUserData(Userdata.fromJson(res["user"]));
            return null;*/
          //registerSuccessMessage(t.successregistermessage);
          return null;
        }
      } else {
        return t.cannotprocess;
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  Future<String?> _recoverPassword(String name) async {
    try {
      var data = {
        "email": name,
      };
      final response = await http.post(Uri.parse(ApiUrl.RESET_PASSWORD),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        Map<String, dynamic> res = json.decode(response.body);
        if (res["status"] == "error") {
          return res["message"];
        } else {
          return null;
        }
      } else {
        return t.cannotprocess;
      }
    } catch (exception) {
      return exception.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      print("current user seen");
      if (!mounted) return;
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        // _handleGetContact();
        print(_currentUser!.email);
        //addmoreinfo(_currentUser!.email, _currentUser!.displayName!, "Google");
        await _socialauthUser(
            _currentUser!.email, _currentUser!.displayName!, "Google", "", "");
      }
    });
    //googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    appManager = Provider.of<AppStateManager>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: MyColors.mainC0lor,
            height: double.infinity,
            child: FlutterLogin(
              title: t.appname,
              logo: AssetImage(Img.get("icon.png")),
              onLogin: _authUser,
              onSignup: _signupUser,
              additionalSignupFields: [
                UserFormField(
                  keyName: "username",
                  displayName: "Username",
                  userType: LoginUserType.text,
                  icon: Icon(LineAwesomeIcons.user),
                  fieldValidator: (value) {
                    if (value == "") {
                      return "Please add a username";
                    }
                    return null;
                  },
                ),
                UserFormField(
                  keyName: "phone",
                  displayName: "Phone Number",
                  userType: LoginUserType.phone,
                  icon: Icon(LineAwesomeIcons.phone_alt_solid),
                  fieldValidator: (value) {
                    if (value == "") {
                      return "Please add a valid phone number";
                    }
                    return null;
                  },
                ),
              ],
              loginAfterSignUp: false,
              disableCustomPageTransformer: true,
              onSubmitAnimationCompleted: () async {
                print("set user data");
                await appManager.setUserData(userdata!, isadminuser);
                Navigator.of(context).pop();
              },
              children: [
                Container(
                  height: 45,
                  margin: EdgeInsets.only(top: 500),
                  child: ElevatedButton.icon(
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 242, 240, 240)),
                      onPressed: () async {
                        await googleSignIn.signOut();
                        try {
                          await googleSignIn.signIn();
                        } catch (error) {
                          Alerts.showToast(
                              context, "Google error: " + error.toString());

                          print(error);
                        }
                        //addmoreinfo("email", "name", "type");
                      },
                      label: Text(
                        "Login with Google",
                        style: TextStyles.display1(context)
                            .copyWith(color: Colors.blue, fontSize: 16),
                      ),
                      icon: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.blue,
                      )),
                )
              ],
              onRecoverPassword: _recoverPassword,
              /* additionalSignupFields: [
                UserFormField(
                  keyName: "firstname",
                  displayName: "FirstName",
                  icon: Icon(Icons.person),
                ),
                UserFormField(
                  keyName: "lastname",
                  displayName: "LastName",
                  icon: Icon(Icons.person),
                )
              ],*/
              messages: LoginMessages(
                userHint: t.emailaddress,
                recoveryCodeValidationError: "",
                passwordHint: t.password,
                confirmPasswordHint: t.confirmpassword,
                loginButton: t.login,
                signupButton: t.createaccount,
                forgotPasswordButton: t.forgotpassword,
                recoverPasswordButton: t.resetpassword,
                goBackButton: t.goback,
                confirmPasswordError: t.passwordsdontmatch,
                recoverPasswordDescription: t.resetpasswordhint,
                recoverPasswordSuccess: t.resetpasswordsuccess,
                signUpSuccess: t.accountsuccess,
              ),
              theme: LoginTheme(
                logoWidth: 50,

                //cardInitialHeight: 600,
                //pageColorLight: const Color.fromARGB(255, 222, 75, 230),

                primaryColor: const Color.fromARGB(255, 174, 14, 202),
                accentColor: appManager.isDarkModeOn
                    ? MyColors.white
                    : const Color.fromARGB(255, 0, 0, 0),
                errorColor: Colors.deepOrange,
                titleStyle: TextStyles.display1(context).copyWith(
                  color: MyColors.white,
                  fontSize: 25,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
                footerTextStyle: TextStyles.display1(context).copyWith(
                  color: appManager.isDarkModeOn
                      ? MyColors.white
                      : const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 25,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                  //fontFamily: 'style1',
                ),
                bodyStyle: TextStyles.display1(context).copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: appManager.isDarkModeOn
                      ? const Color.fromARGB(255, 240, 233, 233)
                      : Colors.black,
                ),
                textFieldStyle: TextStyles.display1(context).copyWith(
                    fontSize: 16,
                    color: appManager.isDarkModeOn
                        ? const Color.fromARGB(255, 26, 25, 25)
                        : Colors.black),
                switchAuthTextColor: appManager.isDarkModeOn
                    ? MyColors.white
                    : const Color.fromARGB(255, 10, 10, 17),
                buttonStyle: TextStyles.display1(context).copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                ),
                cardTheme: CardTheme(
                  color: appManager.isDarkModeOn
                      ? MyColors.primary
                      : MyColors.primary,
                  elevation: 0,
                  margin: EdgeInsets.only(top: 20),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                inputTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: appManager.isDarkModeOn
                      ? const Color.fromARGB(255, 212, 215, 220)
                      : const Color.fromARGB(255, 212, 215, 220),
                  focusColor: MyColors.mainC0lor,
                  contentPadding: EdgeInsets.zero,
                  errorStyle: TextStyles.display1(context).copyWith(
                    backgroundColor: appManager.isDarkModeOn
                        ? MyColors.headerdark
                        : Colors.white,
                    color: Colors.red,
                  ),
                  labelStyle: TextStyle(
                      fontSize: 14,
                      color: appManager.isDarkModeOn
                          ? MyColors.headerdark
                          : Colors.black),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.darkerText, width: 1),
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(7.0),
                          top: Radius.circular(7.0))),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.mainC0lor, width: 2),
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(7.0),
                        top: Radius.circular(7.0)),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red.shade700, width: 2),
                    borderRadius: inputBorder,
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red.shade400, width: 2),
                    borderRadius: inputBorder,
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: inputBorder,
                  ),
                  //prefixStyle: TextStyle(color: Colors.white),

                  suffixIconColor:
                      appManager.isDarkModeOn ? MyColors.white : Colors.black,
                  prefixIconColor:
                      appManager.isDarkModeOn ? MyColors.white : Colors.black,
                ),
                buttonTheme: LoginButtonTheme(
                  splashColor: MyColors.mainC0lor,
                  // backgroundColor: MyColors.white,
                  highlightColor: MyColors.mainC0lor,
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  // shape: CircleBorder(side: BorderSide(color: Colors.green)),
                  // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.showExitIcon,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 20, bottom: 20),
                child: Icon(
                  Icons.cancel,
                  //color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addmoreinfo(String email, String name, String type) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    showModalBottomSheet(
      //useSafeArea: true,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setstate) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: double.infinity,
              //height: 600,
              margin: MediaQuery.of(context).size.width > 1200
                  ? EdgeInsets.only(left: 450, right: 450)
                  : MediaQuery.of(context).size.width > 800
                      ? EdgeInsets.only(left: 300, right: 300)
                      : MediaQuery.of(context).size.width > 500
                          ? EdgeInsets.only(left: 100, right: 100)
                          : EdgeInsets.only(left: 50, right: 50),
              color: appManager.isDarkModeOn ? Colors.grey[900] : Colors.white,
              padding:
                  EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                        child: Row(
                          children: [
                            Text(
                              "Complete Registration",
                              textAlign: TextAlign.center,
                              style: TextStyles.display1(context).copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                //color: Color(0xFF4B4B4B),
                              ),
                            ),
                            Spacer(),
                          ],
                        )),
                    Divider(
                      color: Colors.grey[300],
                    ),
                    Container(
                      height: 50,
                      child: TextFormField(
                        controller: usernameController,
                        //readOnly: true,
                        keyboardType: TextInputType.text,
                        //minLines: 4,
                        //maxLines: 10,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(LineAwesomeIcons.user)), //
                          contentPadding: EdgeInsets.only(left: 15, top: 35),
                          //labelText: StringsUtils.email,
                          hintText: "Username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 12,
                    ),
                    Container(
                      height: 50,
                      child: TextFormField(
                        controller: phoneController,
                        //readOnly: true,
                        keyboardType: TextInputType.phone,
                        //minLines: 4,
                        //maxLines: 10,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(LineAwesomeIcons.phone_alt_solid)), //
                          contentPadding: EdgeInsets.only(left: 15, top: 35),
                          //labelText: StringsUtils.email,
                          hintText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          String _username = usernameController.text.trim();
                          String _phone = phoneController.text.trim();
                          if (_username == "" || _phone == "") {
                            Alerts.showToast(context,
                                "You need to complete all fields to continue");
                          } else {
                            Navigator.of(context).pop();
                            await _socialauthUser(
                                email, name, "Google", _username, _phone);
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyles.display1(context).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.mainC0lor,
                            //minimumSize:  Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6))),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
