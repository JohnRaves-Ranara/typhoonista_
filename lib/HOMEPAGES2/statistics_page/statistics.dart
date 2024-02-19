import 'package:flutter/material.dart';
import 'package:typhoonista_thesis/HOMEPAGES2/statistics_page/ath_stats.dart';
import 'package:typhoonista_thesis/assets/themes/textStyles.dart';


class statistics extends StatefulWidget {
  const statistics({super.key});

  @override
  State<statistics> createState() => _statisticsState();
}

class _statisticsState extends State<statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0xfff6f6f6),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ath_stats(),
            ),
          ],
        ),
      ),
    );
  }
}