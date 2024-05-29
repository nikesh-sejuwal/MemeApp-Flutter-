import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/AuthProvider.dart';
import '../../Providers/MemeProvider.dart';

class InsideHomepage03 extends StatefulWidget {
  final Map<String, dynamic> meme;
  final int index;
  const InsideHomepage03({super.key, required this.meme, required this.index});

  @override
  State<InsideHomepage03> createState() => _InsideHomepage03State();
}

class _InsideHomepage03State extends State<InsideHomepage03> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Consumer2<MemeProvider, Authprovider>(
        builder: (context, memeProvider, aProv, child) {
          return Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      memeProvider.toggleFunction(widget.meme['_id']);
                    },
                    icon: widget.meme['likes'].contains(aProv.user['id'])
                        ? Icon(
                            Icons.favorite,
                            size: 30,
                            color: Colors.pink,
                          )
                        : Icon(Icons.favorite_border, size: 30),
                  ),
                  Text(
                    '${widget.meme['likes'].length} likes',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
