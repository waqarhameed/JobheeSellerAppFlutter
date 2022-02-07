import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jobheeseller/components/custom_surfix_icon.dart';
import 'package:jobheeseller/components/default_button.dart';
import 'package:jobheeseller/helper/keyboard.dart';
import 'package:jobheeseller/screens/home/home_screen.dart';
import 'package:jobheeseller/services/map_services.dart';
import 'package:jobheeseller/services/services.dart';
import 'package:path/path.dart' as path;

import '../../../constants.dart';
import '../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ImagePicker image = ImagePicker();
  File file;
  DatabaseReference _firebaseDatabase =
      FirebaseDatabase.instance.ref().child(kJob).child(kSeller);

  String uuid;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  double lat, lng;
  String myLocation;
  GoogleMapController _mapController;
  TextEditingController _showMyAddress = new TextEditingController();
  TextEditingController _editingControllerMapAddress =
      new TextEditingController();
  TextEditingController _editingControllerName = new TextEditingController();
  TextEditingController _editingControllerBusType = new TextEditingController();
  TextEditingController _editingControllerBusDescription =
      new TextEditingController();
  FirebaseMessaging firebaseMessaging;
  var token;
  String url;
  bool _load = false;
  var bitmapIcon;
  final currentAddressController = TextEditingController();
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(31.524316907751494, 74.34614056040162),
    zoom: 11.5,
  );

  _animateCamera(LatLng latLng) async {
    await _mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(latLng.latitude, latLng.longitude), zoom: 11.5),
    ));

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    uuid = await MyDatabaseService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _load
          ?  LinearProgressIndicator()
          : Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 160.0,
                      color: Colors.white,
                      child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child:
                                Stack(fit: StackFit.loose, children: <Widget>[
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
                                          ? AssetImage(
                                              "assets/images/Profile Image.png")
                                          : FileImage(File(file.path),
                                              scale: 1.0),
                                      onForegroundImageError:
                                          (exception, stackTrace) {
                                        if (exception.toString() == null) {
                                          addError(error: kAddressNullError);
                                          return "";
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 110.0, right: 120.0),
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
                    SizedBox(height: getProportionateScreenHeight(30)),
                    Padding(
                        child: buildFirstNameFormField(),
                        padding: EdgeInsets.symmetric(horizontal: 8.0)),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Padding(
                        child: buildBusinessTypeFormField(),
                        padding: EdgeInsets.symmetric(horizontal: 8.0)),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Padding(
                        child: buildBusDescriptionFormField(),
                        padding: EdgeInsets.symmetric(horizontal: 8.0)),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Padding(
                        child: buildMapAddressFormField(),
                        padding: EdgeInsets.symmetric(horizontal: 8.0)),
                    SizedBox(height: getProportionateScreenHeight(40)),
                    Padding(
                        child: DefaultButton(
                          text: "continue",
                          press: () async {
                            if (file == null) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Message"),
                                        content: Text("please attach your pic"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('OK')),
                                        ],
                                      ));
                            } else if (_formKey.currentState.validate()) {
                              setState(() {
                                _load = true;
                              });
                              //start progress bar
                              String url = await uploadImageFileToDatabase();
                              if (url != null) {
                                uploadDataToFirebaseDatabase(url);
                              } else {
                                print('upload Data To Firebase Failed');
                                setState(() {
                                  _load = false;
                                });
                                Navigator.pushNamed(
                                    context, HomeScreen.routeName);
                              }
                            }
                          },
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.0)),
                    SizedBox(height: getProportionateScreenHeight(20)),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: _editingControllerName,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNameNullError);
          return "";
        }
        return null;
      },
      maxLength: 15,
      inputFormatters: [FilteringTextInputFormatter.allow(textPattern)],
      decoration: InputDecoration(
        labelText: "First Name",
        hintText: '',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildBusinessTypeFormField() {
    return TextFormField(
      controller: _editingControllerBusType,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kBusTypeNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kBusTypeNullError);
          return "";
        }
        return null;
      },
      maxLength: 15,
      inputFormatters: [FilteringTextInputFormatter.allow(textPattern)],
      decoration: InputDecoration(
        labelText: "Business Type",
        hintText: '',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildBusDescriptionFormField() {
    return TextFormField(
      controller: _editingControllerBusDescription,
      //onSaved: (newValue) => busDescription = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kBusTypeNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kBusTypeNullError);
          return "";
        }
        return null;
      },
      maxLength: 15,
      inputFormatters: [FilteringTextInputFormatter.allow(textPattern)],
      decoration: InputDecoration(
        labelText: "Business Description",
        hintText: "",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  buildMapAddressFormField() {
    return TextFormField(
      controller: _editingControllerMapAddress,
      readOnly: true,
      onTap: () async {
        _load = true;
        var result = await MapService.instance.getCurrentPosition();
        myLocation = result.city +
            "," +
            result.street +
            "," +
            result.country +
            "," +
            result.state;
        _showMyAddress.text = myLocation;
        print(result.latLng);
        lat = result.latLng.latitude;
        lng = result.latLng.longitude;
        _load = false;
        showGeneralDialog(
            context: context,
            barrierDismissible: false,
            pageBuilder:
                (BuildContext context, Animation first, Animation second) {
              return mapControllerWidget(context);
            });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kMapAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kMapAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Map Address",
          hintText: _editingControllerMapAddress.text),
    );
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
                        controller: _showMyAddress,
                        readOnly: true,
                        onTap: () async {
                          if (myLocation == null) {
                            var result =
                                await MapService.instance.getCurrentPosition();
                            myLocation = result.street +
                                "," +
                                result.city +
                                "," +
                                result.country +
                                "," +
                                result.state;
                            _showMyAddress.text = myLocation;
                            _animateCamera(result.latLng);
                            if (result != null) {
                              popAlert(context);
                            }
                          } else {
                            _editingControllerMapAddress.text = myLocation;
                            Future.delayed(Duration(milliseconds: 500));
                            popAlert(context);
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          label: _load
                              ? CircularProgressIndicator()
                              : Text(_showMyAddress.text),
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

  // creating and getting location map
  onMapCreated(GoogleMapController ctr) async {
    try {
      _mapController = ctr;
      _animateCamera(LatLng(lat, lng));
    } catch (e) {
      print(e);
    }
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

  void addError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  popAlert(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<String> uploadImageFileToDatabase() async {
    final String fileName = path.basename(file.path);
    firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('PicUrl')
        .child(fileName);
    UploadTask task2 = reference.putFile(file);
    TaskSnapshot snapshot2 = await task2;
    //for downloading url
    await snapshot2.ref.getData().onError((error, stackTrace) {
      return error;
    });
    if (snapshot2 != null) {
      return url =
          await snapshot2.ref.getDownloadURL().onError((error, stackTrace) {
        return error;
      });
    } else {
      print('snapshot2 =');
    }
    return null;
  }

  uploadDataToFirebaseDatabase(String url) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    token = await FirebaseMessaging.instance
        .getToken()
        .onError((error, stackTrace) {
      return error;
    });
    print("my tokens = " + token);
    if (lat != null || lng != null || uuid != null || token != null) {
      try {
        await _firebaseDatabase.child(uuid).set({
          'name': _editingControllerName.text,
          'businessType': _editingControllerBusType.text,
          'businessDescription': _editingControllerBusDescription.text,
          'address': _editingControllerMapAddress.text,
          'completeOrders': 0,
          'onlineStatus': 'online',
          'blockByAdmin': 0,
          'joinTimeStamp': formattedDate,
          'lat': lat,
          'lng': lng,
          'picUrl': url,
          'fcm': token,
          'rating': 0,
          'uuid': uuid
        }).whenComplete(() {
          setState(() {
            _load = false;
          });
          Navigator.pushNamed(context, HomeScreen.routeName);
        }).onError((error, stackTrace) {
          print('uploading to database error=' + error);
          _load = false;
        });
      } catch (e) {
        print('upload user failed he' + e);
        setState(() {
          _load = false;
        });
      }
    } else {
      setState(() {
        _load = false;
      });
      print('failed to create user');
    }
  }

  @override
  void dispose() {
    if (_mapController != null) {
      _mapController.dispose();
    }
    _editingControllerMapAddress.dispose();
    _editingControllerBusDescription.dispose();
    _editingControllerBusType.dispose();
    _editingControllerName.dispose();
    _showMyAddress.dispose();
    super.dispose();
  }
}
