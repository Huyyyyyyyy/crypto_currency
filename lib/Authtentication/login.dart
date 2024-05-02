import 'package:flutter/material.dart';
import 'package:login_crud_api/Authtentication/signup.dart';
import 'package:login_crud_api/JsonModels/users.dart';
import 'package:login_crud_api/SQLite/sqlite.dart';
import 'package:login_crud_api/Views/notes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //We need two text editing controller

  //TextEditing controller to control the text when we enter into it
  final username = TextEditingController();
  final password = TextEditingController();

  //A bool variable for show and hide password
  bool isVisible = false;

  //Here is our bool variable
  bool isLoginTrue = false;

  final db = DatabaseHelper();

  //Now we should call this function in login button
  login() async {
    var response = await db
        .login(Users(usrName: username.text, usrPassword: password.text));
    if (response == true) {
      //If login is correct, then goto notes
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Notes()));
    } else {
      //If not, true the bool value to show error message
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  //We have to create global key for our form
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2329),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            //We put all our textfield to a form to be controlled and not allow as empty
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  //Username field

                  //Before we show the image, after we copied the image we need to define the location in pubspec.yaml
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Đăng Nhập",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF39414A)),
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "tên người dùng là bắt buộc";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person, color: Colors.yellow),
                        border: InputBorder.none,
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  //Password field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF39414A)),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "mật khẩu là bắt buộc";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.lock, color: Colors.yellow),
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                              onPressed: () {
                                //In here we will create a click to show and hide the password a toggle button
                                setState(() {
                                  //toggle button
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off, color: Colors.white))),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 10),
                  //Login button
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.yellow,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          //Login method will be here
                          login();

                          //Now we have a response from our sqlite method
                          //We are going to create a user
                        }
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),

                      ),
                    ),
                  ),

                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Bạn chưa có tài khoản?", style: TextStyle(color: Colors.white)),
                      TextButton(
                        onPressed: () {
                          //Navigate to sign up
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUp()),
                          );
                        },
                        child: const Text("Đăng ký", style: TextStyle(color: Colors.yellow)),
                      ),
                    ],
                  ),

                  // We will disable this message in default, when user and pass is incorrect we will trigger this message to user
                  if (isLoginTrue)
                    Text(
                      "Tên người dùng hoặc mật khẩu không chính xác",
                      style: TextStyle(color: Colors.red),
                    )
                  else
                    SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
