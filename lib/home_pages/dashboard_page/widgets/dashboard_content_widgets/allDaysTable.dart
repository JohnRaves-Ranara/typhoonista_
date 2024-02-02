import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:typhoonista_thesis/entities/TyphoonDay.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';

class allDaysTable extends StatefulWidget {
  const allDaysTable({super.key});

  @override
  State<allDaysTable> createState() => _allDaysTableState();
}

class _allDaysTableState extends State<allDaysTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // color: Colors.amber,
        width: double.maxFinite,
        child: StreamBuilder<List<TyphoonDay>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc('test-user')
              .collection('allDays')
              .orderBy('dateRecorded', descending: true)
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
            else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: SpinKitSpinningLines(size: 50, lineWidth: 3.5, color: Colors.blue));
            }
             else {
              final List<TyphoonDay> days = snapshot.data!;
              return DataTable(
                border: TableBorder(
                  
                  top: BorderSide(color: Color(0xff898c8a), style: BorderStyle.solid, width: 1, )),
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                        label: Text(
                      'Typhoon Name',
                      style: textStyles.lato_bold(),
                    )),
                    DataColumn(
                        label: Text('Day Number', style: textStyles.lato_bold())),
                    DataColumn(
                        label: Text('Location', style: textStyles.lato_bold())),
                    DataColumn(
                        label:
                            Text('Damage Cost', style: textStyles.lato_bold())),
                  ],
                  rows: days
                      .map((day) => DataRow(
                              cells: [
                                DataCell(Text(day.typhoonName,
                                    style: textStyles.lato_regular())),
                                DataCell(Text(day.day.toString(),
                                    style: textStyles.lato_regular())),
                                DataCell(Text(day.location,
                                    style: textStyles.lato_regular())),
                                DataCell(Text('${NumberFormat('#,##0.00', 'en_US').format(day.damageCost)}',
                                    style: textStyles.lato_regular()))
                              ]))
                      .toList());
            }
          },
        ),
      ),
    );
  }
}
