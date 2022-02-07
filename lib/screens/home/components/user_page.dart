import 'package:flutter/material.dart';
import 'package:jobheeseller/constants.dart';
import 'package:jobheeseller/utils/image_assets.dart';

class UserPage extends StatelessWidget {
  final String name;

  final String urlImage;

  const UserPage({this.name, this.urlImage, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: name != null ? Text(name) : Text('No data'),
      ),
      body: urlImage != null
          ? Image.network(
              urlImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          : Center(child: Text('No Image'),),
    );
  }
}
