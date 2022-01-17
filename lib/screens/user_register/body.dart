import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobheeseller/components/custom_surfix_icon.dart';
import 'package:jobheeseller/components/default_button.dart';
import 'package:jobheeseller/screens/home/home_screen.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

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

  //String firstName;
  //String businessType;
  //String busDescription;
  // String mapAddress;
  double lat, lng;

  Circle circle;

  LocationData location;
  Position currentPosition;
  String myLocation;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;
  GeoCode geoCode = GeoCode();
  Coordinates coordinates;
  Marker marker;
  Location _locationTracker = Location();
  StreamSubscription _locationSubscription;

  TextEditingController _editingControllerMapAddress =
      new TextEditingController();
  TextEditingController _editingControllerName = new TextEditingController();
  TextEditingController _editingControllerBusType = new TextEditingController();
  TextEditingController _showMyAddress = new TextEditingController();
  TextEditingController _editingControllerBusDescription =
      new TextEditingController();
  FirebaseMessaging firebaseMessaging;
  var token;
  String url;
  bool _load = false;
  var bitmapIcon;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(31.524316907751494, 74.34614056040162),
    zoom: 5,
  );

  getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/location.png");
    return byteData.buffer.asUint8List();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    askForLocationPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    token = getDeviceToken();
    // Ask for permission
    //askForLocationPermission();
    // GoogleMap(
    //   myLocationEnabled: true,
    //   initialCameraPosition: null,
    // );
  }

  askForLocationPermission() async {
    if (await Permission.locationAlways.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    } else {
      await Permission.locationAlways.request();
    }
  }

  getCurrentUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        uuid = currentUser.uid;
        print('Uuid of current user = ' + uuid);
      }
    } catch (e) {
      print('current user error hy+ ' + e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _load
          ? Center(
              child: CircularProgressIndicator(),
            )
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
                                // Navigator.pushNamed(
                                //     context, HomeScreen.routeName);
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
      //onSaved: (newValue) => firstName = newValue,
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
      //onSaved: (newValue) => businessType = newValue,
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
      onTap: () {
        showGeneralDialog(
            context: context,
            barrierDismissible: false,
            pageBuilder:
                (BuildContext context, Animation first, Animation second) {
              return mapControllerWidget(context);
            });
      },
      //onSaved: (newValue) => mapAddress = newValue,
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
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onCameraIdle: onMapIdle,
            onMapCreated: onMapCreated,
            markers: Set.of((marker != null) ? [marker] : []),
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
                       controller: _showMyAddress,
                        readOnly: true,
                        onTap: () {
                          if (_showMyAddress.text == null) {
                            var dd = getCurrentLocation();
                            if (dd == null) {
                              popAlert(context);
                            }
                          } else {
                            _editingControllerMapAddress.text = _showMyAddress.text;
                            Future.delayed(Duration(milliseconds: 500));
                            popAlert(context);
                          }
                        },
                        // onChanged: (value) {
                        //   _showMyAddress.text = value;
                        // },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          label: Text(_showMyAddress.text != null
                              ? _showMyAddress.text
                              : ''),
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
  onMapCreated(GoogleMapController ctr) {
    try {
      //_controller.complete(ctr);
      _mapController = ctr;
      if (_mapController != null) {
        getCurrentLocation();
      }
    } catch (e) {
      print(e);
    }
  }

  // getting user current location
  getCurrentLocation() async {
    getMarker().then((data) async {
      bitmapIcon = await BitmapDescriptor.fromBytes(data);
    });
    try {
      location = await _locationTracker.getLocation();
      updateMarker(location);
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      return _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) async {
        if (_controller != null) {
          updateMarker(newLocalData);
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              new CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(newLocalData.latitude, newLocalData.longitude),
                tilt: 0,
                zoom: 18.00,
              ),
            ),
          );
          try {
            final coordinates = await geoCode.reverseGeocoding(
                latitude: newLocalData.latitude,
                longitude: newLocalData.longitude);
            lat = newLocalData.latitude;
            lng = newLocalData.longitude;
            var address = coordinates.streetAddress +
                ' ' +
                coordinates.city +
                ' ' +
                coordinates.countryName +
                ' ' +
                coordinates.postal +
                ' ' +
                coordinates.region;
            myLocation = address;
          } catch (e) {
            print('Reverse Geo coding exception = ' + e.toString());
          }
        }
        setState(() {
          _showMyAddress.text = myLocation;
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied" + e.toString());
      }
    }
  }

  // displaying marker on map current location

  void updateMarker(LocationData newLocalData) async {
    LatLng latLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    if (bitmapIcon != null) {
      this.setState(() {
        marker = Marker(
            markerId: MarkerId("home"),
            position: latLng,
            rotation: newLocalData.headingAccuracy,
            draggable: false,
            zIndex: 2,
            anchor: Offset(0.6, 0.9),
            icon: bitmapIcon);
      });
    } else {
      print('marker is null hy');
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
    await snapshot2.ref.getData();
    if (snapshot2 != null) {
      return url = await snapshot2.ref.getDownloadURL();
    } else {
      print('snapshot2 =');
    }
    return null;
  }

  uploadDataToFirebaseDatabase(String url) async {
    final DateTime date1 = DateTime.now();
    final timestamp1 = date1.millisecondsSinceEpoch;
    final DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(timestamp1 * 1000);
    String dateT = datetime.toString();
    String latI = lat.toString();
    String lngI = lng.toString();
    if (_editingControllerName.text == null ||
        _editingControllerBusType == null ||
        _editingControllerBusDescription == null ||
        _editingControllerMapAddress.text == null ||
        dateT == null ||
        latI == null ||
        lngI == null ||
        token == null ||
        uuid == null) {
      try {
        await _firebaseDatabase.child(uuid).set({
          'name': _editingControllerName.text,
          'businessType': _editingControllerBusType.text,
          'businessDescription': _editingControllerBusDescription.text,
          'address': _editingControllerMapAddress.text,
          'completeOrders': '0',
          'onlineStatus': 'online',
          'blockByAdmin': '0',
          'joinTimeStamp': dateT,
          'lat': latI,
          'lng': lngI,
          'picUrl': url,
          'fcm': token,
          'uuid': uuid
        }).whenComplete(() {
          setState(() {
            _load = false;
          });
          Navigator.pushNamed(context, HomeScreen.routeName);
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

  getDeviceToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      return value;
    });
  }

  onMapIdle() {
    _locationSubscription =
        Future.delayed(Duration(milliseconds: 150)).asStream().listen((_) {
      print('showing map is idle');
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
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
