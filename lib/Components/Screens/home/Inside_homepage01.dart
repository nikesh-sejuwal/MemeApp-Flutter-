import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memeapp/Providers/MemeProvider.dart';
import 'package:memeapp/modalclass/meme_model.dart';
import 'package:provider/provider.dart';

import '../../../Pages/Profile_Page.dart';
import '../../../Providers/AuthProvider.dart';
import '../../../Resources/Resources.dart';
import '../../Dialogs/caption_Edit_box.dart';

class InsideHomepage01 extends StatefulWidget {
  final Meme meme;
  final index;

  const InsideHomepage01({super.key, required this.index, required this.meme});

  @override
  State<InsideHomepage01> createState() => _InsideHomepage01State();
}

class _InsideHomepage01State extends State<InsideHomepage01> {
  @override
  Widget build(BuildContext context) {
    var meme = widget.meme;
    return Consumer<MemeProvider>(builder: (context, memeProvider, child) {
      String? memeUploader = meme.uploadedBy.imageURL;
      var cap = meme.caption ?? "";

      return ListTile(
        contentPadding: EdgeInsets.only(left: 5),
        leading: InkWell(
          onTap: () {},
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: memeUploader ?? personImg,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (c) => Profile_Page(myUser: meme.uploadedBy)));
          },
          child: Text(
            meme.uploadedBy.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: Text(
          DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY).format(
            widget.meme.createdAt,
          ),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.amber.shade50,
          onSelected: (String result) {
            switch (result) {
              case 'Delete':
                if (meme.uploadedBy.id ==
                    Provider.of<Authprovider>(context, listen: false)
                        .user!
                        .id) {
                  memeProvider.deleteMeme(meme.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                          "Post deleted successfully.",
                        ),
                        backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Unauthorized post cannot be deleted!!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                break;
              case 'Favorite':
                print("CLICKED TO FAVOURITE");
                break;
              case 'Edit':
                showDialog(
                    context: context,
                    builder: (c) => CaptionEdit(
                          myCap: cap,
                          myIndex: widget.index,
                        ));

                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Favorite',
              child: ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorite'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Edit',
              child: ListTile(
                leading: Icon(Icons.edit_document),
                title: Text('Edit caption'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
