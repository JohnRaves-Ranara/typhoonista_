import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class history_page extends StatefulWidget {
  const history_page({super.key});

  @override
  State<history_page> createState() => _history_pageState();
}

class _history_pageState extends State<history_page> {
  String selectedTyphoonName = 'All';
  dynamic selectedDayNumber = 'All';
  String selectedLocation = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.maxFinite,
              // color: Colors.teal,
              child: StreamBuilder<List<TyphoonDay>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc('test-user')
                      .collection('allDays')
                      .snapshots()
                      .map((snapshot) => snapshot.docs
                          .map((doc) => TyphoonDay.fromJson(doc.data()))
                          .toList()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('An error has occured.', style: textStyles.lato_regular(fontSize: 16),));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Data.', style: textStyles.lato_regular(fontSize: 16),));
                    }
                    else if (snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: SpinKitSpinningLines(size: 50, lineWidth: 3.5, color: Colors.blue));
                    }
                     else {
                      final List<TyphoonDay> days = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text('Filters', style: textStyles.lato_bold(),),
                              SizedBox(width: 20,),
                              Icon(Icons.filter_list_outlined)
                            ],
                          ),
                          Row(
                            children: [
                              Text('Typhoon Name', style: textStyles.lato_bold() ),
                              SizedBox(width: 20,),
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),borderRadius: BorderRadius.circular(10),),
                                child: DropdownButton<dynamic>(
                                    isDense: true,
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    borderRadius: BorderRadius.circular(10),
                                    value: selectedTyphoonName,
                                    items: buildMenuItems(days, 'typhoonName'),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedTyphoonName = newValue!;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Day Number', style: textStyles.lato_bold() ),
                              SizedBox(width: 20,),
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),borderRadius: BorderRadius.circular(10),),
                                child: DropdownButton<dynamic>(
                                    isDense: true,
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    borderRadius: BorderRadius.circular(10),
                                    value: selectedDayNumber,
                                    items: buildMenuItems(days, 'dayNumber'),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedDayNumber = newValue!;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Location', style: textStyles.lato_bold() ),
                              SizedBox(width: 20,),
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),borderRadius: BorderRadius.circular(10),),
                                child: DropdownButton<dynamic>(
                                    isDense: true,
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    borderRadius: BorderRadius.circular(10),
                                    value: selectedLocation,
                                    items: buildMenuItems(days, 'location'),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedLocation = newValue!;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          
                        ],
                      );
                    }
                  }),
            ),
            SizedBox(height: 30,),
            Expanded(
              child: StreamBuilder<List<TyphoonDay>>(
                stream: daysStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('An error has occured.', style: textStyles.lato_regular(fontSize: 16),));
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: SpinKitSpinningLines(size: 50, lineWidth: 3.5, color: Colors.blue));
                  } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return Center(child: Text('No Data.', style: textStyles.lato_regular(fontSize: 16),));
                  } 
                  else {
                    final List<TyphoonDay> days = snapshot.data!;
                    return Container(
                      width: double.maxFinite,
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: 
                      [
                        DataColumn(label: Text('Typhoon Name', style: textStyles.lato_bold(),)),
                        DataColumn(label: Text('Day Number', style: textStyles.lato_bold())),
                        DataColumn(label: Text('Location', style: textStyles.lato_bold())),
                        DataColumn(label: Text('Damage Cost', style: textStyles.lato_bold())),
                      ]
                      , rows: days.map((day) => DataRow(
                        // selected: false,
                        onSelectChanged: (isSelected) {
                          //todo
                          print(day.damageCost);
                        },
                        cells: [
                          DataCell(Text(day.typhoonName, style: textStyles.lato_regular())),
                          DataCell(Text(day.day.toString(), style: textStyles.lato_regular())),
                          DataCell(Text(day.location, style: textStyles.lato_regular())),
                          DataCell(Text('${NumberFormat('#,##0.00', 'en_US').format(day.damageCost)}', style: textStyles.lato_regular()))
                        ]
                       )).toList()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<dynamic>> buildMenuItems(
    List<TyphoonDay> days, String type) {
    var list = [];
    late List<DropdownMenuItem<dynamic>> returnList = [];
    Set listSet;
    switch (type) {
      case "location":
        listSet = Set.from(days.map((day) => day.location).toList());
        listSet.forEach((day) { list.add(day); });
        list.sort();
        list.insert(0, 'All');
        returnList = list.map((loc) => DropdownMenuItem(child: Text(loc, style: textStyles.lato_regular()), value: loc,)).toList();
        
      case "typhoonName":
        listSet = Set.from(days.map((name) => name.typhoonName).toList());
        listSet.forEach((name) { list.add(name); });
        list.sort();
        list.insert(0, 'All');
        returnList = list.map((name) => DropdownMenuItem(child: Text(name, style: textStyles.lato_regular()), value: name,)).toList();

      case "dayNumber":
        listSet = Set.from(days.map((day) => day.day).toList());
        listSet.forEach((day) { list.add(day); });
        list.sort();
        list.insert(0, 'All');
        returnList = list.map((day) => DropdownMenuItem<dynamic>(child: Text(day.toString(), style: textStyles.lato_regular()), value: day,)).toList();
    }

    return returnList;
  }

  Stream<List<TyphoonDay>> daysStream() {
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc('test-user')
        .collection('allDays')
        ;

    if (selectedDayNumber != 'All') {
      query = query.where('day', isEqualTo: selectedDayNumber);
    }
    if (selectedLocation != 'All') {
      query = query.where('location', isEqualTo: selectedLocation);
    }
    if (selectedTyphoonName != 'All') {
      query = query.where('typhoonName', isEqualTo: selectedTyphoonName);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => TyphoonDay.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
