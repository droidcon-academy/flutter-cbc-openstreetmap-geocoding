import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class AddressSearchWidget extends StatefulWidget {
  const AddressSearchWidget({super.key});

  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  TextEditingController _searchController = TextEditingController();
  List<SearchInfo> _suggestions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OSM plugin"),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchTextChanged,
                decoration: const InputDecoration(
                  hintText: 'Enter address...',
                ),
              ),
              const SizedBox(height: 10),
              _buildSuggestionsList(),
            ],
          ),
        ),
      ),
    ),
     
    );
  }

  void _onSearchTextChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = []; // Clear suggestions if search query is empty
      });
      return;
    }

    try {
      // Get search suggestions based on the user's input
      List<SearchInfo> suggestions = await getAddressSuggestions(query);
      setState(() {
        _suggestions = suggestions; // Update suggestions list with new results
      });
    } catch (e) {
      // Handle error
      print('Error fetching search suggestions: $e');
    }
  }

  Widget _buildSuggestionsList() {
    if (_suggestions.isEmpty) {
      return Text('No suggestions found');
    }

    return SizedBox(
      height: 200,
      child: Expanded(
        child: ListView.builder(
          itemCount: _suggestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_suggestions[index].address.toString()),
              // subtitle: Text(_suggestions[index].address),
              onTap: () {
                // Handle selection of a suggestion
                _handleSelectedSuggestion(_suggestions[index]);
              },
            );
          },
        ),
      ),
    );
  }

  void _handleSelectedSuggestion(SearchInfo suggestion) {
    // Do something with the selected suggestion, such as filling a form field
    _searchController.text = suggestion.address.toString();
    // Optionally, clear suggestions list after selection
    setState(() {
      _suggestions = [];
    });
  }

  Future<List<SearchInfo>> getAddressSuggestions(String query) async {
  // Call the addressSuggestion function from the flutter_osm_plugin package
  List<SearchInfo> suggestions = await addressSuggestion(query);
  // Return the list of suggestions
  return suggestions;
}
}
