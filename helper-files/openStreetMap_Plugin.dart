//OpenStreetMap Package

flutter_osm_plugin: ^0.70.4


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
              onTap: () {
                // Handle selection of a suggestion
                _handleSelectedSuggestion;
              },
            );
          },
        ),
      ),
    );
  }
