import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import '../requests/google_maps_requests.dart';
import '../utils/utils.dart';

class AppState with ChangeNotifier {
  static LatLng? _initialPosition;
  static LatLng? _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapController? _mapController;

  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng? get initialPosition => _initialPosition;
  LatLng? get lastPosition => _lastPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};

  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController? get mapController => _mapController;

  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;

  AppState() {
    // _getUserLocation();
    _loadingInitialPosition();
  }

  // ! To GET USERS LOCATION
  void _getUserLocation() async {
    print("hello Get user location");
    loc.Location location = new loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData? _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Location Service not Enabled");
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        print("Location Permission not Granted!");
        return;
      }
    }

    _locationData = await location.getLocation();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    _initialPosition = LatLng(position.latitude, position.longitude);
    String currentLoc = "";
    for (var i = 0; i < 3; i++) {
      currentLoc = currentLoc + placemark[i].name! + ",";
    }
    print(currentLoc);

    locationController.text = currentLoc;
    notifyListeners();
    print("Success");
  }

  // ! ADD a Marker on the map
  void _addMarker(LatLng location, String address) {
    markers.add(Marker(
        markerId: MarkerId(
          _lastPosition.toString(),
        ),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "Go Here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  // ! TO CREATE ROUTES
  void _createRoute(String encodedPoly) {
    _polyLines.clear();
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 5,
        color: Colors.blue,
        points: _convertToLatLng(_decodePoly(encodedPoly))));
    notifyListeners();
  }

  // ! CREATE A LATLANG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];

    for (var i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // ! DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  // !SEND REQUEST
  void sendRequest(
      {required String intendedLocation, String vehicle = "car"}) async {
    List<Location> locations = await locationFromAddress(intendedLocation);
    // List<Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;
    LatLng destination = LatLng(latitude, longitude);

    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition!, destination, vehicle);

    _createRoute(route);
    notifyListeners();
  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // ! Loading Initial Position
  void _loadingInitialPosition() async {
    print("Inside Initial function");
    _getUserLocation();
    await Future.delayed(Duration(seconds: 2)).then((value) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        _loadingInitialPosition();
        notifyListeners();
      }
    });
  }
}
