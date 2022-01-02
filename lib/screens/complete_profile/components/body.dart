import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobheeseller/constants.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //GlobalKey<_BodyState> _globalKey = GlobalKey();

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  String firstName;
  String number;
  String description;
  ImagePicker image = ImagePicker();
  File file;
  String url = "";
  bool visible = true;
  TextEditingController _addressEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img.path);
    });
  }

  saveUser() async {
    var imageFile =
        await FirebaseStorage.instance.ref().child("path").child("/.jpg");
    UploadTask task = imageFile.putFile(file);
    //TaskSnapshot snapshot = await task;
    //for downloading
    // url = await snapshot.ref.getDownloadURL();
    // await FirebaseFirestore.instance
    //     .collection("images")
    //     .doc()
    //     .set({"imageUrl": url});
    // print(url);
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        barrierColor: kPrimaryColor,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    color: Colors.white,
                    child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/Profile Image.png"),
                                    radius: 80,
                                    foregroundImage: file == null
                                        ? AssetImage("")
                                        : FileImage(File(file.path)),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 120.0, right: 120.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                          ]),
                        )),
                  ),
                  Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                  top: 25.0,
                                  bottom: 20),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Personal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      maxLength: 15,
                                      enabled: !_status,
                                      autofocus: !_status,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          border: OutlineInputBorder(),
                                          labelText: 'Name'),
                                      validator: (String value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        firstName = value;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      maxLength: 15,
                                      enabled: !_status,
                                      autofocus: !_status,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone),
                                          border: OutlineInputBorder(),
                                          labelText: 'Number'),
                                      validator: (String value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        number = value;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      maxLength: 30,
                                      enabled: !_status,
                                      autofocus: !_status,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.description),
                                          border: OutlineInputBorder(),
                                          labelText: 'Description'),
                                      validator: (String value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        description = value;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      onTap: () {
                                        String _addressEditingController =
                                            "jjj";
                                      },
                                      controller: _addressEditingController,
                                      maxLength: 15,
                                      enabled: !_status,
                                      autofocus: !_status,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.water_damage_rounded),
                                        border: OutlineInputBorder(),
                                        hintText: 'Address',
                                        labelText: _addressEditingController
                                            .toString(),
                                      ),
                                      validator: (String value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        // FirstName = value;
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Save"),
                // textColor: Colors.white,
                // color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    buildShowDialog(context);
                    saveUser();
                    Navigator.of(context).pop();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                // shape: new RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: new Text("Cancel"),
                // textColor: Colors.white,
                // color: Colors.red,
                //     shape: new RoundedRectangleBorder(
                //         borderRadius: new BorderRadius.circular(20.0)),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
