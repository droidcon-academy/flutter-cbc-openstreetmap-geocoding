
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
