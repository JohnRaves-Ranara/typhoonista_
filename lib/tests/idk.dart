import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';

class idk extends StatefulWidget {
  const idk({super.key});

  @override
  State<idk> createState() => _idkState();
}

class _idkState extends State<idk> {
  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = [
      DateTime.parse('2024-01-07 01:15:16.025'),
      DateTime.parse('2024-01-05 22:05:11.212')
    ];

    final DateTime latest = dates.reduce((currentRecent, dateTime) =>
        dateTime.isAfter(currentRecent) ? dateTime : currentRecent);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height*0.8,
        width: MediaQuery.of(context).size.width*0.8,
        color: Colors.teal.shade50,
        child: StreamBuilder<List<TyphoonDay>>(
          stream: FirestoreService().streamAllDays(),
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              final List<TyphoonDay> allDays = snapshot.data!;
              final List<String> allTyphoonNames = allDays.map((day) => day.typhoonName).toList();
            final List<dynamic> allDayNumbers = allDays.map((day) => day.day).toList();
            final List<String> allLocations = allDays.map((day) => day.location).toList();

            allTyphoonNames.insert(0, 'All');
            allDayNumbers.insert(0, -1);
            allLocations.insert(0, 'All');

            var selectedTyphoonName = 'All';
            var selectedDayNumber = -1;
            var selectedLocation = 'All';

            print(selectedTyphoonName);
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.grey.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.filter_alt),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Filter'),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Typhoon Name'),
                              SizedBox(
                                width: 10,
                              ),
                              DropdownButton(
                                value: selectedTyphoonName,
                                icon: Icon(Icons.arrow_drop_down),
                                items: buildDropdownMenu(allTyphoonNames),
                                onChanged: (newValue){
                                  setState(() {
                                    print("SETSTAT stgart");
                                    selectedTyphoonName = newValue;
                                    print("SETSTAT End");
                                  });
                                })
                            ],
                          ),
                          Row(
                            children: [
                              Text('Day Number'),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                child: Row(
                                  children: [
                                    Text('All'),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Location'),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid)),
                                child: Row(
                                  children: [
                                    Text('All'),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      child: DataTable(
                          border: TableBorder.symmetric(
                              inside: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          showCheckboxColumn: false,
                          columns: [
                            DataColumn(label: Text('Typhoon Name')),
                            DataColumn(label: Text('Day Number')),
                            DataColumn(label: Text('Location')),
                            DataColumn(label: Text('Estimated Damage Cost')),
                          ],
                          rows: allDays
                              .map((day) => DataRow(
                                      onSelectChanged: (bool? newVal) {
                                        //todo this functions must navigate to the day's information page
                                        print(day.damageCost);
                                      },
                                      cells: [
                                        DataCell(Text(day.typhoonName)),
                                        DataCell(Text(day.day.toString())),
                                        DataCell(Text(day.location)),
                                        DataCell(
                                            Text(day.damageCost.toString())),
                                      ]))
                              .toList()),
                    ),
                  ],
                ),
              );
            } else {
              return Text('empty');
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem> buildDropdownMenu(List<String> list){
    return list.map((item) => DropdownMenuItem(
      value: item,
      child: Text((item==-1) ? 'All' : item))).toList();
  }
}
