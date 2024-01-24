import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/services/locations_.dart';
import 'package:typhoonista_thesis/entities/Location_.dart';

class idk2 extends StatefulWidget {
  const idk2({super.key});

  @override
  State<idk2> createState() => _idk2State();
}

class _idk2State extends State<idk2> {
  final ctrlr = TextEditingController();
  List<Location_> locs = Locations_().getLocations();
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: ctrlr,
            onChanged: searchbook(ctrlr.text.trim()),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: locs.length,
              itemBuilder: (context, index){
                final loc = locs[index];

                return ListTile(
                  title:Text(loc.munName),
                );
              },
           )
          ),
        ],
      )
    );

    
  }

  searchbook(String query){
    final suggestions = locs.where((loc) {
      final munName = loc.munName.toLowerCase();
      final input = query.toLowerCase();
      return munName.contains(input);
    }).toList();

    setState(() {
      locs = suggestions;
    });
  }
}