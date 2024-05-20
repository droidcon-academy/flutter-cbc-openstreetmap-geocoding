import 'dart:convert';
//import 'package:dio/dio.dart';
import 'package:osm_address/models/address_info.dart';
import 'package:http/http.dart' as http;

class OpenStreetMapService {
  static const String baseUrl = "https://nominatim.openstreetmap.org";

  static Future<List<AddressInfo>> searchByAddress(
      String address, String countryCode) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/search?format=json&q=$address&countrycodes=$countryCode&addressdetails=1&limit=10&namedetails=1&extratags=1'),
    );
    // final url = '$baseUrl/search?format=json&q=$address&countrycodes=$countryCode&addressdetails=1&limit=10&namedetails=1&extratags=1';
    // final response = await Dio().get(url);
    print("API response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((place) {
        final addressInfo = place['address'] as Map<String, dynamic>;

        final houseAddressValues = [
          addressInfo['house_number'],
            addressInfo['house_name'],
            addressInfo['road'],
            addressInfo['place'],
        ];

        final houseAddress = houseAddressValues.where((value) => value != null).join(',');
            

        return AddressInfo(
            houseAddress: houseAddress,
            state: addressInfo['state'] ?? '',
            county: addressInfo['county'] ?? '',
            city: addressInfo['city'] ?? '',
            postalCode: addressInfo['postcode'] ?? '',
            country: addressInfo['country'] ?? '',
            displayName: place['display_name'] ?? '');
      }).toList();
    } else {
      throw Exception('Failed to load address');
    }
  }
}
