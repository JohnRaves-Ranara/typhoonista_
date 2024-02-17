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
  final provinceController = TextEditingController();
  bool isSearchLocationProvince = false;
  List<Location> provinces = [];
  List<Location> municipalities = [];
  List<Location> provinceSuggestions = [];
  List<Location> municipalitySuggestions = [];
  Location? selectedProvince;
  bool isLoadingProvinces = false;
  Location? selectedMunicipality;
  bool isLoadingMunicipalities = false;
  bool isSearchLocationMunicipality = false;
  final municipalityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text("add"),
        onPressed: (() {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    width: 500,
                    height: 500,
                    child: StatefulBuilder(
                      builder: (context, customState1) {
                        return Column(
                          children: [
                            ElevatedButton(
                              child: Text("SELECT PROVINCE"),
                              onPressed: (() async {
                                setState(() {
                                  isLoadingProvinces = true;
                                });
                                List<Location> provincesFromJSON =
                                    await GetLocations().getLocations();
                                setState(() {
                                  isLoadingProvinces = false;
                                });
                                provincesFromJSON.forEach((prov) =>
                                    provinces.add(Location(
                                        provID: prov.provID,
                                        provName: prov.provName)));

                                provinces = provinces.toSet().toList();

                                showSelectProvinceDialog(customState1);
                              }),
                            ),
                            Text(selectedProvince?.provName ??
                                "NO SELECTED PROVINCE"),
                            SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                                onPressed: (selectedProvince != null)
                                    ? (() async {
                                        setState(() {
                                          isLoadingMunicipalities = true;
                                        });

                                        List<Location> municipalitiesFromJSON =
                                            await GetLocations().getLocations();
                                        setState(() {
                                          isLoadingMunicipalities = false;
                                        });

                                        municipalities = municipalitiesFromJSON
                                            .where((municipality) =>
                                                municipality.provID ==
                                                selectedProvince!.provID)
                                            .toList();

                                        showSelectMunicipalityDialog(customState1);
                                      })
                                    : null,
                                child: Text("SELECT MUNICIPALITY")),
                            Text(selectedMunicipality?.munName ??
                                "NO SELECTED MUNICIPALITY"),
                          ],
                        );
                      },
                    ),
                  ),
                );
              });
        }),
      ),
    ));
  }

  showSelectProvinceDialog(Function customState1) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: (isLoadingProvinces == true)
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
                            (isSearchLocationProvince)
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
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Search Location...",
                                                  counterText: ""),
                                              controller: provinceController,
                                              onChanged: (value) {
                                                searchProvince(
                                                    value.trim(), customState);
                                              }),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState(() {
                                              isSearchLocationProvince = false;
                                              provinceController.clear();
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
                                                'Select Province',
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
                                            customState(() {
                                              isSearchLocationProvince = true;
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
                              children: (provinceController.text.trim() == "")
                                  ? provinces
                                      .map((province) => ListTile(
                                            title: Text(province.provName!,
                                                style: textStyles.lato_regular(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                            onTap: (() {
                                              customState1(() {
                                                selectedProvince = province;
                                                Navigator.pop(context);
                                              });
                                            }),
                                          ))
                                      .toList()
                                  : (provinceSuggestions.isNotEmpty)
                                      ? provinceSuggestions
                                          .map((province) => ListTile(
                                                title: Text(province.provName!,
                                                    style:
                                                        textStyles.lato_regular(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                onTap: (() {
                                                  customState1(() {
                                                    selectedProvince = province;
                                                    Navigator.pop(context);
                                                  });
                                                }),
                                              ))
                                          .toList()
                                      : [
                                          Center(
                                            child: Text(
                                              '${provinceController.text.trim()} does not exist.',
                                            ),
                                          )
                                        ],
                            ))
                          ],
                        );
                      },
                    ),
                  ),
          );
        });
  }

  showSelectMunicipalityDialog(Function customState1) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: (isLoadingMunicipalities == true)
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
                            (isSearchLocationMunicipality)
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
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      "Search Municipality...",
                                                  counterText: ""),
                                              controller:
                                                  municipalityController,
                                              onChanged: (value) {
                                                searchMunicipality(
                                                    value.trim(), customState);
                                              }),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: (() {
                                            customState(() {
                                              isSearchLocationMunicipality =
                                                  false;
                                              municipalityController.clear();
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
                                                'Select Municipality',
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
                                            customState(() {
                                              isSearchLocationMunicipality =
                                                  true;
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
                              children: (municipalityController.text.trim() ==
                                      "")
                                  ? municipalities
                                      .map((municipality) => ListTile(
                                            title: Text(municipality.munName!,
                                                style: textStyles.lato_regular(
                                                    fontSize: 14,
                                                    color: Colors.black)),
                                            onTap: (() {
                                              customState1(() {
                                                selectedMunicipality =
                                                    municipality;
                                                Navigator.pop(context);
                                              });
                                            }),
                                          ))
                                      .toList()
                                  : (municipalitySuggestions.isNotEmpty)
                                      ? municipalitySuggestions
                                          .map((municipality) => ListTile(
                                                title: Text(
                                                    municipality.munName!,
                                                    style:
                                                        textStyles.lato_regular(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black)),
                                                onTap: (() {
                                                  customState1(() {
                                                    municipality = municipality;
                                                    Navigator.pop(context);
                                                  });
                                                }),
                                              ))
                                          .toList()
                                      : [
                                          Center(
                                            child: Text(
                                              '${municipalityController.text.trim()} does not exist.',
                                            ),
                                          )
                                        ],
                            ))
                          ],
                        );
                      },
                    ),
                  ),
          );
        });
  }

  searchProvince(String query, Function customState) {
    customState(() {
      provinceSuggestions = provinces.where((province) {
        final provName = province.provName!.toLowerCase();
        final input = query.toLowerCase();
        return provName.contains(input);
      }).toList();
    });
  }

  searchMunicipality(String query, Function customState) {
    customState(() {
      municipalitySuggestions = municipalities.where((municipality) {
        final munName = municipality.munName!.toLowerCase();
        final input = query.toLowerCase();
        return munName.contains(input);
      }).toList();
    });
  }
}
