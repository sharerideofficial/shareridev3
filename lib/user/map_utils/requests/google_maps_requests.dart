import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Grasshopper
const apiKey = "db78f396-faad-4196-b369-698ced99ea62";

class GoogleMapsServices {
  Future<String> getRouteCoordinates(
      LatLng l1, LatLng l2, String vehicle) async {
    String url =
        "https://graphhopper.com/api/1/route?point=${l1.latitude},${l1.longitude}&point=${l2.latitude},${l2.longitude}&vehicle=${vehicle}&debug=true&key=db78f396-faad-4196-b369-698ced99ea62&type=json";
    print(url);
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    return values["paths"][0]["points"];
  }
}
