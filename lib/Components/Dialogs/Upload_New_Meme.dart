import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:memeapp/Resources/Resources.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memeapp/Pages/User_Profile.dart';
// import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:http/http.dart' as http;
import 'package:memeapp/Resources/Resources.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

// import '../../Pages/Profile_Page.dart';

class Upload_New_Meme extends StatefulWidget {
  final String imageURL;
  Upload_New_Meme({super.key, required this.imageURL});

  @override
  State<Upload_New_Meme> createState() => _Upload_New_MemeState();
}

class _Upload_New_MemeState extends State<Upload_New_Meme> {
  final ImagePicker picker = ImagePicker();

  XFile? pickedimage;

  TextEditingController captionController = TextEditingController();

  bool isSendingRequest = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade700,
        leadingWidth: 50,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined, size: 30)),
        title: Text(
          'Post',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => UserProfile()));
            },
            child: Container(
                margin: EdgeInsets.only(right: 20),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.imageURL,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromARGB(255, 255, 254, 243),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post a new meme',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text('Caption the Meme'),
                SizedBox(height: 10),
                TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(10)),

                      // hintText: "Helloo ji",
                      label:
                          Text('description', style: TextStyle(fontSize: 16))),
                ),
                SizedBox(height: 20),
                Text('Upload meme: '),
                SizedBox(height: 10),
                Center(
                  child: InkWell(
                      onTap: () async {
                        pickedimage =
                            await picker.pickImage(source: ImageSource.gallery);

                        setState(() {});
                      },
                      child: pickedimage == null
                          ? Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                  border: Border.all(style: BorderStyle.solid)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save_as,
                                        size: 40, color: Colors.blue)
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.file(
                                    File(pickedimage!.path),
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.close, color: Colors.red),
                                        SizedBox(width: 20),
                                        Text('Choose Another')
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: pickedimage == null ? Colors.grey : Colors.black,
            child: TextButton(
              onPressed: pickedimage == null
                  ? null
                  : () async {
                      try {
                        setState(() {
                          isSendingRequest = true;
                        });
                        String enteredCaption = captionController.text;
                        var headers = {
                          'Authorization': 'Bearer ${MemeProvider.header}'
                        };
                        var request = http.MultipartRequest(
                            "POST", Uri.parse('$myIP/memes'));
                        request.headers.addAll(headers);
                        request.fields.addAll({'caption': enteredCaption});
                        request.files.add(await http.MultipartFile.fromPath(
                            "image", pickedimage!.path,
                            contentType: MediaType.parse(
                              lookupMimeType(pickedimage!.path)!,
                            )));
                        var res = await request.send();
                        final resBody = await res.stream.bytesToString();
                        print(resBody);
                        if (res.statusCode == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Successfully added meme"),
                              backgroundColor: Colors.green));
                          Navigator.of(context).pop();
                          Provider.of<MemeProvider>(context, listen: false)
                              .getMemes();
                        } else {
                          throw Exception(resBody);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      } finally {
                        setState(() {
                          isSendingRequest = false;
                        });
                      }
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'POST THIS MEME',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  if (isSendingRequest)
                    CupertinoActivityIndicator(color: Colors.white)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
