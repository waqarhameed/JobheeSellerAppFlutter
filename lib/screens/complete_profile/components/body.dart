import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobheeseller/constants.dart';
import 'package:jobheeseller/helper/keyboard.dart';
import 'package:jobheeseller/models/seller_model.dart';
import 'package:jobheeseller/services/map_services.dart';
import 'package:jobheeseller/services/services.dart';
import 'package:path/path.dart' as path;

import '../../../size_config.dart';

class Body extends StatefulWidget {
 // const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.ref().child(kJob).child(kSeller);
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String uid;
  String firstName;
  String address;
  String description;
  ImagePicker image = ImagePicker();
  File file;
  GoogleMapController _mapController;
  String myImageUrl = "";
  bool visible = true;
  TextEditingController _addressEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  TextEditingController _nameEditingController = TextEditingController();
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(31.524316907751494, 74.34614056040162),
    zoom: 11.5,
  );

  onMapCreated(GoogleMapController ctr) async {
    try {
      _mapController = ctr;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _loadCurrentUserData();
    super.initState();
  }

  getImage() async {
    try {
      var img = await image.pickImage(source: ImageSource.gallery);
      setState(() {
        file = File(img.path);
      });
    } catch (e) {
      print(e + " " + file);
    }
  }

  saveUser() async {
    String myUrl;
    String fileName;
    if (file != null) {
      fileName = path.basename(file.path);
      var imageFile =
          await FirebaseStorage.instance.ref().child("PicUrl").child(fileName);
      UploadTask task = imageFile.putFile(file);
      TaskSnapshot snapshot = await task;
      //for downloading
      try {
        await snapshot.ref.getData();
      } catch (e) {
        print(e);
      }

      if (snapshot != null) {
        myUrl =
            await snapshot.ref.getDownloadURL().onError((error, stackTrace) {
          return error;
        });
      } else {
        print('snapshot2 =' + snapshot.toString());
      }
      await FirebaseStorage.instance
          .ref()
          .child("PicUrl")
          .child(myImageUrl)
          .delete()
          .whenComplete(() => _firebaseDatabase.child(uid).update({
                "name": _nameEditingController.text,
                "address": _addressEditingController.text,
                "businessDescription": _descriptionEditingController.text,
                "picUrl": myUrl,
              })).whenComplete(() => print('Completed upload'));
    } else {
      _firebaseDatabase.child(uid).update({
        "name": _nameEditingController.text,
        "address": _addressEditingController.text,
        "businessDescription": _descriptionEditingController.text,
      }).whenComplete(() => print('Update Complete'));
    }
    _loadCurrentUserData();
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
                          if (_status == false) {
                            getImage();
                          }
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
                                      radius: 80,
                                      backgroundImage: file != null
                                          ? myImageUrl != null
                                              ? FileImage(File(file.path))
                                              : NetworkImage("")
                                          : NetworkImage(myImageUrl)),
                                ),
                              ],
                            ),
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
                                      controller: _nameEditingController,
                                      maxLength: 20,
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
                                      controller: _descriptionEditingController,
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
                                      onTap: () async {
                                        var result = await MapService.instance
                                            .getCurrentPosition();
                                        String myLocation = result.street +
                                            "," +
                                            result.city +
                                            "," +
                                            result.country +
                                            "," +
                                            result.state;
                                        setState(() {
                                          _addressEditingController.text =
                                              myLocation;
                                        });
                                        showGeneralDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            pageBuilder: (BuildContext context,
                                                Animation first,
                                                Animation second) {
                                              return mapControllerWidget(
                                                  context);
                                            });
                                      },
                                      readOnly: true,
                                      controller: _addressEditingController,
                                      maxLength: 60,
                                      enabled: !_status,
                                      autofocus: !_status,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.water_damage_rounded),
                                        border: OutlineInputBorder(),
                                        labelText: 'Address',
                                      ),
                                      validator: (String value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field cannot be empty';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        address = value;
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
    if (_mapController != null) {
      _mapController.dispose();
    }
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
                onPressed: () {
                  setState(() {
                    _status = true;
                    buildShowDialog(context);
                    saveUser();
                    Navigator.of(context).pop();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
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

  void _loadCurrentUserData() async {
    uid = await MyDatabaseService.getCurrentUser();
    if (uid != null) {
      await _firebaseDatabase.child(uid).once().then((event) {
        final data = new Map<String, dynamic>.from(event.snapshot.value);
        final result = Seller.fromJson(data);
        setState(() {
          _nameEditingController.text = result.name;
          _addressEditingController.text = result.address;
          _descriptionEditingController.text = result.description;
          myImageUrl = result.picUrl;
        });
      });
    } else {
      print('Uid =' + uid);
    }
  }

  mapControllerWidget(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        color: Colors.blue,
        child: Stack(children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
            markers: MapService.instance.markers.value ?? {},
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.screenWidth - 23,
                      height: SizeConfig.screenHeight * 0.1,
                      child: TextFormField(
                        keyboardAppearance: KeyboardUtil.hideKeyboard(context),
                        controller: _addressEditingController,
                        readOnly: true,
                        onTap: () async {
                          Navigator.of(context).pop();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          label: Text(_addressEditingController.text),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Icon(
                              Icons.add_location,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
