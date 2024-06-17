import 'package:flutter/material.dart';
import 'package:osm_address/viewmodels/address_field_viewmodel.dart';
import 'package:osm_address/views/osm_plugin.dart';
import 'package:stacked/stacked.dart';

class AddressField extends StatefulWidget {
  const AddressField({super.key});

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  late AddressFieldViewModel viewModel;

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
                          onChanged: (value) => (),
                          onTap: () {},
                          decoration: const InputDecoration(
                            labelText: "Enter a valid address",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: viewModel.houseAdressController,
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
                          controller: viewModel.stateController,
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
                          controller: viewModel.countryController,
                          focusNode: viewModel.countryNode,
                          decoration: const InputDecoration(
                            labelText: "Country",
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AddressSearchWidget()));
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 1.0,
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text(
                          "OSM Plugin",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ),
            )),
          );
        });
  }
}
