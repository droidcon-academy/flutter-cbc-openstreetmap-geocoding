

//for debugging purpose
print("API response: ${response.body}");


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
    country: addressInfo['country'] ?? '',
    displayName: place['display_name'] ?? '');
