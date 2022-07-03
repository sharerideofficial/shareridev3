import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
String? currentUid;
String? currentGUid;
GoogleSignInAccount? currentGoogleAccount;

// Firebase Realtime database content but not used yet
FirebaseDatabase fBase = FirebaseDatabase.instance;

DatabaseReference ref = FirebaseDatabase.instance.ref("users");
Map? userdata;
Map? routedata;

Future<Map?> getUserDetails(uid) async {
  DatabaseReference child = ref.child(uid);
  DatabaseEvent event = await child.once();
  userdata = event.snapshot.value as Map?;
  print(userdata!['name']);
  print(userdata!['email']);
  return userdata;
}

void addNewRoute(uid, Set<Polyline> polyline, from, to) async {
  DatabaseReference userData = ref.child(uid);
  DatabaseReference route = userData.child('route');
  String polyString = polyline.toList().toString();
  List latLngSerialized = [];
  List<LatLng> latLngList = polyline.first.points;

  for (var latLng in latLngList) {
    latLngSerialized.add(latLng.latitude);
    latLngSerialized.add(latLng.longitude);
  }

  await route.update({
    "status": "Searching for Rides!",
    "route": latLngSerialized,
    "from": from,
    "to": to
  });
  print('Inside addroute function');

  // DatabaseEvent event = await child.once();
  // userdata = event.snapshot.value as Map?;
  // print(userdata!['name']);
  // print(userdata!['email']);
  // return userdata;
}

Future<void> getRouteDetails(uid) async {
  DatabaseReference userData = ref.child(uid);
  DatabaseReference route = userData.child('route');
  DatabaseEvent event = await route.once();
  routedata = event.snapshot.value as Map?;
  print(routedata);
}
