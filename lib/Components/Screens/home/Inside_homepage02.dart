import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:memeapp/Providers/AuthProvider.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:memeapp/modalclass/meme_model.dart';
import 'package:provider/provider.dart';

class InsideHomepage02 extends StatefulWidget {
  final int index;
  final Meme meme;
  const InsideHomepage02({super.key, required this.index, required this.meme});

  @override
  State<InsideHomepage02> createState() => _InsideHomepage02State();
}

class _InsideHomepage02State extends State<InsideHomepage02> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MemeProvider>(builder: (context, memeProvider, child) {
      var meme = widget.meme.filePath;
      var cap = widget.meme.caption ?? "";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              cap,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  color: Colors.grey,
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: meme,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ],
      );
    });
  }
}
