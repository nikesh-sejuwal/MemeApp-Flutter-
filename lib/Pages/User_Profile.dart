import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memeapp/Components/Dialogs/Dialog_Box.dart';
import 'package:memeapp/Components/Dialogs/posts.dart';
import 'package:memeapp/Components/Dialogs/likes.dart';
import 'package:memeapp/Components/Dialogs/edit_Box.dart';
import 'package:memeapp/Providers/AuthProvider.dart';

import 'package:provider/provider.dart';

import '../Resources/Resources.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final textStyle =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
  late String id;
  late String name;
  late String email;
  late String phone;
  late String? imageURL;

  @override
  void initState() {
    Provider.of<Authprovider>(context, listen: false).getUserFromSavedToken();
    var aProv = Provider.of<Authprovider>(context, listen: false);
    name = aProv.user!.name;
    email = aProv.user!.email;
    phone = aProv.user!.phone;
    id = aProv.user!.id;
    imageURL = aProv.user!.imageURL;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leadingWidth: 50,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_outlined, size: 30)),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        actions: [
          InkWell(
            onTap: () async {
              showDialog(context: context, builder: (context) => Dialog_Box());
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.logout_rounded, color: Colors.white),
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Color.fromARGB(255, 255, 254, 243),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Consumer<Authprovider>(builder: (context, aProv, child) {
                  return Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(1, 1),
                                blurRadius: 5,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (c) =>
                                          EditBox(name: name, phone: phone)));
                                },
                                icon: Icon(Icons.edit_square,
                                    color: Colors.deepPurple)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(width: 2, color: Colors.red),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          aProv.user!.imageURL ?? personImg,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          aProv.user!.name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.mail)),
                                          ),
                                          Expanded(
                                            child: Text(
                                              aProv.user!.email,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.phone_android)),
                                          Expanded(
                                            child: Text(
                                              aProv.user!.phone,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      TabBar(
                        labelColor: Colors.red,
                        indicatorColor: Colors.red,
                        tabs: [
                          Tab(icon: Icon(Icons.post_add), text: 'Posts'),
                          Tab(icon: Icon(Icons.thumb_up), text: 'Likes'),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 2, color: Colors.amber)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: TabBarView(
                            children: [
                              Posts(
                                name: name,
                                id: this.id,
                              ),
                              Likes(name: name, id: this.id)
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
