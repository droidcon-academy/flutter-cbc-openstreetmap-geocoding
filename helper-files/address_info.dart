import 'package:flutter/material.dart';

class AddressInfo {
  final String houseAddress;
  final String state;
  final String country;
  final String displayName;
  final TextEditingController houseAddressController;
  final TextEditingController stateController;
  final TextEditingController countryController;

  AddressInfo({
    required this.houseAddress,
    required this.state,
    required this.country,
    required this.displayName,
    TextEditingController? houseAddressController,
    TextEditingController? stateController,
    TextEditingController? countryController,
  })  : houseAddressController =
            houseAddressController ?? TextEditingController(),
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
    final houseAddress =
        houseAddressValues.where((value) => value != null).join(',');
    return AddressInfo(
        houseAddress: houseAddress,
        state: address['state'] ?? '',
        country: address['country'] ?? '',
        displayName: json['display_name'] ?? '');
  }
}
