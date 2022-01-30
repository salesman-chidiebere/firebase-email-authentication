import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp().then(
     (value) => print("Firebase Initialization Complete")
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String msg = "";
  bool signUp = true;
  String btnText = "SignUp";


  void _register() async {
    final User fireUser = (
      await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim())
          .catchError((errMsg){
          print(errMsg);
          setState(() {
            msg = errMsg.toString();
          });
        })
    ).user;
    if (fireUser != null){
      setState(() {
        msg = "User Account (${emailController.text}) "
            "\n Created Successfully";
      });
    }else{
      setState(() {
        msg = "Failed to Create User Account \n (${emailController.text})";
      });
    }
  }

  void _login() async {
    final User user = (
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).catchError((errMsg){
        print(errMsg);
        setState(() {
          msg = errMsg.toString();
        });
      })
    ).user;
    if (user != null){
      setState(() {
        msg = "User Login Successful!!!";
      });
    }else{
      setState(() {
        msg = "User Login failed!!!)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          btnText = "SignUp";
                          signUp = true;
                          msg = "";
                        });
                      },
                      child: Text("SignUp",
                      style: TextStyle(color: Colors.grey, fontSize: 25),),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          btnText = "Login";
                          signUp = false;
                          msg = "";
                        });
                      },
                      child: Text("Login",
                        style: TextStyle(color: Colors.grey, fontSize: 25),),
                    )
                  ],
                ),
                SizedBox(height: 100,),
                emailTextfield(),
                SizedBox(height: 30,),
                passwordTextfield(),
                SizedBox(height: 30,),
                signInSignUp(),
                SizedBox(height: 50,),
                Text(msg),

              ],
            ),
        ),
      ),
    );
  }

  Widget emailTextfield() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      decoration: kBoxDecor,
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (String value){
          if (value.isEmpty){
            return 'Please enter your email';
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z").hasMatch(value)){
            return 'Please enter a valid Email';
          }
          return null;
        },
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'OpenSans'
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(
            Icons.email,
            color:Colors.red,
          ),
          hintText: 'Enter your Email',
        ),
      ),
    );
  }

  Widget passwordTextfield() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      decoration: kBoxDecor,
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        validator: (String value){
          if (value.isEmpty){
            return 'Please enter your password';
          }
          return null;
        },
        style: TextStyle(
            color: Colors.red,
            fontFamily: 'OpenSans'
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
          prefixIcon: Icon(
            Icons.lock,
            color:Colors.red,
          ),
          hintText: 'Enter your Password',
        ),
      ),
    );
  }

  Widget signInSignUp(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.red,
      ),
      onPressed: () => (signUp)
          ? _register()
          : _login(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(btnText, style: TextStyle(fontSize: 24),),
      ),
    );
  }

  final kBoxDecor = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      )
    ]
  );

}
