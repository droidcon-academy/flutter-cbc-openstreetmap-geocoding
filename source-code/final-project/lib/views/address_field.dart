import 'package:flutter/material.dart';
import 'package:osm_address/models/address_info.dart';
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
                    ))
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
    if (!_showResults) {
      return const Text("No results found");
    }
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            onTap: () {
              _places.clear();
              setState(() {}); 
            },
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _places.length,
          itemBuilder: (context, index) {
            final place = _places[index];
            return Column(
              children: [
                ListTile(
                  title: Text(place.displayName), 
                  subtitle: Text(
                      '${place.houseAddress}, ${place.state}, ${place.country}'), 
                  onTap: () {
                    final addressInfo = AddressInfo(
                        houseAddress: place.houseAddress,
                        state: place.state,
                        country: place.country,
                        displayName: place.displayName);

                        _handleSelectedPlace(context, addressInfo);
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                  leading: const SizedBox(), 
                  minVerticalPadding: 0,
                ),
                const Divider(), 
              ],
            );
          },
        )
      ],
    );
  }

void _handleSelectedPlace(BuildContext context, AddressInfo addressInfo) {	
  viewModel.displayAddressController.text = addressInfo.displayName;
  setState(() {
    viewModel.displayAddressController.text = addressInfo.displayName;
    viewModel.stateController.text = addressInfo.state;
    viewModel.countryController.text = addressInfo.country;

    if(_places.isNotEmpty){
        _places[0].houseAddressController.text = addressInfo.houseAddress;
        _places[0].stateController.text = addressInfo.state;
        _places[0].countryController.text = addressInfo.state;
      }
      _showResults = false;
  });
}
}
