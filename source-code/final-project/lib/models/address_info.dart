import 'package:flutter/material.dart';

class AddressInfo {
  final String houseAddress;
  final String county;
  final String city;
  final String postalCode;
  final String state;
  final String country;
  final String displayName;
  final TextEditingController houseAddressController;
  final TextEditingController countyController;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  final TextEditingController stateController;
  final TextEditingController countryController;

  AddressInfo({
    required this.houseAddress,
    required this.county,
    required this.city,
    required this.postalCode,
    required this.state,
    required this.country,
    required this.displayName,
    TextEditingController? houseAddressController,
    TextEditingController? countyController,
    TextEditingController? cityController,
    TextEditingController? postalCodeController,
    TextEditingController? stateController,
    TextEditingController? countryController,
  })  : 
        houseAddressController = houseAddressController ?? TextEditingController(),
        countyController = countyController ?? TextEditingController(),
        cityController = cityController ?? TextEditingController(),
        postalCodeController = postalCodeController ?? TextEditingController(),
        stateController = stateController ?? TextEditingController(),
        countryController = countryController ?? TextEditingController();

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>;
    final houseAddressValues = [
          address['house_number'],
            address['house_name'],
            address['road'],
            address['place'],
        ];
        final houseAddress = houseAddressValues.where((value) => value != null).join(',');
    return AddressInfo(
        houseAddress: houseAddress,
        county: address['county'] ?? '',
        city: address['city'] ?? '',
        postalCode: address['postcode'] ?? '',
        state: address['state'] ?? '',
        country: address['country'] ?? '',
        displayName: json['display_name'] ?? '');
  }
}
