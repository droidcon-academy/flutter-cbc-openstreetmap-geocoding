import 'package:flutter/material.dart';
import 'package:osm_address/viewmodels/base_view_model.dart';

class AddressFieldViewModel extends BaseViewModel {

  late BuildContext context;

  String title = "OSM AddressAutoComplete";

  final displayAddressController = TextEditingController();
  final displayAddressNode = FocusNode();

  final houseAdressController = TextEditingController();
  final houseAdressNode = FocusNode();
  
  final stateController = TextEditingController();
  final stateNode = FocusNode();

  final countryController = TextEditingController();
  final countryNode = FocusNode();

  String? validateAddress(String text) {
    if (text.isEmpty) {
      return "Address cannot be empty";
    }
    return null;
  }
  
}
