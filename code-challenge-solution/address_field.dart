import 'package:flutter/material.dart';
import 'package:osm_address/models/address_info.dart';
import 'package:osm_address/osm_plugin.dart';
import 'package:osm_address/services/openstreetmap_service.dart';
import 'package:osm_address/viewmodels/address_field_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AddressField extends StatefulWidget {
  const AddressField({super.key});

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  late AddressFieldViewModel viewModel;
  
  bool _showResults = false;
  List<AddressInfo> _places = [];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressFieldViewModel>.reactive(
        viewModelBuilder: () => AddressFieldViewModel(),
        onViewModelReady: (viewModel) {
          this.viewModel = viewModel;
        },
        builder: (context, _, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.title),
            ),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  children: [
                    Form(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: viewModel.displayAddressController,
                          focusNode: viewModel.displayAddressNode,
                          validator: (value) =>
                              viewModel.validateAddress(value!),
                          onChanged: (address) => 
                            _onAddressSearch(address)
                          ,
                          onTap: () {
                            // Set showResults to true when the text field is tapped
                             setState(() {
                               _showResults = true;
                             });
                          },
                          decoration: const InputDecoration(
                            labelText: "Enter a valid address",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        if (_showResults )
                          _buildPlacesList(),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller:  _places.isNotEmpty ? _places[0].houseAddressController : TextEditingController(),
                          focusNode: viewModel.houseAdressNode,
                          decoration: const InputDecoration(
                            labelText: "House Address",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        //Code challenge 
                         TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller:  _places.isNotEmpty ? _places[0].countyController : TextEditingController(),
                          focusNode: viewModel.countyNode,
                          decoration: const InputDecoration(
                            labelText: "County",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller:  _places.isNotEmpty ? _places[0].cityController : TextEditingController(),
                          focusNode: viewModel.cityNode,
                          decoration: const InputDecoration(
                            labelText: "City",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: _places.isNotEmpty ? _places[0].postalCodeController : TextEditingController(),
                          focusNode: viewModel.postalCodeNode,
                          decoration: const InputDecoration(
                            labelText: "Postal code",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller:  _places.isNotEmpty ? _places[0].stateController : TextEditingController(),
                          focusNode: viewModel.stateNode,
                          decoration: const InputDecoration(
                            labelText: "State",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller:  TextEditingController(text: _places.isNotEmpty ? _places[0].country : ""),
                          focusNode: viewModel.countryNode,
                          decoration: const InputDecoration(
                            labelText: "Country",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 16,),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => const AddressSearchWidget()));
                        }, 
                        style: OutlinedButton.styleFrom(
                            elevation: 1.0,
                            backgroundColor: Colors.blueAccent,
                             ),
                        child: const Text("OSM Plugin",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)
                        )
                  ],
                ),
              ),
            )),
          );
        });
  }

  Future<List<AddressInfo>> _onAddressSearch(String address) async {
    if (address.isNotEmpty) {
      try {
        const countryCode = "us";
        final results =
            await OpenStreetMapService.searchByAddress(address, countryCode);
          setState(() {
            _places = results;
          });
      } catch (e) {
        print(e.toString());
      }
    }
    return _places;
  }

  Widget _buildPlacesList() {
    // Check if there are no results to display
    if (!_showResults) {
      // If no results are found, display a message indicating so
      return const Text("No results found");
    }

    // If there are results, build a list of places
    return Column(
      children: [
        // Close button to clear the search results
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            onTap: () {
              // Clear the search results when the close button is tapped
              _places.clear();
              setState(() {}); // Trigger a UI update
            },
          ),
        ),
        // List of search results
        ListView.builder(
          shrinkWrap: true,
          itemCount: _places.length,
          itemBuilder: (context, index) {
            // Get the current place from the list of places
            final place = _places[index];
            // Build a ListTile for the current place
            return Column(
              children: [
                ListTile(
                  title: Text(place.displayName), // Display the place's name
                  subtitle: Text(
                      '${place.houseAddress}, ${place.state}, ${place.country}'), // Display the place's address details
                  onTap: () {
                    // Handle onTap event (optional)
                    final addressInfo = AddressInfo(
                        houseAddress: place.houseAddress,
                        county: place.county,
                        city: place.city,
                        postalCode: place.postalCode,
                        state: place.state,
                        country: place.country,
                        displayName: place.displayName);

                        _handleSelectedPlace(context, addressInfo);
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                  leading: const SizedBox(), // Hide the leading icon
                  minVerticalPadding: 0,
                ),
                const Divider(), // Add a divider between each place
              ],
            );
          },
        ),
      ],
    );
  }

void _handleSelectedPlace(BuildContext context, AddressInfo addressInfo) {	
  // Set the text of the address input field to the selected place's display name
  viewModel.displayAddressController.text = addressInfo.displayName;
  // Update the state and country input fields with the selected place's information
  setState(() {
    viewModel.displayAddressController.text = addressInfo.displayName;
    viewModel.countyController.text = addressInfo.county;
    viewModel.cityController.text = addressInfo.city;
    viewModel.postalCodeController.text = addressInfo.postalCode;
    viewModel.stateController.text = addressInfo.state;
    viewModel.countryController.text = addressInfo.country;

    if(_places.isNotEmpty){
        _places[0].houseAddressController.text = addressInfo.houseAddress;
        _places[0].countyController.text = addressInfo.county;
        _places[0].cityController.text = addressInfo.city;
        _places[0].postalCodeController.text = addressInfo.postalCode;
        _places[0].stateController.text = addressInfo.state;
        _places[0].countryController.text = addressInfo.state;
      }
      _showResults = false;
  });
}
}
