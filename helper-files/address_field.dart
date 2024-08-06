
// onAddressSearch() method
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

//buildPlaces list widget
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

//handleSelectedPlace() method
  void _handleSelectedPlace(BuildContext context, AddressInfo addressInfo) {
    viewModel.displayAddressController.text = addressInfo.displayName;
    setState(() {
      viewModel.displayAddressController.text = addressInfo.displayName;
      viewModel.houseAdressController.text = addressInfo.houseAddress;
      viewModel.stateController.text = addressInfo.state;
      viewModel.countryController.text = addressInfo.country;

      if (_places.isNotEmpty) {
        _places[0].houseAddressController.text = addressInfo.houseAddress;
        _places[0].stateController.text = addressInfo.state;
        _places[0].countryController.text = addressInfo.country;
      }
      _showResults = false;
    });
  }
