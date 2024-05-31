import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:memeapp/Components/Dialogs/caption_Edit_box.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage01.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage02.dart';
import 'package:memeapp/Components/Screens/home/Inside_homepage03.dart';
// import 'package:memeapp/Pages/Profile_Page.dart';
import 'package:memeapp/Pages/User_Profile.dart';
import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:memeapp/Resources/Resources.dart';
import 'package:provider/provider.dart';
import '../Components/Dialogs/Upload_New_Meme.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  void initState() {
    Provider.of<Authprovider>(listen: false, context).getUserFromSavedToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String? imageURL =
        Provider.of<Authprovider>(context, listen: false).user!.imageURL;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade700,
        leadingWidth: 40,
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('No content to show')));
          },
          icon: Icon(Icons.menu, size: 30),
        ),
        title: TextButton(
          onPressed: () {
            Provider.of<MemeProvider>(listen: false, context).getMemes();
          },
          child: Text("Memantic",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
        ),
        actions: [
          Consumer<Authprovider>(builder: (context, aprov, child) {
            // var imageURL = aprov.user.imageURL;
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (c) => UserProfile()));
              },
              child: Container(
                // alignment: Alignment.center,
                margin: EdgeInsets.only(right: 20),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  // color: Colors.black,
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipOval(
                    child: CachedNetworkImage(
                  imageUrl: aprov.user!.imageURL ?? personImg,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )),
              ),
            );
          })
        ],
      ),
      body: Consumer<MemeProvider>(
        builder: (context, memeProvider, child) {
          if (memeProvider.memes.isEmpty)
            return Center(child: CircularProgressIndicator(strokeWidth: 5));
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 255, 254, 243),
            child: ListView.builder(
              itemCount: memeProvider.memes.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InsideHomepage01(
                        index: index, meme: memeProvider.memes[index]),
                    InsideHomepage02(
                        index: index, meme: memeProvider.memes[index]),
                    InsideHomepage03(
                        index: index, meme: memeProvider.memes[index]),
                    Divider(color: Colors.black),
                  ],
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => Upload_New_Meme(
                    imageURL: imageURL != null ? imageURL : personImg,
                  )));
        },
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
