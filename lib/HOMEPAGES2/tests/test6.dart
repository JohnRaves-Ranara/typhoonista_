import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';
import '../entities2/new/Location.dart';
import '../entities2/new/GetLocations.dart';

class test6 extends StatefulWidget {
  const test6({super.key});

  @override
  State<test6> createState() => _test6State();
}

class _test6State extends State<test6> {
  final ctrlr = TextEditingController();
  bool isSearchLocation = false;
  late List<Location> provinces;
  late List<Location> municipalities;
  List<Location> provinceSuggestions = [];
  Location? selectedProvince;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ElevatedButton(
          child: Text("CLICK"),
          onPressed: (() async {
            setState(() {
              isLoading = true;
            });
            provinces = await GetLocations().getLocations();
            setState(() {
              isLoading = false;
            });
            showLocationDialog();
          }),
        ),
        Text(selectedProvince?.provName ?? "NO SELECTED PROVINCE")
      ],
    ));
  }

  showLocationDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: (isLoading == true)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: StatefulBuilder(
                      builder: (context, customState) {
                        return Column(
                          children: [
                            (isSearchLocation)
                                ? Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            style: textStyles.lato_regular(
                                                fontSize: 14,
                                                color: Colors.black),
                                            maxLength: 30,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Search Location...",
                                                counterText: ""),
                                            controller: ctrlr,
                                            onChanged: (value) =>
                                                searchProvince(
                                                    value.trim(), customState),
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            setState(() {
                                              isSearchLocation = false;
                                              ctrlr.clear();
                                            });
                                          }),
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Icon(Icons.close),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Select Typhoon Province',
                                                style: textStyles.lato_bold(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            setState(() {
                                              isSearchLocation = true;
                                            });
                                          }),
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Icon(Icons.search),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            Divider(
                              color: Colors.grey.shade700,
                            ),
                            Expanded(
                                child: ListView(
                                    primary: false,
                                    children: (ctrlr.text.trim() == "")
                                        ? provinces
                                            .map((province) => ListTile(
                                                  title: Text(province.provName,
                                                      style: textStyles
                                                          .lato_regular(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black)),
                                                  onTap: (() {
                                                    setState(() {
                                                      selectedProvince =
                                                          province;
                                                      Navigator.pop(context);
                                                    });
                                                  }),
                                                ))
                                            .toList()
                                        : provinceSuggestions
                                            .map((province) => ListTile(
                                                  title: Text(province.provName,
                                                      style: textStyles
                                                          .lato_regular(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black)),
                                                  onTap: (() {
                                                    setState(() {
                                                      selectedProvince =
                                                          province;
                                                      Navigator.pop(context);
                                                    });
                                                  }),
                                                ))
                                            .toList()))
                          ],
                        );
                      },
                    ),
                  ),
          );
        });
  }

  searchProvince(String query, Function customState) {
    setState(() {
      provinceSuggestions = provinces.where((province) {
        final provName = province.provName.toLowerCase();
        final input = query.toLowerCase();
        return provName.contains(input);
      }).toList();
    });
  }
}
