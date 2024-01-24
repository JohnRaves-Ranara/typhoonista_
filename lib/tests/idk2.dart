import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Location_> suggestions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text("CLICK"),
        onPressed: (() {
          showDummyDialog();
        }),
      ),
    ));
  }

  showDummyDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Center(
              child: ElevatedButton(
                child: Text('show locations'),
                onPressed: (() {
                  showSampleDialog();
                }),
              ),
            ),
          );
        });
  }

  showSampleDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          child: StatefulBuilder(
            builder: (context, customState) {
              return Column(
                children: [
                  TextField(
                    maxLength: 30,
                    decoration: InputDecoration(counterText: ""),
                    controller: ctrlr,
                    onChanged: (value) => searchbook(value.trim(), customState),
                  ),
                  Expanded(
                    child: ListView(
                      primary: false,
                      children: (ctrlr.text.trim() == "")
                            ? locs
                                .map((loc) => ListTile(
                                  onTap: ((){

                                  }),
                                      title: Text(loc.munName!),
                                    ))
                                .toList()
                            : (suggestions.isNotEmpty)
                                ? suggestions
                                    .map((loc) => ListTile(
                                          title: Text(loc.munName!),
                                        ))
                                    .toList()
                                : [
                                    Center(
                                      child: Text(
                                        '${ctrlr.text.trim()} does not exist.',
                                      ),
                                    )
                                  ],
                    
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

searchbook(String query, Function customState) {
    customState(() {
      suggestions = locs.where((loc) {
        final munName = loc.munName!.toLowerCase();
        final input = query.toLowerCase();
        return munName.contains(input);
      }).toList();
    });
  }





}
