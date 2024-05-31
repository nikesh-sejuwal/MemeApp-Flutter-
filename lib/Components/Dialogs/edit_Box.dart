import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:memeapp/Resources/Resources.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class EditBox extends StatefulWidget {
  final String name;
  final String phone;
  const EditBox({super.key, required this.name, required this.phone});

  @override
  State<EditBox> createState() => _EditBoxState();
}

var nameController = TextEditingController();
var phoneController = TextEditingController();
final ImagePicker picker = ImagePicker();
XFile? pickedimage;

class _EditBoxState extends State<EditBox> {
  @override
  void initState() {
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    super.initState();
  }

  bool isSendingRequest = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Edit your profile",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Name *',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Phone no. *',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                          hintText: 'Enter your number',
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black),
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Profile picture *',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        pickedimage =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {});
                      },
                      child: Center(
                        child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1)),
                            child: pickedimage == null
                                ? Icon(Icons.edit_document,
                                    size: 45, color: Colors.blue)
                                : Image.file(File(pickedimage!.path))),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: pickedimage == null
                          ? null
                          : () async {
                              try {
                                setState(() {
                                  isSendingRequest = true;
                                });
                                var headers = {
                                  "Authorization":
                                      "Bearer ${MemeProvider.header}"
                                };
                                var request = await http.MultipartRequest(
                                    "PUT", Uri.parse('$myIP/users/me'));
                                request.headers.addAll(headers);
                                request.fields.addAll({
                                  'name': nameController.text,
                                  'phone': phoneController.text
                                });
                                request.files.add(
                                    await http.MultipartFile.fromPath(
                                        'image', pickedimage!.path,
                                        contentType: MediaType.parse(
                                          lookupMimeType(pickedimage!.path)!,
                                        )));
                                var response = await request.send();
                                final responseBody =
                                    await response.stream.bytesToString();
                                if (response.statusCode == 201) {
                                  await Provider.of<Authprovider>(context,
                                          listen: false)
                                      .getUserFromSavedToken();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Successfully changed profile details"),
                                          backgroundColor: Colors.green));
                                  Navigator.of(context).pop();
                                } else {
                                  throw Exception(responseBody);
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red));
                              } finally {
                                isSendingRequest = false;
                              }
                            },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: pickedimage == null
                                ? Colors.grey
                                : Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                              if (isSendingRequest)
                                CupertinoActivityIndicator(color: Colors.white)
                            ],
                          ),
                        )),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
