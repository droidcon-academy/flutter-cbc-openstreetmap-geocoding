import 'package:flutter/material.dart';
//import 'package:osm_address/osm_plugin.dart';
import 'package:osm_address/views/address_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSM Address Autocomplete',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const AddressField(),
      //home: const AddressSearchWidget(), //uncomment to display address search using osm plugin
    );
  }
}
