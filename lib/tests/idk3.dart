import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/home_pages/dashboard_page/widgets/dashboard_content_widgets/barChart.dart';
import 'package:typhoonista_thesis/services/FirestoreService.dart';
import 'package:provider/provider.dart';
import 'package:typhoonista_thesis/providers/page_provider.dart';

class yada extends StatefulWidget {
  const yada({super.key});

  @override
  State<yada> createState() => _yadaState();
}

class _yadaState extends State<yada> {
  int? selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<List<int>>(
              future: FirestoreService().getTyphoonYears(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final years = snapshot.data!;
                  selectedYear = years.first;
                  context.read<page_provider>().changeSelectedYear(selectedYear!);
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey, width: 1, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      isDense: true,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      borderRadius: BorderRadius.circular(10),
                      value: selectedYear,
                      items: buildMenuItems(years),
                      onChanged: (newValue) {
                        context.read<page_provider>().changeSelectedYear(newValue!);
                        setState(() {
                          selectedYear = newValue;
                        });
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
              ),
              barChart()
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> buildMenuItems(List<int> years) {
    return years
        .map((year) => DropdownMenuItem<int>(
              child: Text(year.toString()),
              value: year,
              onTap: (() {}),
            ))
        .toList();
  }
}
