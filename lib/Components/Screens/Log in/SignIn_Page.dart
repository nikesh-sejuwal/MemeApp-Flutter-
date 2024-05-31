import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memeapp/Pages/Home_Page.dart';
import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';

import '../../../Resources/Resources.dart';
import 'SignUp_Page.dart';

class SignIn_Page extends StatefulWidget {
  SignIn_Page({super.key});

  @override
  State<SignIn_Page> createState() => _SignIn_PageState();
}

class _SignIn_PageState extends State<SignIn_Page> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool isSendingRequest = false;

  void submitForm() async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          isSendingRequest = true;
        });
        var response = await http.post(Uri.parse('${myIP}/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': emailController.text,
              'password': passwordController.text,
            }));
        // print('Status code is ${response.statusCode}');
        // print('Body is ${response.body}');
        if (response.statusCode == 200) {
          var decodedInfo =
              jsonDecode(response.body)['tokens']['access']['token'];

          Authprovider aprov =
              Provider.of<Authprovider>(listen: false, context);
          aprov.setHeader(decodedInfo);
          aprov.saveToken();

          // print("the token is $decodedInfo");

          // print(
          //     '${emailController.text} is email ${passwordController.text} is password');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (c) => Home_Page()));
        } else if (response.statusCode == 401) {
          var decoded = jsonDecode(response.body)['message'];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(decoded),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        isSendingRequest = false;
      }
    }
  }

  String? validEmail(value) {
    if (value!.isEmpty) {
      return 'please enter email';
    }
    RegExp emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.yellow.shade600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome Back',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
              Text('Sign in to continue',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 32, 31, 31),
                      fontWeight: FontWeight.w200)),
              SizedBox(height: 20),
              Form(
                  key: formkey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: emailController,
                            validator: validEmail,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email,
                                  size: 25, color: Colors.black),
                              hintText: 'Email',
                              hintStyle: TextStyle(fontSize: 16),
                            )),
                        SizedBox(height: 20),
                        TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,
                                  size: 25, color: Colors.black),
                              hintText: 'Password',
                              hintStyle: TextStyle(fontSize: 16),
                            )),
                        SizedBox(height: 30),
                        GestureDetector(
                            onTap: submitForm,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: isSendingRequest
                                          ? CircularProgressIndicator(
                                              color: Colors.yellow)
                                          : Text('Sign In',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ))),
                                ),
                                SizedBox(height: 10),
                                // if (isSendingRequest)
                                //   CircularProgressIndicator()
                              ],
                            ))
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style:
                        TextStyle(color: const Color.fromARGB(255, 82, 81, 81)),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (c) => SignUp_Page()));
                      },
                      child: Text('Sign up'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
