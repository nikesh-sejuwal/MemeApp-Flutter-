// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:provider/provider.dart';
// import 'package:memeapp/Providers/MemeProvider.dart';

class CaptionEdit extends StatefulWidget {
  final String myCap;
  final int myIndex;
  CaptionEdit({super.key, required this.myCap, required this.myIndex});

  @override
  State<CaptionEdit> createState() => _CaptionEditState();
}

var captionController = TextEditingController();

class _CaptionEditState extends State<CaptionEdit> {
  @override
  void initState() {
    captionController.text = widget.myCap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.amber.shade50,
      title: Text("Edit caption"),
      content: Container(
        // height: 100,
        width: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                  labelText: 'caption',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 2))),
            ),
            SizedBox(height: 5),
            Consumer<MemeProvider>(builder: (context, memeProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close, color: Colors.red, size: 30)),
                  IconButton(
                    onPressed: () {
                      var index = widget.myIndex;
                      if (memeProvider.memes[index].uploadedBy.id ==
                          Provider.of<Authprovider>(listen: false, context)
                              .user!
                              .id) {
                        memeProvider.updateCaption(memeProvider.memes[index].id,
                            captionController.text);
                        // print("HELLOO");
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Unauthorized meme's caption cannot be edited"),
                            backgroundColor: Colors.red));
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(Icons.check, color: Colors.green, size: 30),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
