import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memeapp/Components/Screens/Log%20in/SignIn_Page.dart';
import 'package:http/http.dart' as http;
import 'package:memeapp/Resources/Resources.dart';

class SignUp_Page extends StatefulWidget {
  SignUp_Page({super.key});

  @override
  State<SignUp_Page> createState() => _SignUp_PageState();
}

class _SignUp_PageState extends State<SignUp_Page> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();
  bool isSendingRequest = false;

  void submitForm() async {
    if (formkey.currentState!.validate()) {
      try {
        setState(() {
          isSendingRequest = true;
        });
        var response = await http.post(Uri.parse('${myIP}/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': emailController.text,
              'password': passwordController.text,
              'name': nameController.text,
              'phone': phoneController.text,
            }));
        print('Status code is ${response.statusCode}');
        if (response.statusCode == 201) {
          print(
              '${emailController.text} is email ${passwordController.text} is password');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (c) => SignIn_Page()));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('SignUp Successfully!'),
              backgroundColor: Colors.green));
        } else if (response.statusCode == 400) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Email already taken')));
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
              Text('Welcome',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
              Text('Sign up to continue',
                  style: TextStyle(
                      fontSize: 22,
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
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person,
                                  size: 25, color: Colors.black),
                              hintText: 'Name',
                              hintStyle: TextStyle(fontSize: 16),
                            )),
                        SizedBox(height: 20),
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
                            controller: phoneController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter phone number';
                              }

                              RegExp phoneRegExp = RegExp(
                                  r'^\+?(\d{1,3})?[-.\s]?\(?(\d{3})\)?[-.\s]?(\d{3})[-.\s]?(\d{4})$');
                              if (!phoneRegExp.hasMatch(value)) {
                                return 'enter 10-digit phone number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_android,
                                  size: 25, color: Colors.black),
                              hintText: 'Phone',
                              hintStyle: TextStyle(fontSize: 16),
                            )),
                        SizedBox(height: 20),
                        TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter a password';
                              }
                              RegExp passExp = RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
                              if (!passExp.hasMatch(value)) {
                                return 'must contains at least 8 chars 1 digit 1 letter';
                              }
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
                                          : Text('Sign Up',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ))),
                                ),
                                SizedBox(height: 10),
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
                    'Already have an account?',
                    style:
                        TextStyle(color: const Color.fromARGB(255, 82, 81, 81)),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (c) => SignIn_Page()));
                      },
                      child: Text('Sign in'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
